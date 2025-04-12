// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketAdapter extends TypeAdapter<Ticket> {
  @override
  final int typeId = 4;

  @override
  Ticket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ticket(
      codigo: fields[0] as String,
      veiculo: fields[1] as String,
      pagamento: fields[2] as Pagamento,
      cnpjEstacionamento: fields[3] as String,
      nomeEstacionamento: fields[4] as String,
      isEntrada: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Ticket obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.codigo)
      ..writeByte(1)
      ..write(obj.veiculo)
      ..writeByte(2)
      ..write(obj.pagamento)
      ..writeByte(3)
      ..write(obj.cnpjEstacionamento)
      ..writeByte(4)
      ..write(obj.nomeEstacionamento)
      ..writeByte(5)
      ..write(obj.isEntrada)
      ..writeByte(6)
      ..write(obj.dataHora)
      ..writeByte(7)
      ..write(obj.codigoTransacao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
