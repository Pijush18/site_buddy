import 'package:hive/hive.dart';

part 'history_item.g.dart';

/// MODEL: HistoryItem
/// Represents a single calculation saved to history
@HiveType(typeId: 0)
class HistoryItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String toolId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final Map<String, dynamic> inputData;

  @HiveField(4)
  final Map<String, dynamic> resultData;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final String? projectId;

  HistoryItem({
    required this.id,
    required this.toolId,
    required this.title,
    required this.inputData,
    required this.resultData,
    required this.createdAt,
    this.projectId,
  });

  /// Create a copy with updated fields
  HistoryItem copyWith({
    String? id,
    String? toolId,
    String? title,
    Map<String, dynamic>? inputData,
    Map<String, dynamic>? resultData,
    DateTime? createdAt,
    String? projectId,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      toolId: toolId ?? this.toolId,
      title: title ?? this.title,
      inputData: inputData ?? this.inputData,
      resultData: resultData ?? this.resultData,
      createdAt: createdAt ?? this.createdAt,
      projectId: projectId ?? this.projectId,
    );
  }
}