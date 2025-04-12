// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veiculo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VeiculoAdapter extends TypeAdapter<Veiculo> {
  @override
  final int typeId = 0;

  @override
  Veiculo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Veiculo(
      placa: fields[0] as String,
      horaEntrada: fields[1] as DateTime,
      horaSaida: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Veiculo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.placa)
      ..writeByte(1)
      ..write(obj.horaEntrada)
      ..writeByte(2)
      ..write(obj.horaSaida);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VeiculoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
