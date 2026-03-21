// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beam_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BeamTypeAdapter extends TypeAdapter<BeamType> {
  @override
  final int typeId = 8;

  @override
  BeamType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BeamType.simplySupported;
      case 1:
        return BeamType.continuous;
      case 2:
        return BeamType.cantilever;
      default:
        return BeamType.simplySupported;
    }
  }

  @override
  void write(BinaryWriter writer, BeamType obj) {
    switch (obj) {
      case BeamType.simplySupported:
        writer.writeByte(0);
        break;
      case BeamType.continuous:
        writer.writeByte(1);
        break;
      case BeamType.cantilever:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeamTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
