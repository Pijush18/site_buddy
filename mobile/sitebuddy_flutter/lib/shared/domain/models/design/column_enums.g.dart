// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'column_enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColumnTypeAdapter extends TypeAdapter<ColumnType> {
  @override
  final int typeId = 3;

  @override
  ColumnType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ColumnType.rectangular;
      case 1:
        return ColumnType.circular;
      default:
        return ColumnType.rectangular;
    }
  }

  @override
  void write(BinaryWriter writer, ColumnType obj) {
    switch (obj) {
      case ColumnType.rectangular:
        writer.writeByte(0);
        break;
      case ColumnType.circular:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EndConditionAdapter extends TypeAdapter<EndCondition> {
  @override
  final int typeId = 4;

  @override
  EndCondition read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EndCondition.fixed;
      case 1:
        return EndCondition.free;
      case 2:
        return EndCondition.pinned;
      case 3:
        return EndCondition.partial;
      default:
        return EndCondition.fixed;
    }
  }

  @override
  void write(BinaryWriter writer, EndCondition obj) {
    switch (obj) {
      case EndCondition.fixed:
        writer.writeByte(0);
        break;
      case EndCondition.free:
        writer.writeByte(1);
        break;
      case EndCondition.pinned:
        writer.writeByte(2);
        break;
      case EndCondition.partial:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EndConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LoadTypeAdapter extends TypeAdapter<LoadType> {
  @override
  final int typeId = 5;

  @override
  LoadType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LoadType.axial;
      case 1:
        return LoadType.uniaxial;
      case 2:
        return LoadType.biaxial;
      default:
        return LoadType.axial;
    }
  }

  @override
  void write(BinaryWriter writer, LoadType obj) {
    switch (obj) {
      case LoadType.axial:
        writer.writeByte(0);
        break;
      case LoadType.uniaxial:
        writer.writeByte(1);
        break;
      case LoadType.biaxial:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DesignMethodAdapter extends TypeAdapter<DesignMethod> {
  @override
  final int typeId = 6;

  @override
  DesignMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DesignMethod.analytical;
      case 1:
        return DesignMethod.chartBased;
      default:
        return DesignMethod.analytical;
    }
  }

  @override
  void write(BinaryWriter writer, DesignMethod obj) {
    switch (obj) {
      case DesignMethod.analytical:
        writer.writeByte(0);
        break;
      case DesignMethod.chartBased:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesignMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ColumnFailureModeAdapter extends TypeAdapter<ColumnFailureMode> {
  @override
  final int typeId = 7;

  @override
  ColumnFailureMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ColumnFailureMode.compression;
      case 1:
        return ColumnFailureMode.tension;
      case 2:
        return ColumnFailureMode.buckling;
      case 3:
        return ColumnFailureMode.axial;
      default:
        return ColumnFailureMode.compression;
    }
  }

  @override
  void write(BinaryWriter writer, ColumnFailureMode obj) {
    switch (obj) {
      case ColumnFailureMode.compression:
        writer.writeByte(0);
        break;
      case ColumnFailureMode.tension:
        writer.writeByte(1);
        break;
      case ColumnFailureMode.buckling:
        writer.writeByte(2);
        break;
      case ColumnFailureMode.axial:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnFailureModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}



