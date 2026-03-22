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
      projectId: fields[3] as String,
      inputs: (fields[4] as Map).cast<String, dynamic>(),
      results: (fields[5] as Map).cast<String, dynamic>(),
      summary: fields[6] as String,
      isSafe: fields[7] as bool,
      updatedAt: fields[8] as DateTime?,
      isSynced: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DesignReport obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.isSafe)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.isSynced);
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
      case 4:
        return DesignType.levelLog;
      case 5:
        return DesignType.cement;
      case 6:
        return DesignType.rebar;
      case 7:
        return DesignType.brick;
      case 8:
        return DesignType.plaster;
      case 9:
        return DesignType.excavation;
      case 10:
        return DesignType.shuttering;
      case 11:
        return DesignType.sand;
      case 12:
        return DesignType.gradient;
      case 13:
        return DesignType.unitConverter;
      case 14:
        return DesignType.currencyConverter;
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
      case DesignType.levelLog:
        writer.writeByte(4);
        break;
      case DesignType.cement:
        writer.writeByte(5);
        break;
      case DesignType.rebar:
        writer.writeByte(6);
        break;
      case DesignType.brick:
        writer.writeByte(7);
        break;
      case DesignType.plaster:
        writer.writeByte(8);
        break;
      case DesignType.excavation:
        writer.writeByte(9);
        break;
      case DesignType.shuttering:
        writer.writeByte(10);
        break;
      case DesignType.sand:
        writer.writeByte(11);
        break;
      case DesignType.gradient:
        writer.writeByte(12);
        break;
      case DesignType.unitConverter:
        writer.writeByte(13);
        break;
      case DesignType.currencyConverter:
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
