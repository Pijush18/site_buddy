import 'package:hive/hive.dart';

part 'calculation_history_entry.g.dart';

@HiveType(typeId: 200)
class CalculationHistoryEntry {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String projectId;

  @HiveField(2)
  final CalculationType calculationType;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final Map<String, dynamic> inputParameters;

  @HiveField(5)
  final String resultSummary;

  CalculationHistoryEntry({
    required this.id,
    required this.projectId,
    required this.calculationType,
    required this.timestamp,
    required this.inputParameters,
    required this.resultSummary,
  });
}

@HiveType(typeId: 201)
enum CalculationType {
  @HiveField(0)
  column,
  @HiveField(1)
  beam,
  @HiveField(2)
  slab,
  @HiveField(3)
  footing,
  @HiveField(4)
  levelLog,
}
