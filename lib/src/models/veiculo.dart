import 'package:hive_flutter/hive_flutter.dart';

part 'veiculo.g.dart';

@HiveType(typeId: 1)
class Veiculo {
  @HiveField(0)
  final String placa;

  @HiveField(1)
  DateTime horaEntrada;

  @HiveField(2)
  DateTime? horaSaida;

  @HiveField(3)
  String? fotoPlaca;

  @HiveField(4)
  String? fotoVeiculo;

  @HiveField(5)
  bool isNoPatio;

  @HiveField(6)
  int? tempoPago; // Tempo pago em horas

  Veiculo({
    required this.placa,
    required this.horaEntrada,
    this.horaSaida,
    this.fotoPlaca,
    this.fotoVeiculo,
    this.isNoPatio = true,
    this.tempoPago,
  });

  static bool validarPlaca(String placa) {
    final regex = RegExp(
      r'^[A-Z]{3}-?\d{4}$|^[A-Z]{3}\d[A-Z]\d{2}$',
    );
    return regex.hasMatch(placa);
  }

  String get placaFormatada {
    if (placa.length == 7) {
      return '${placa.substring(0, 3)}-${placa.substring(3)}';
    }
    return placa;
  }

  Duration get tempoEstacionado {
    final saida = horaSaida ?? DateTime.now();
    return saida.difference(horaEntrada);
  }

  double get valorEstacionamento {
    final horas = tempoEstacionado.inHours;
    final minutos = tempoEstacionado.inMinutes % 60;
    final valorHora = 10.0;
    final valorMinuto = valorHora / 60;

    if (horas == 0 && minutos <= 15) {
      return 0.0;
    }

    return (horas * valorHora) + (minutos * valorMinuto);
  }

  Future<void> save() async {
    final box = await Hive.openBox<Veiculo>('veiculos');
    await box.put(placa, this);
  }

  Future<void> delete() async {
    final box = await Hive.openBox<Veiculo>('veiculos');
    await box.delete(placa);
  }

  static Future<Veiculo?> getByPlaca(String placa) async {
    final box = await Hive.openBox<Veiculo>('veiculos');
    return box.get(placa);
  }

  static Future<List<Veiculo>> getAll() async {
    final box = await Hive.openBox<Veiculo>('veiculos');
    return box.values.toList();
  }
} 