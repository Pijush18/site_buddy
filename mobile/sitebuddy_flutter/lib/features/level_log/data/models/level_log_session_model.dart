import 'package:hive/hive.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_log_session.dart';
import 'package:site_buddy/features/level_log/data/models/level_entry_model.dart';
import 'package:site_buddy/features/level_log/data/models/level_method_model.dart';

part 'level_log_session_model.g.dart';

@HiveType(typeId: 18)
class LevelLogSessionModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? projectId;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final LevelMethodModel method;
  @HiveField(5)
  final List<LevelEntryModel> entries;

  LevelLogSessionModel({
    required this.id,
    required this.name,
    this.projectId,
    required this.date,
    required this.method,
    required this.entries,
  });

  factory LevelLogSessionModel.fromEntity(LevelLogSession entity) {
    return LevelLogSessionModel(
      id: entity.id,
      name: entity.name,
      projectId: entity.projectId,
      date: entity.date,
      method: LevelMethodModelX.fromEntity(entity.method),
      entries: entity.entries
          .map((e) => LevelEntryModel.fromEntity(e))
          .toList(),
    );
  }

  LevelLogSession toEntity() {
    return LevelLogSession(
      id: id,
      name: name,
      projectId: projectId,
      date: date,
      method: method.toEntity(),
      entries: entries.map((e) => e.toEntity()).toList(),
    );
  }
}



