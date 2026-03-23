// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectTypeAdapter extends TypeAdapter<ProjectType> {
  @override
  final int typeId = 20;

  @override
  ProjectType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProjectType.residential;
      case 1:
        return ProjectType.commercial;
      case 2:
        return ProjectType.industrial;
      case 3:
        return ProjectType.infrastructure;
      case 4:
        return ProjectType.other;
      default:
        return ProjectType.other;
    }
  }

  @override
  void write(BinaryWriter writer, ProjectType obj) {
    switch (obj) {
      case ProjectType.residential:
        writer.writeByte(0);
        break;
      case ProjectType.commercial:
        writer.writeByte(1);
        break;
      case ProjectType.industrial:
        writer.writeByte(2);
        break;
      case ProjectType.infrastructure:
        writer.writeByte(3);
        break;
      case ProjectType.other:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectStatusAdapter extends TypeAdapter<ProjectStatus> {
  @override
  final int typeId = 21;

  @override
  ProjectStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProjectStatus.draft;
      case 1:
        return ProjectStatus.inProgress;
      case 2:
        return ProjectStatus.completed;
      case 3:
        return ProjectStatus.archived;
      default:
        return ProjectStatus.draft;
    }
  }

  @override
  void write(BinaryWriter writer, ProjectStatus obj) {
    switch (obj) {
      case ProjectStatus.draft:
        writer.writeByte(0);
        break;
      case ProjectStatus.inProgress:
        writer.writeByte(1);
        break;
      case ProjectStatus.completed:
        writer.writeByte(2);
        break;
      case ProjectStatus.archived:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectModelAdapter extends TypeAdapter<ProjectModel> {
  @override
  final int typeId = 22;

  @override
  ProjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      type: fields[3] as ProjectType,
      status: fields[4] as ProjectStatus,
      unitSystem: fields[5] as UnitSystem,
      location: fields[6] as String?,
      clientName: fields[7] as String?,
      calculations: (fields[8] as Map?)?.cast<String, List<dynamic>>().map(
        (k, v) => MapEntry(k, v.cast<Map<String, dynamic>>()),
      ),
      metadata: (fields[9] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
      ownerId: fields[12] as String?,
      tags: (fields[13] as List?)?.cast<String>(),
      isSynced: fields[14] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.unitSystem)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.clientName)
      ..writeByte(8)
      ..write(obj.calculations)
      ..writeByte(9)
      ..write(obj.metadata)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.ownerId)
      ..writeByte(13)
      ..write(obj.tags)
      ..writeByte(14)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
