import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/veiculo.dart';
import '../models/ticket.dart';
import '../models/pagamento.dart';
import 'package:uuid/uuid.dart';

class EstacionamentoService with ChangeNotifier {
  late Box<Veiculo> _veiculosBox;
  late Box<Pagamento> _pagamentosBox;
  late Box<Ticket> _ticketsBox;
  List<Veiculo> _veiculosNoPatio = [];
  double _totalArrecadado = 0.0;
  final List<Ticket> _tickets = [];
  final String cnpjEstacionamento;
  final String nomeEstacionamento;
  final String endereco;
  final String cidadeEstadoCep;
  double _valorHora;

  EstacionamentoService({
    required this.cnpjEstacionamento,
    required this.nomeEstacionamento,
    required this.endereco,
    required this.cidadeEstadoCep,
    required double valorHora,
  }) : _valorHora = valorHora;

  List<Veiculo> get veiculosNoPatio => _veiculosNoPatio;
  double get totalArrecadado {
    final hoje = DateTime.now();
    return _pagamentosBox.values
        .where((pagamento) => 
            pagamento.data.year == hoje.year &&
            pagamento.data.month == hoje.month &&
            pagamento.data.day == hoje.day)
        .fold(0.0, (sum, pagamento) => sum + pagamento.valor);
  }
  List<Ticket> get tickets => _tickets;
  double get valorHora => _valorHora;

  Future<void> initDatabase() async {
    await Hive.initFlutter();

    _veiculosBox = await Hive.openBox<Veiculo>('veiculos');
    _pagamentosBox = await Hive.openBox<Pagamento>('pagamentos');
    _ticketsBox = await Hive.openBox<Ticket>('tickets');

    // Carrega veículos no pátio
    _veiculosNoPatio = _veiculosBox.values
        .where((veiculo) => veiculo.horaSaida == null)
        .toList();

    // Calcula total arrecadado
    _totalArrecadado = _pagamentosBox.values.fold(
      0.0,
      (total, pagamento) => total + pagamento.valor,
    );
  }

  Future<bool> registrarEntradaVeiculo(Veiculo veiculo) async {
    if (_veiculosNoPatio.any((v) => v.placa == veiculo.placa)) {
      return false;
    }

    _veiculosNoPatio.add(veiculo);
    await _veiculosBox.add(veiculo);
    notifyListeners();
    return true;
  }

  Future<bool> registrarSaidaVeiculo(String placa) async {
    final veiculo = _veiculosNoPatio.firstWhere(
      (v) => v.placa == placa,
      orElse: () => Veiculo(placa: '', horaEntrada: DateTime.now()),
    );

    if (veiculo.placa.isEmpty) {
      return false;
    }

    _veiculosNoPatio.remove(veiculo);
    veiculo.horaSaida = DateTime.now();
    veiculo.isNoPatio = false;
    await veiculo.save();
    notifyListeners();
    return true;
  }

  Future<void> registrarPagamento(Pagamento pagamento) async {
    _totalArrecadado += pagamento.valor;
    await _pagamentosBox.add(pagamento);
    notifyListeners();
  }

  Future<List<Veiculo>> buscarHistorico(String placa) async {
    return _veiculosBox.values
        .where((veiculo) => veiculo.placa == placa)
        .toList();
  }

