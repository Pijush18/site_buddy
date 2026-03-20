// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_log_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelLogSessionModelAdapter extends TypeAdapter<LevelLogSessionModel> {
  @override
  final int typeId = 18;

  @override
  LevelLogSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelLogSessionModel(
      id: fields[0] as String,
      name: fields[1] as String,
      projectId: fields[2] as String?,
      date: fields[3] as DateTime,
      method: fields[4] as LevelMethodModel,
      entries: (fields[5] as List).cast<LevelEntryModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, LevelLogSessionModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.projectId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.method)
      ..writeByte(5)
      ..write(obj.entries);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelLogSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}



