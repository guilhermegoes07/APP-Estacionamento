// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagamento.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PagamentoAdapter extends TypeAdapter<Pagamento> {
  @override
  final int typeId = 2;

  @override
  Pagamento read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pagamento(
      valor: fields[0] as double,
      formaPagamento: fields[1] as FormaPagamento,
      parcelas: fields[2] as int?,
      codigoTransacao: fields[3] as String?,
      dataHora: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Pagamento obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.valor)
      ..writeByte(1)
      ..write(obj.formaPagamento)
      ..writeByte(2)
      ..write(obj.parcelas)
      ..writeByte(3)
      ..write(obj.codigoTransacao)
      ..writeByte(4)
      ..write(obj.dataHora);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PagamentoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FormaPagamentoAdapter extends TypeAdapter<FormaPagamento> {
  @override
  final int typeId = 1;

  @override
  FormaPagamento read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FormaPagamento.dinheiro;
      case 1:
        return FormaPagamento.pix;
      case 2:
        return FormaPagamento.debito;
      case 3:
        return FormaPagamento.credito;
      default:
        return FormaPagamento.dinheiro;
    }
  }

  @override
  void write(BinaryWriter writer, FormaPagamento obj) {
    switch (obj) {
      case FormaPagamento.dinheiro:
        writer.writeByte(0);
        break;
      case FormaPagamento.pix:
        writer.writeByte(1);
        break;
      case FormaPagamento.debito:
        writer.writeByte(2);
        break;
      case FormaPagamento.credito:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormaPagamentoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
