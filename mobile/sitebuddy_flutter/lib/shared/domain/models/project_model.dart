import 'package:hive/hive.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type; // Beam, Slab, Column, Footing

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final Map<String, dynamic> inputData;

  @HiveField(5)
  final Map<String, dynamic> resultData;

  ProjectModel({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.inputData,
    required this.resultData,
  });
}



