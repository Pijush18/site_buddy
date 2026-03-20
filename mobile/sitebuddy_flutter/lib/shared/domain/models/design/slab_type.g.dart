// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slab_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SlabTypeAdapter extends TypeAdapter<SlabType> {
  @override
  final int typeId = 14;

  @override
  SlabType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SlabType.oneWay;
      case 1:
        return SlabType.twoWay;
      case 2:
        return SlabType.continuous;
      default:
        return SlabType.oneWay;
    }
  }

  @override
  void write(BinaryWriter writer, SlabType obj) {
    switch (obj) {
      case SlabType.oneWay:
        writer.writeByte(0);
        break;
      case SlabType.twoWay:
        writer.writeByte(1);
        break;
      case SlabType.continuous:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlabTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}



