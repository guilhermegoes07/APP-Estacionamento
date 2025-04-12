import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/veiculo.dart';
import '../models/ticket.dart';
import '../models/pagamento.dart';

class EstacionamentoService with ChangeNotifier {
  late Box<Veiculo> _veiculosBox;
  late Box<Pagamento> _pagamentosBox;
  List<Veiculo> _veiculosNoPatio = [];
  double _totalArrecadado = 0.0;
  final List<Ticket> _tickets = [];

  List<Veiculo> get veiculosNoPatio => _veiculosNoPatio;
  double get totalArrecadado => _totalArrecadado;
  List<Ticket> get tickets => _tickets;

  Future<void> initDatabase() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(VeiculoAdapter());
    Hive.registerAdapter(FormaPagamentoAdapter());
    Hive.registerAdapter(PagamentoAdapter());
    Hive.registerAdapter(TicketAdapter());

    _veiculosBox = await Hive.openBox<Veiculo>('veiculos');
    _pagamentosBox = await Hive.openBox<Pagamento>('pagamentos');

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

  Future<bool> registrarEntrada(Veiculo veiculo) async {
    if (_veiculosNoPatio.any((v) => v.placa == veiculo.placa)) {
      return false;
    }

    _veiculosNoPatio.add(veiculo);
    await _veiculosBox.add(veiculo);
    notifyListeners();
    return true;
  }

  Future<bool> registrarSaida(String placa) async {
    final veiculo = _veiculosNoPatio.firstWhere(
      (v) => v.placa == placa,
      orElse: () => Veiculo(placa: '', horaEntrada: DateTime.now()),
    );

    if (veiculo.placa.isEmpty) {
      return false;
    }

    _veiculosNoPatio.remove(veiculo);
    veiculo.horaSaida = DateTime.now();
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
} 