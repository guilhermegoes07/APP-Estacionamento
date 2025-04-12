// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veiculo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VeiculoAdapter extends TypeAdapter<Veiculo> {
  @override
  final int typeId = 1;

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
      fotoPlaca: fields[3] as String?,
      fotoVeiculo: fields[4] as String?,
      isNoPatio: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Veiculo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.placa)
      ..writeByte(1)
      ..write(obj.horaEntrada)
      ..writeByte(2)
      ..write(obj.horaSaida)
      ..writeByte(3)
      ..write(obj.fotoPlaca)
      ..writeByte(4)
      ..write(obj.fotoVeiculo)
      ..writeByte(5)
      ..write(obj.isNoPatio);
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
