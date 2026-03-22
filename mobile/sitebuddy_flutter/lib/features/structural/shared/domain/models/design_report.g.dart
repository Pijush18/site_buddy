// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DesignReportAdapter extends TypeAdapter<DesignReport> {
  @override
  final int typeId = 21;

  @override
  DesignReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DesignReport(
      id: fields[0] as String,
      projectId: fields[1] as String,
      typeLabel: fields[2] as String,
      summary: fields[3] as String,
      timestamp: fields[4] as DateTime,
      designType: fields[5] as DesignType,
      inputs: (fields[6] as Map).cast<String, dynamic>(),
      results: (fields[7] as Map).cast<String, dynamic>(),
      isSafe: fields[8] as bool,
      data: (fields[9] as Map).cast<String, dynamic>(),
      isSynced: fields[10] as bool,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DesignReport obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.projectId)
      ..writeByte(2)
      ..write(obj.typeLabel)
      ..writeByte(3)
      ..write(obj.summary)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.designType)
      ..writeByte(6)
      ..write(obj.inputs)
      ..writeByte(7)
      ..write(obj.results)
      ..writeByte(8)
      ..write(obj.isSafe)
      ..writeByte(9)
      ..write(obj.data)
      ..writeByte(10)
      ..write(obj.isSynced)
      ..writeByte(11)
      ..write(obj.updatedAt);
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
  final int typeId = 20;

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
      case 4:
        return DesignType.brick;
      case 5:
        return DesignType.concrete;
      case 6:
        return DesignType.plaster;
      case 7:
        return DesignType.excavation;
      case 8:
        return DesignType.shuttering;
      case 9:
        return DesignType.steel;
      case 10:
        return DesignType.currency;
      case 11:
        return DesignType.siteLeveling;
      case 12:
        return DesignType.siteGradient;
      case 13:
        return DesignType.road;
      case 14:
        return DesignType.irrigation;
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
      case DesignType.brick:
        writer.writeByte(4);
        break;
      case DesignType.concrete:
        writer.writeByte(5);
        break;
      case DesignType.plaster:
        writer.writeByte(6);
        break;
      case DesignType.excavation:
        writer.writeByte(7);
        break;
      case DesignType.shuttering:
        writer.writeByte(8);
        break;
      case DesignType.steel:
        writer.writeByte(9);
        break;
      case DesignType.currency:
        writer.writeByte(10);
        break;
      case DesignType.siteLeveling:
        writer.writeByte(11);
        break;
      case DesignType.siteGradient:
        writer.writeByte(12);
        break;
      case DesignType.road:
        writer.writeByte(13);
        break;
      case DesignType.irrigation:
        writer.writeByte(14);
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
