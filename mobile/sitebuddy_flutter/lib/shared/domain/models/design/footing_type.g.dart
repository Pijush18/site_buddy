// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'footing_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FootingTypeAdapter extends TypeAdapter<FootingType> {
  @override
  final int typeId = 12;

  @override
  FootingType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FootingType.isolated;
      case 1:
        return FootingType.combined;
      case 2:
        return FootingType.strap;
      case 3:
        return FootingType.strip;
      case 4:
        return FootingType.raft;
      case 5:
        return FootingType.pile;
      default:
        return FootingType.isolated;
    }
  }

  @override
  void write(BinaryWriter writer, FootingType obj) {
    switch (obj) {
      case FootingType.isolated:
        writer.writeByte(0);
        break;
      case FootingType.combined:
        writer.writeByte(1);
        break;
      case FootingType.strap:
        writer.writeByte(2);
        break;
      case FootingType.strip:
        writer.writeByte(3);
        break;
      case FootingType.raft:
        writer.writeByte(4);
        break;
      case FootingType.pile:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FootingTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}



