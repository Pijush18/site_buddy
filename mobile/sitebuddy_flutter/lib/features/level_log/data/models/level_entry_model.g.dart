// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelEntryModelAdapter extends TypeAdapter<LevelEntryModel> {
  @override
  final int typeId = 17;

  @override
  LevelEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelEntryModel(
      station: fields[0] as String,
      chainage: fields[1] as double?,
      bs: fields[2] as double?,
      isReading: fields[3] as double?,
      fs: fields[4] as double?,
      hi: fields[5] as double?,
      rl: fields[6] as double?,
      rise: fields[7] as double?,
      fall: fields[8] as double?,
      remark: fields[9] as String?,
      projectId: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LevelEntryModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.station)
      ..writeByte(1)
      ..write(obj.chainage)
      ..writeByte(2)
      ..write(obj.bs)
      ..writeByte(3)
      ..write(obj.isReading)
      ..writeByte(4)
      ..write(obj.fs)
      ..writeByte(5)
      ..write(obj.hi)
      ..writeByte(6)
      ..write(obj.rl)
      ..writeByte(7)
      ..write(obj.rise)
      ..writeByte(8)
      ..write(obj.fall)
      ..writeByte(9)
      ..write(obj.remark)
      ..writeByte(10)
      ..write(obj.projectId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
