// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slab_design_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SlabDesignResultAdapter extends TypeAdapter<SlabDesignResult> {
  @override
  final int typeId = 15;

  @override
  SlabDesignResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SlabDesignResult(
      bendingMoment: fields[0] as double,
      mainRebar: fields[1] as String,
      distributionSteel: fields[2] as String,
      isShearSafe: fields[4] as bool,
      isDeflectionSafe: fields[5] as bool,
      isCrackingSafe: fields[6] as bool,
      projectId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SlabDesignResult obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.bendingMoment)
      ..writeByte(1)
      ..write(obj.mainRebar)
      ..writeByte(2)
      ..write(obj.distributionSteel)
      ..writeByte(3)
      ..write(obj.projectId)
      ..writeByte(4)
      ..write(obj.isShearSafe)
      ..writeByte(5)
      ..write(obj.isDeflectionSafe)
      ..writeByte(6)
      ..write(obj.isCrackingSafe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlabDesignResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