  Future<Veiculo?> buscarVeiculo(String placa) async {
    try {
      return _veiculosNoPatio.firstWhere(
        (veiculo) => veiculo.placa == placa,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Ticket?> buscarTicket(String codigo) async {
    try {
      return _tickets.firstWhere(
        (ticket) => ticket.codigo == codigo,
      );
    } catch (e) {
      return null;
    }
  }

  // Verifica se um veículo está no pátio
  bool isVeiculoNoPatio(String placa) {
    return _veiculosBox.values.any((v) => v.placa == placa && v.isNoPatio);
  }

  // Registra a entrada de um veículo com ticket
  Future<Ticket> registrarEntradaComTicket({
    required String placa,
    required Pagamento pagamento,
    String? fotoPlaca,
    String? fotoVeiculo,
  }) async {
    if (isVeiculoNoPatio(placa)) {
      throw Exception('Veículo já está no pátio');
    }

    if (!Veiculo.validarPlaca(placa)) {
      throw Exception('Placa inválida');
    }

    final veiculo = Veiculo(
      placa: placa,
      horaEntrada: DateTime.now(),
      fotoPlaca: fotoPlaca,
      fotoVeiculo: fotoVeiculo,
      isNoPatio: true,
    );

    await _veiculosBox.add(veiculo);
    _veiculosNoPatio.add(veiculo);
    notifyListeners();

    final ticket = Ticket(
      veiculo: placa,
      pagamento: pagamento,
      codigo: const Uuid().v4(),
      cnpjEstacionamento: cnpjEstacionamento,
      nomeEstacionamento: nomeEstacionamento,
      isEntrada: true,
    );

    await _ticketsBox.add(ticket);
    return ticket;
  }

  // Registra a saída de um veículo com ticket
  Future<Ticket> registrarSaidaComTicket(String codigoTicket) async {
    final ticket = _ticketsBox.values.firstWhere(
      (t) => t.codigo == codigoTicket && t.isEntrada,
      orElse: () => throw Exception('Ticket não encontrado'),
    );

    final veiculo = await _getVeiculo(ticket.veiculo);
    if (veiculo == null) {
      throw Exception('Veículo não encontrado');
    }

    veiculo.horaSaida = DateTime.now();
    veiculo.isNoPatio = false;
    await veiculo.save();

    final ticketSaida = Ticket(
      veiculo: ticket.veiculo,
      pagamento: ticket.pagamento,
      codigo: const Uuid().v4(),
      cnpjEstacionamento: cnpjEstacionamento,
      nomeEstacionamento: nomeEstacionamento,
      isEntrada: false,
    );

    await _ticketsBox.add(ticketSaida);
    return ticketSaida;
  }

  // Busca histórico de um veículo
  List<Ticket> buscarHistoricoVeiculo(String placa) {
    return _ticketsBox.values
        .where((t) => t.veiculo == placa)
        .toList()
      ..sort((a, b) => b.dataHora.compareTo(a.dataHora));
  }

  // Obtém estatísticas do estacionamento
  Map<String, dynamic> getEstatisticas() {
    final veiculosNoPatio = _veiculosBox.values.where((v) => v.isNoPatio).length;
    
    final hoje = DateTime.now();
    final inicioDia = DateTime(hoje.year, hoje.month, hoje.day);
    final fimDia = inicioDia.add(const Duration(days: 1));
    
    final ticketsHoje = _ticketsBox.values.where((t) => 
      t.dataHora.isAfter(inicioDia) && 
      t.dataHora.isBefore(fimDia) &&
      t.isEntrada
    ).toList();

    final ticketsTotal = _ticketsBox.values.length;

    final arrecadacaoHoje = ticketsHoje.fold<double>(
      0, 
      (sum, t) => sum + t.pagamento.valor
    );

    final arrecadacaoTotal = _pagamentosBox.values.fold<double>(
      0,
      (sum, p) => sum + p.valor
    );

    return {
      'veiculosNoPatio': veiculosNoPatio,
      'arrecadacaoHoje': arrecadacaoHoje,
      'ticketsHoje': ticketsHoje.length,
      'arrecadacaoTotal': arrecadacaoTotal,
      'ticketsTotal': ticketsTotal,
    };
  }

  Future<bool> registrarSaida(String placa) async {
    try {
      final veiculo = await _getVeiculo(placa);
      if (veiculo == null) {
        return false;
      }

      veiculo.horaSaida = DateTime.now();
      veiculo.isNoPatio = false;
      await veiculo.save();

      return true;
    } catch (e) {
      print('Erro ao registrar saída: $e');
      return false;
    }
  }

  Future<Veiculo?> _getVeiculo(String placa) async {
    try {
      final box = await Hive.openBox<Veiculo>('veiculos');
      return box.get(placa);
    } catch (e) {
      print('Erro ao buscar veículo: $e');
      return null;
    }
  }

  Future<bool> registrarEntrada(String placa, {required bool isEntrada}) async {
    try {
      final veiculo = await _getVeiculo(placa);
      if (veiculo == null) {
        return false;
      }

      if (isEntrada) {
        veiculo.horaEntrada = DateTime.now();
        veiculo.isNoPatio = true;
      } else {
        veiculo.horaSaida = DateTime.now();
        veiculo.isNoPatio = false;
      }

      await veiculo.save();
      notifyListeners();
      return true;
    } catch (e) {
      print('Erro ao registrar entrada/saída: $e');
      return false;
    }
  }

  // Métodos para configurações
  Future<void> atualizarValorHora(double novoValor) async {
    _valorHora = novoValor;
    notifyListeners();
  }

  double calcularValorTotal(int horas) {
    return _valorHora * horas;
  }

  // Método para verificar e remover veículos com tempo expirado
  Future<void> verificarTemposExpirados() async {
    final agora = DateTime.now();
    final veiculosExpirados = _veiculosNoPatio.where((veiculo) {
      if (veiculo.tempoPago == null) return false;
      final tempoRestante = veiculo.tempoPago! - agora.difference(veiculo.horaEntrada).inHours;
      return tempoRestante <= 0;
    }).toList();

    for (final veiculo in veiculosExpirados) {
      await registrarSaidaVeiculo(veiculo.placa);
    }
  }
} 