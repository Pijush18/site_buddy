// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'column_design_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColumnDesignStateAdapter extends TypeAdapter<ColumnDesignState> {
  @override
  final int typeId = 2;

  @override
  ColumnDesignState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColumnDesignState(
      type: fields[1] as ColumnType,
      b: fields[2] as double,
      d: fields[3] as double,
      length: fields[4] as double,
      endCondition: fields[5] as EndCondition,
      cover: fields[6] as double,
      concreteGrade: fields[7] as String,
      steelGrade: fields[8] as String,
      pu: fields[9] as double,
      mx: fields[10] as double,
      my: fields[11] as double,
      loadType: fields[12] as LoadType,
      lex: fields[13] as double,
      ley: fields[14] as double,
      slendernessX: fields[15] as double,
      slendernessY: fields[16] as double,
      isShort: fields[17] as bool,
      eminX: fields[18] as double,
      eminY: fields[19] as double,
      astRequired: fields[20] as double,
      steelPercentage: fields[21] as double,
      ag: fields[22] as double,
      isAutoSteel: fields[23] as bool,
      designMethod: fields[24] as DesignMethod,
      mainBarDia: fields[25] as double,
      numBars: fields[26] as int,
      tieDia: fields[27] as double,
      tieSpacing: fields[28] as double,
      isSlendernessSafe: fields[29] as bool,
      isCapacitySafe: fields[30] as bool,
      isReinforcementSafe: fields[31] as bool,
      interactionRatio: fields[32] as double,
      magnifiedMx: fields[33] as double,
      magnifiedMy: fields[34] as double,
      failureMode: fields[35] as ColumnFailureMode,
      errorMessage: fields[36] as String?,
      isOptimizing: fields[37] as bool,
      projectId: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ColumnDesignState obj) {
    writer
      ..writeByte(38)
      ..writeByte(0)
      ..write(obj.projectId)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.b)
      ..writeByte(3)
      ..write(obj.d)
      ..writeByte(4)
      ..write(obj.length)
      ..writeByte(5)
      ..write(obj.endCondition)
      ..writeByte(6)
      ..write(obj.cover)
      ..writeByte(7)
      ..write(obj.concreteGrade)
      ..writeByte(8)
      ..write(obj.steelGrade)
      ..writeByte(9)
      ..write(obj.pu)
      ..writeByte(10)
      ..write(obj.mx)
      ..writeByte(11)
      ..write(obj.my)
      ..writeByte(12)
      ..write(obj.loadType)
      ..writeByte(13)
      ..write(obj.lex)
      ..writeByte(14)
      ..write(obj.ley)
      ..writeByte(15)
      ..write(obj.slendernessX)
      ..writeByte(16)
      ..write(obj.slendernessY)
      ..writeByte(17)
      ..write(obj.isShort)
      ..writeByte(18)
      ..write(obj.eminX)
      ..writeByte(19)
      ..write(obj.eminY)
      ..writeByte(20)
      ..write(obj.astRequired)
      ..writeByte(21)
      ..write(obj.steelPercentage)
      ..writeByte(22)
      ..write(obj.ag)
      ..writeByte(23)
      ..write(obj.isAutoSteel)
      ..writeByte(24)
      ..write(obj.designMethod)
      ..writeByte(25)
      ..write(obj.mainBarDia)
      ..writeByte(26)
      ..write(obj.numBars)
      ..writeByte(27)
      ..write(obj.tieDia)
      ..writeByte(28)
      ..write(obj.tieSpacing)
      ..writeByte(29)
      ..write(obj.isSlendernessSafe)
      ..writeByte(30)
      ..write(obj.isCapacitySafe)
      ..writeByte(31)
      ..write(obj.isReinforcementSafe)
      ..writeByte(32)
      ..write(obj.interactionRatio)
      ..writeByte(33)
      ..write(obj.magnifiedMx)
      ..writeByte(34)
      ..write(obj.magnifiedMy)
      ..writeByte(35)
      ..write(obj.failureMode)
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
      other is ColumnDesignStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
