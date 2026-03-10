import 'package:hive/hive.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_method.dart';

part 'level_method_model.g.dart';

@HiveType(typeId: 16)
enum LevelMethodModel {
  @HiveField(0)
  heightOfInstrument,

  @HiveField(1)
  riseFall,

  @HiveField(2)
  simple,
}

extension LevelMethodModelX on LevelMethodModel {
  LevelMethod toEntity() {
    switch (this) {
      case LevelMethodModel.heightOfInstrument:
        return LevelMethod.heightOfInstrument;
      case LevelMethodModel.riseFall:
        return LevelMethod.riseFall;
      case LevelMethodModel.simple:
        return LevelMethod.simple;
    }
  }

  static LevelMethodModel fromEntity(LevelMethod entity) {
    switch (entity) {
      case LevelMethod.heightOfInstrument:
        return LevelMethodModel.heightOfInstrument;
      case LevelMethod.riseFall:
        return LevelMethodModel.riseFall;
      case LevelMethod.simple:
        return LevelMethodModel.simple;
    }
  }
}
