// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slab_design_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SlabDesignStateAdapter extends TypeAdapter<SlabDesignState> {
  @override
  final int typeId = 12;

  @override
  SlabDesignState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SlabDesignState(
      type: fields[0] as SlabType,
      lx: fields[1] as double,
      ly: fields[2] as double,
      d: fields[3] as double,
      deadLoad: fields[4] as double,
      liveLoad: fields[5] as double,
      result: fields[6] as SlabDesignResult?,
      error: fields[7] as String?,
      projectId: fields[8] as String?,
      concreteGrade: fields[9] as String,
      steelGrade: fields[10] as String,
      cover: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SlabDesignState obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.lx)
      ..writeByte(2)
      ..write(obj.ly)
      ..writeByte(3)
      ..write(obj.d)
      ..writeByte(4)
      ..write(obj.deadLoad)
      ..writeByte(5)
      ..write(obj.liveLoad)
      ..writeByte(6)
      ..write(obj.result)
      ..writeByte(7)
      ..write(obj.error)
      ..writeByte(8)
      ..write(obj.projectId)
      ..writeByte(9)
      ..write(obj.concreteGrade)
      ..writeByte(10)
      ..write(obj.steelGrade)
      ..writeByte(11)
      ..write(obj.cover);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlabDesignStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
