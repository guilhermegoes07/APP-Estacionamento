import 'package:hive_flutter/hive_flutter.dart';
import 'veiculo.dart';
import 'pagamento.dart';
import 'package:uuid/uuid.dart';

part 'ticket.g.dart';

@HiveType(typeId: 4)
class Ticket {
  @HiveField(0)
  final String codigo;

  @HiveField(1)
  final String veiculo;

  @HiveField(2)
  final Pagamento pagamento;

  @HiveField(3)
  final String cnpjEstacionamento;

  @HiveField(4)
  final String nomeEstacionamento;

  @HiveField(5)
  final bool isEntrada;

  @HiveField(6)
  final DateTime dataHora;

  @HiveField(7)
  final String codigoTransacao;

  @HiveField(8)
  final String qrCode;

  Ticket({
    required this.codigo,
    required this.veiculo,
    required this.pagamento,
    required this.cnpjEstacionamento,
    required this.nomeEstacionamento,
    required this.isEntrada,
    required this.qrCode,
  }) : dataHora = DateTime.now(),
       codigoTransacao = Uuid().v4();

  String get tipo => isEntrada ? 'Entrada' : 'Saída';

  String get status => isEntrada ? 'Em Aberto' : 'Fechado';

  double get valorTotal => pagamento.valor;

  String get formaPagamento => pagamento.formaPagamentoStr;

  String get statusPagamento => pagamento.statusPagamento;
} 