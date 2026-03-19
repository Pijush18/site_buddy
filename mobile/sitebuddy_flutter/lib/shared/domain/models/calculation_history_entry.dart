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

  /// Deserializes from backend JSON
  factory CalculationHistoryEntry.fromJson(Map<String, dynamic> json) {
    return CalculationHistoryEntry(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      calculationType: CalculationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CalculationType.slab,
      ),
      timestamp: DateTime.parse(json['created_at'] as String),
      inputParameters: json['input_data'] as Map<String, dynamic>,
      resultSummary: json['result_summary'] ?? '',
    );
  }

  /// Serializes for backend POST requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'type': calculationType.name,
      'created_at': timestamp.toIso8601String(),
      'input_data': inputParameters,
      'result_data': {'summary': resultSummary}, // Backend expects result_data as JSONB
      'result_summary': resultSummary,
    };
  }
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
