import 'package:hive/hive.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_entry.dart';

part 'level_entry_model.g.dart';

@HiveType(typeId: 17)
class LevelEntryModel {
  @HiveField(0)
  final String station;
  @HiveField(1)
  final double? chainage;
  @HiveField(2)
  final double? bs;
  @HiveField(3)
  final double? isReading;
  @HiveField(4)
  final double? fs;
  @HiveField(5)
  final double? hi;
  @HiveField(6)
  final double? rl;
  @HiveField(7)
  final double? rise;
  @HiveField(8)
  final double? fall;
  @HiveField(9)
  final String? remark;
  @HiveField(10)
  final String? projectId;

  LevelEntryModel({
    required this.station,
    this.chainage,
    this.bs,
    this.isReading,
    this.fs,
    this.hi,
    this.rl,
    this.rise,
    this.fall,
    this.remark,
    this.projectId,
  });

  factory LevelEntryModel.fromEntity(LevelEntry entity) {
    return LevelEntryModel(
      station: entity.station,
      chainage: entity.chainage,
      bs: entity.bs,
      isReading: entity.isReading,
      fs: entity.fs,
      hi: entity.hi,
      rl: entity.rl,
      rise: entity.rise,
      fall: entity.fall,
      remark: entity.remark,
      projectId: entity.projectId,
    );
  }

  LevelEntry toEntity() {
    return LevelEntry(
      station: station,
      chainage: chainage,
      bs: bs,
      isReading: isReading,
      fs: fs,
      hi: hi,
      rl: rl,
      rise: rise,
      fall: fall,
      remark: remark,
      projectId: projectId,
    );
  }
}
