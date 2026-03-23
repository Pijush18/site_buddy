// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_tier.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionTierAdapter extends TypeAdapter<SubscriptionTier> {
  @override
  final int typeId = 30;

  @override
  SubscriptionTier read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubscriptionTier.free;
      case 1:
        return SubscriptionTier.pro;
      case 2:
        return SubscriptionTier.premium;
      default:
        return SubscriptionTier.free;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionTier obj) {
    switch (obj) {
      case SubscriptionTier.free:
        writer.writeByte(0);
        break;
      case SubscriptionTier.pro:
        writer.writeByte(1);
        break;
      case SubscriptionTier.premium:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionTierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
