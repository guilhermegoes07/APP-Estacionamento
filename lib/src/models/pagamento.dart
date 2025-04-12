import 'package:hive/hive.dart';

part 'pagamento.g.dart';

@HiveType(typeId: 1)
enum FormaPagamento {
  @HiveField(0)
  dinheiro,
  @HiveField(1)
  pix,
  @HiveField(2)
  debito,
  @HiveField(3)
  credito,
}

@HiveType(typeId: 2)
class Pagamento extends HiveObject {
  @HiveField(0)
  final double valor;

  @HiveField(1)
  final FormaPagamento formaPagamento;

  @HiveField(2)
  final int? parcelas;

  @HiveField(3)
  final String? codigoTransacao;

  @HiveField(4)
  final DateTime dataHora;

  Pagamento({
    required this.valor,
    required this.formaPagamento,
    this.parcelas,
    this.codigoTransacao,
    required this.dataHora,
  });

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'formaPagamento': formaPagamento.index,
      'parcelas': parcelas,
      'codigoTransacao': codigoTransacao,
      'dataHora': dataHora.toString(),
    };
  }

  factory Pagamento.fromMap(Map<String, dynamic> map) {
    return Pagamento(
      valor: map['valor'],
      formaPagamento: FormaPagamento.values[map['formaPagamento']],
      parcelas: map['parcelas'],
      codigoTransacao: map['codigoTransacao'],
      dataHora: DateTime.parse(map['dataHora']),
    );
  }
} 