// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_method_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelMethodModelAdapter extends TypeAdapter<LevelMethodModel> {
  @override
  final int typeId = 16;

  @override
  LevelMethodModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LevelMethodModel.heightOfInstrument;
      case 1:
        return LevelMethodModel.riseFall;
      case 2:
        return LevelMethodModel.simple;
      default:
        return LevelMethodModel.heightOfInstrument;
    }
  }

  @override
  void write(BinaryWriter writer, LevelMethodModel obj) {
    switch (obj) {
      case LevelMethodModel.heightOfInstrument:
        writer.writeByte(0);
        break;
      case LevelMethodModel.riseFall:
        writer.writeByte(1);
        break;
      case LevelMethodModel.simple:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelMethodModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
