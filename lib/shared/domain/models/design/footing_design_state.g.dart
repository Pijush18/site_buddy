// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'footing_design_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FootingDesignStateAdapter extends TypeAdapter<FootingDesignState> {
  @override
  final int typeId = 13;

  @override
  FootingDesignState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FootingDesignState(
      type: fields[1] as FootingType,
      columnLoad: fields[2] as double,
      columnLoad2: fields[3] as double,
      momentX: fields[4] as double,
      momentY: fields[5] as double,
      momentX2: fields[6] as double,
      momentY2: fields[7] as double,
      sbc: fields[8] as double,
      foundationDepth: fields[9] as double,
      unitWeightSoil: fields[10] as double,
      footingLength: fields[11] as double,
      footingWidth: fields[12] as double,
      footingThickness: fields[13] as double,
      columnSpacing: fields[14] as double,
      colA: fields[15] as double,
      colB: fields[16] as double,
      pileCapacity: fields[17] as double,
      pileDiameter: fields[18] as double,
      pileCount: fields[19] as int,
      requiredArea: fields[20] as double,
      providedArea: fields[21] as double,
      maxSoilPressure: fields[22] as double,
      minSoilPressure: fields[23] as double,
      qu: fields[24] as double,
      eccentricityX: fields[25] as double,
      eccentricityY: fields[26] as double,
      concreteGrade: fields[27] as String,
      steelGrade: fields[28] as String,
      mainBarDia: fields[29] as double,
      crossBarDia: fields[30] as double,
      mainBarSpacing: fields[35] as double,
      crossBarSpacing: fields[36] as double,
      astRequiredX: fields[31] as double,
      astRequiredY: fields[32] as double,
      astProvidedX: fields[33] as double,
      astProvidedY: fields[34] as double,
      mu: fields[37] as double,
      isAreaSafe: fields[38] as bool,
      isOneWayShearSafe: fields[39] as bool,
      isPunchingShearSafe: fields[40] as bool,
      isBendingSafe: fields[41] as bool,
      isSettlementWarning: fields[42] as bool,
      vu: fields[43] as double,
      vup: fields[44] as double,
      tauC: fields[45] as double,
      tauV: fields[46] as double,
      effDepth: fields[47] as double,
      errorMessage: fields[48] as String?,
      projectId: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FootingDesignState obj) {
    writer
      ..writeByte(49)
      ..writeByte(0)
      ..write(obj.projectId)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.columnLoad)
      ..writeByte(3)
      ..write(obj.columnLoad2)
      ..writeByte(4)
      ..write(obj.momentX)
      ..writeByte(5)
      ..write(obj.momentY)
      ..writeByte(6)
      ..write(obj.momentX2)
      ..writeByte(7)
      ..write(obj.momentY2)
      ..writeByte(8)
      ..write(obj.sbc)
      ..writeByte(9)
      ..write(obj.foundationDepth)
      ..writeByte(10)
      ..write(obj.unitWeightSoil)
      ..writeByte(11)
      ..write(obj.footingLength)
      ..writeByte(12)
      ..write(obj.footingWidth)
      ..writeByte(13)
      ..write(obj.footingThickness)
      ..writeByte(14)
      ..write(obj.columnSpacing)
      ..writeByte(15)
      ..write(obj.colA)
      ..writeByte(16)
      ..write(obj.colB)
      ..writeByte(17)
      ..write(obj.pileCapacity)
      ..writeByte(18)
      ..write(obj.pileDiameter)
      ..writeByte(19)
      ..write(obj.pileCount)
      ..writeByte(20)
      ..write(obj.requiredArea)
      ..writeByte(21)
      ..write(obj.providedArea)
      ..writeByte(22)
      ..write(obj.maxSoilPressure)
      ..writeByte(23)
      ..write(obj.minSoilPressure)
      ..writeByte(24)
      ..write(obj.qu)
      ..writeByte(25)
      ..write(obj.eccentricityX)
      ..writeByte(26)
      ..write(obj.eccentricityY)
      ..writeByte(27)
      ..write(obj.concreteGrade)
      ..writeByte(28)
      ..write(obj.steelGrade)
      ..writeByte(29)
      ..write(obj.mainBarDia)
      ..writeByte(30)
      ..write(obj.crossBarDia)
      ..writeByte(31)
      ..write(obj.astRequiredX)
      ..writeByte(32)
      ..write(obj.astRequiredY)
      ..writeByte(33)
      ..write(obj.astProvidedX)
      ..writeByte(34)
      ..write(obj.astProvidedY)
      ..writeByte(35)
      ..write(obj.mainBarSpacing)
      ..writeByte(36)
      ..write(obj.crossBarSpacing)
      ..writeByte(37)
      ..write(obj.mu)
      ..writeByte(38)
      ..write(obj.isAreaSafe)
      ..writeByte(39)
      ..write(obj.isOneWayShearSafe)
      ..writeByte(40)
      ..write(obj.isPunchingShearSafe)
      ..writeByte(41)
      ..write(obj.isBendingSafe)
      ..writeByte(42)
      ..write(obj.isSettlementWarning)
      ..writeByte(43)
      ..write(obj.vu)
      ..writeByte(44)
      ..write(obj.vup)
      ..writeByte(45)
      ..write(obj.tauC)
      ..writeByte(46)
      ..write(obj.tauV)
      ..writeByte(47)
      ..write(obj.effDepth)
      ..writeByte(48)
      ..write(obj.errorMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FootingDesignStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
