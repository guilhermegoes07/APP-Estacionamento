import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'pagamento.g.dart';

@HiveType(typeId: 2)
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

@HiveType(typeId: 3)
class Pagamento {
  @HiveField(0)
  final double valor;

  @HiveField(1)
  final FormaPagamento formaPagamento;

  @HiveField(2)
  final int parcelas;

  @HiveField(3)
  final DateTime dataHora;

  @HiveField(4)
  final bool autorizado;

  @HiveField(5)
  final String? qrCodePix;

  @HiveField(6)
  final String? comprovante;

  @HiveField(7)
  final String codigoTransacao;

  Pagamento({
    required this.valor,
    required this.formaPagamento,
    required this.parcelas,
    required this.dataHora,
    required this.autorizado,
    this.qrCodePix,
    this.comprovante,
  }) : codigoTransacao = Uuid().v4();

  double get valorParcela => valor / parcelas;

  String get formaPagamentoStr {
    switch (formaPagamento) {
      case FormaPagamento.dinheiro:
        return 'Dinheiro';
      case FormaPagamento.pix:
        return 'PIX';
      case FormaPagamento.debito:
        return 'Cartão de Débito';
      case FormaPagamento.credito:
        return 'Cartão de Crédito';
    }
  }

  String get statusPagamento => autorizado ? 'Autorizado' : 'Negado';

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'formaPagamento': formaPagamento.index,
      'parcelas': parcelas,
      'dataHora': dataHora.toString(),
      'autorizado': autorizado,
      'qrCodePix': qrCodePix,
      'comprovante': comprovante,
    };
  }

  factory Pagamento.fromMap(Map<String, dynamic> map) {
    return Pagamento(
      valor: map['valor'],
      formaPagamento: FormaPagamento.values[map['formaPagamento']],
      parcelas: map['parcelas'],
      dataHora: DateTime.parse(map['dataHora']),
      autorizado: map['autorizado'],
      qrCodePix: map['qrCodePix'],
      comprovante: map['comprovante'],
    );
  }
} 