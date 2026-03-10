import 'package:site_buddy/features/level_log/domain/entities/level_entry.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_method.dart';

/// ENTITY: LevelLogSession
/// PURPOSE: Encapsulates a surveying session.
class LevelLogSession {
  final String id;
  final String name;
  final String? projectId;
  final DateTime date;
  final LevelMethod method;
  final List<LevelEntry> entries;

  LevelLogSession({
    required this.id,
    required this.name,
    this.projectId,
    required this.date,
    required this.method,
    required this.entries,
  });
}
