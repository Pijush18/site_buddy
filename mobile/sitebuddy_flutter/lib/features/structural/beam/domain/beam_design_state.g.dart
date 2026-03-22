// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beam_design_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiagramPointAdapter extends TypeAdapter<DiagramPoint> {
  @override
  final int typeId = 9;

  @override
  DiagramPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiagramPoint(
      fields[0] as double,
      fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DiagramPoint obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiagramPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DesignSuggestionAdapter extends TypeAdapter<DesignSuggestion> {
  @override
  final int typeId = 10;

  @override
  DesignSuggestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DesignSuggestion(
      title: fields[0] as String,
      description: fields[1] as String,
      action: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DesignSuggestion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.action);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesignSuggestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BeamDesignStateAdapter extends TypeAdapter<BeamDesignState> {
  @override
  final int typeId = 11;

  @override
  BeamDesignState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BeamDesignState(
      type: fields[1] as BeamType,
      span: fields[2] as double,
      width: fields[3] as double,
      overallDepth: fields[4] as double,
      cover: fields[5] as double,
      concreteGrade: fields[6] as String,
      steelGrade: fields[7] as String,
      deadLoad: fields[8] as double,
      liveLoad: fields[9] as double,
      pointLoad: fields[10] as double,
      isULS: fields[11] as bool,
      mu: fields[12] as double,
      vu: fields[13] as double,
      wu: fields[14] as double,
      sfdPoints: (fields[15] as List).cast<DiagramPoint>(),
      bmdPoints: (fields[16] as List).cast<DiagramPoint>(),
      mainBarDia: fields[17] as double,
      numBars: fields[18] as int,
      astRequired: fields[19] as double,
      astProvided: fields[20] as double,
      astMin: fields[21] as double,
      astMax: fields[22] as double,
      xu: fields[23] as double,
      xuMax: fields[24] as double,
      isAutoDesign: fields[25] as bool,
      stirrupDia: fields[26] as double,
      stirrupSpacing: fields[27] as double,
      stirrupLegs: fields[28] as int,
      tv: fields[29] as double,
      tc: fields[30] as double,
      tcMax: fields[31] as double,
      isFlexureSafe: fields[32] as bool,
      isShearSafe: fields[33] as bool,
      isDeflectionSafe: fields[34] as bool,
      suggestions: (fields[35] as List).cast<DesignSuggestion>(),
      errorMessage: fields[36] as String?,
      isOptimizing: fields[37] as bool,
      projectId: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BeamDesignState obj) {
    writer
      ..writeByte(38)
      ..writeByte(0)
      ..write(obj.projectId)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.span)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.overallDepth)
      ..writeByte(5)
      ..write(obj.cover)
      ..writeByte(6)
      ..write(obj.concreteGrade)
      ..writeByte(7)
      ..write(obj.steelGrade)
      ..writeByte(8)
      ..write(obj.deadLoad)
      ..writeByte(9)
      ..write(obj.liveLoad)
      ..writeByte(10)
      ..write(obj.pointLoad)
      ..writeByte(11)
      ..write(obj.isULS)
      ..writeByte(12)
      ..write(obj.mu)
      ..writeByte(13)
      ..write(obj.vu)
      ..writeByte(14)
      ..write(obj.wu)
      ..writeByte(15)
      ..write(obj.sfdPoints)
      ..writeByte(16)
      ..write(obj.bmdPoints)
      ..writeByte(17)
      ..write(obj.mainBarDia)
      ..writeByte(18)
      ..write(obj.numBars)
      ..writeByte(19)
      ..write(obj.astRequired)
      ..writeByte(20)
      ..write(obj.astProvided)
      ..writeByte(21)
      ..write(obj.astMin)
      ..writeByte(22)
      ..write(obj.astMax)
      ..writeByte(23)
      ..write(obj.xu)
      ..writeByte(24)
      ..write(obj.xuMax)
      ..writeByte(25)
      ..write(obj.isAutoDesign)
      ..writeByte(26)
      ..write(obj.stirrupDia)
      ..writeByte(27)
      ..write(obj.stirrupSpacing)
      ..writeByte(28)
      ..write(obj.stirrupLegs)
      ..writeByte(29)
      ..write(obj.tv)
      ..writeByte(30)
      ..write(obj.tc)
      ..writeByte(31)
      ..write(obj.tcMax)
      ..writeByte(32)
      ..write(obj.isFlexureSafe)
      ..writeByte(33)
      ..write(obj.isShearSafe)
      ..writeByte(34)
      ..write(obj.isDeflectionSafe)
      ..writeByte(35)
      ..write(obj.suggestions)
      ..writeByte(36)
      ..write(obj.errorMessage)
      ..writeByte(37)
      ..write(obj.isOptimizing);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeamDesignStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
