// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DesignReportAdapter extends TypeAdapter<DesignReport> {
  @override
  final int typeId = 210;

  @override
  DesignReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DesignReport(
      id: fields[0] as String,
      designType: fields[1] as DesignType,
      timestamp: fields[2] as DateTime,
      projectId: fields[3] as String?,
      inputs: (fields[4] as Map).cast<String, dynamic>(),
      results: (fields[5] as Map).cast<String, dynamic>(),
      summary: fields[6] as String,
      isSafe: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DesignReport obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.designType)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.projectId)
      ..writeByte(4)
      ..write(obj.inputs)
      ..writeByte(5)
      ..write(obj.results)
      ..writeByte(6)
      ..write(obj.summary)
      ..writeByte(7)
      ..write(obj.isSafe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesignReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DesignTypeAdapter extends TypeAdapter<DesignType> {
  @override
  final int typeId = 211;

  @override
  DesignType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DesignType.beam;
      case 1:
        return DesignType.slab;
      case 2:
        return DesignType.column;
      case 3:
        return DesignType.footing;
      default:
        return DesignType.beam;
    }
  }

  @override
  void write(BinaryWriter writer, DesignType obj) {
    switch (obj) {
      case DesignType.beam:
        writer.writeByte(0);
        break;
      case DesignType.slab:
        writer.writeByte(1);
        break;
      case DesignType.column:
        writer.writeByte(2);
        break;
      case DesignType.footing:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesignTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
