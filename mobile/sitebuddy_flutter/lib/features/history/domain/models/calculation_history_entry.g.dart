// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_history_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculationHistoryEntryAdapter
    extends TypeAdapter<CalculationHistoryEntry> {
  @override
  final int typeId = 200;

  @override
  CalculationHistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculationHistoryEntry(
      id: fields[0] as String,
      projectId: fields[1] as String,
      calculationType: fields[2] as CalculationType,
      timestamp: fields[3] as DateTime,
      inputParameters: (fields[4] as Map).cast<String, dynamic>(),
      resultSummary: fields[5] as String,
      resultData: (fields[6] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CalculationHistoryEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.projectId)
      ..writeByte(2)
      ..write(obj.calculationType)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.inputParameters)
      ..writeByte(5)
      ..write(obj.resultSummary)
      ..writeByte(6)
      ..write(obj.resultData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationHistoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalculationTypeAdapter extends TypeAdapter<CalculationType> {
  @override
  final int typeId = 201;

  @override
  CalculationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CalculationType.column;
      case 1:
        return CalculationType.beam;
      case 2:
        return CalculationType.slab;
      case 3:
        return CalculationType.footing;
      case 4:
        return CalculationType.levelLog;
      case 5:
        return CalculationType.cement;
      case 6:
        return CalculationType.rebar;
      case 7:
        return CalculationType.brick;
      case 8:
        return CalculationType.plaster;
      case 9:
        return CalculationType.excavation;
      case 10:
        return CalculationType.shuttering;
      case 11:
        return CalculationType.sand;
      case 12:
        return CalculationType.gradient;
      case 13:
        return CalculationType.unitConverter;
      case 14:
        return CalculationType.currencyConverter;
      case 15:
        return CalculationType.road;
      case 16:
        return CalculationType.irrigation;
      default:
        return CalculationType.column;
    }
  }

  @override
  void write(BinaryWriter writer, CalculationType obj) {
    switch (obj) {
      case CalculationType.column:
        writer.writeByte(0);
        break;
      case CalculationType.beam:
        writer.writeByte(1);
        break;
      case CalculationType.slab:
        writer.writeByte(2);
        break;
      case CalculationType.footing:
        writer.writeByte(3);
        break;
      case CalculationType.levelLog:
        writer.writeByte(4);
        break;
      case CalculationType.cement:
        writer.writeByte(5);
        break;
      case CalculationType.rebar:
        writer.writeByte(6);
        break;
      case CalculationType.brick:
        writer.writeByte(7);
        break;
      case CalculationType.plaster:
        writer.writeByte(8);
        break;
      case CalculationType.excavation:
        writer.writeByte(9);
        break;
      case CalculationType.shuttering:
        writer.writeByte(10);
        break;
      case CalculationType.sand:
        writer.writeByte(11);
        break;
      case CalculationType.gradient:
        writer.writeByte(12);
        break;
      case CalculationType.unitConverter:
        writer.writeByte(13);
        break;
      case CalculationType.currencyConverter:
        writer.writeByte(14);
        break;
      case CalculationType.road:
        writer.writeByte(15);
        break;
      case CalculationType.irrigation:
        writer.writeByte(16);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
