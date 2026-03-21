// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branding_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrandingModelAdapter extends TypeAdapter<BrandingModel> {
  @override
  final int typeId = 5;

  @override
  BrandingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrandingModel(
      companyName: fields[0] as String,
      engineerName: fields[1] as String,
      logoPath: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BrandingModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.companyName)
      ..writeByte(1)
      ..write(obj.engineerName)
      ..writeByte(2)
      ..write(obj.logoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
