import 'package:hive/hive.dart';

part 'veiculo.g.dart';

@HiveType(typeId: 0)
class Veiculo extends HiveObject {
  @HiveField(0)
  final String placa;

  @HiveField(1)
  final DateTime horaEntrada;

  @HiveField(2)
  DateTime? horaSaida;

  Veiculo({
    required this.placa,
    required this.horaEntrada,
    this.horaSaida,
  });

  Map<String, dynamic> toMap() {
    return {
      'placa': placa,
      'horaEntrada': horaEntrada.toString(),
      'horaSaida': horaSaida?.toString(),
    };
  }

  factory Veiculo.fromMap(Map<String, dynamic> map) {
    return Veiculo(
      placa: map['placa'],
      horaEntrada: DateTime.parse(map['horaEntrada']),
      horaSaida: map['horaSaida'] != null ? DateTime.parse(map['horaSaida']) : null,
    );
  }
} 