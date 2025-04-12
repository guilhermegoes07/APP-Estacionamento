import 'package:hive/hive.dart';
import 'veiculo.dart';
import 'pagamento.dart';

part 'ticket.g.dart';

@HiveType(typeId: 3)
class Ticket extends HiveObject {
  @HiveField(0)
  final Veiculo veiculo;

  @HiveField(1)
  final Pagamento pagamento;

  @HiveField(2)
  final String codigo;

  Ticket({
    required this.veiculo,
    required this.pagamento,
    required this.codigo,
  });

  Map<String, dynamic> toMap() {
    return {
      'veiculo': veiculo.toMap(),
      'pagamento': pagamento.toMap(),
      'codigo': codigo,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      veiculo: Veiculo.fromMap(map['veiculo']),
      pagamento: Pagamento.fromMap(map['pagamento']),
      codigo: map['codigo'],
    );
  }
} 