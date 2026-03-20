// FILE HEADER
// ----------------------------------------------
// File: slab_design_result.dart
// Feature: design
// Layer: domain/entities
//
// PURPOSE:
// Data entity holding the technical output of a slab structural design calculation.
// ----------------------------------------------
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'slab_design_result.g.dart';

/// CLASS: SlabDesignResult
/// Holds bending moments, reinforcement details, and safety check statuses.
@HiveType(typeId: 15)
class SlabDesignResult extends Equatable {
  @HiveField(0)
  final double bendingMoment; // Mu or max resultant moment in kNm/m
  @HiveField(1)
  final String mainRebar; // e.g. "10mm @ 150mm c/c"
  @HiveField(2)
  final String distributionSteel; // e.g. "8mm @ 200mm c/c"
  @HiveField(3)
  final String? projectId;

  // Safety Checks
  @HiveField(4)
  final bool isShearSafe;
  @HiveField(5)
  final bool isDeflectionSafe;
  @HiveField(6)
  final bool isCrackingSafe;

  // Analysis details
  @HiveField(7)
  final double astProvided; // mm2
  @HiveField(8)
  final double astRequired; // mm2

  const SlabDesignResult({
    required this.bendingMoment,
    required this.mainRebar,
    required this.distributionSteel,
    required this.isShearSafe,
    required this.isDeflectionSafe,
    required this.isCrackingSafe,
    this.astProvided = 0,
    this.astRequired = 0,
    this.projectId,
  });

  SlabDesignResult copyWith({
    double? bendingMoment,
    String? mainRebar,
    String? distributionSteel,
    bool? isShearSafe,
    bool? isDeflectionSafe,
    bool? isCrackingSafe,
    double? astProvided,
    double? astRequired,
    String? projectId,
  }) {
    return SlabDesignResult(
      bendingMoment: bendingMoment ?? this.bendingMoment,
      mainRebar: mainRebar ?? this.mainRebar,
      distributionSteel: distributionSteel ?? this.distributionSteel,
      isShearSafe: isShearSafe ?? this.isShearSafe,
      isDeflectionSafe: isDeflectionSafe ?? this.isDeflectionSafe,
      isCrackingSafe: isCrackingSafe ?? this.isCrackingSafe,
      astProvided: astProvided ?? this.astProvided,
      astRequired: astRequired ?? this.astRequired,
      projectId: projectId ?? this.projectId,
    );
  }

  /// Factory for initial/empty state
  factory SlabDesignResult.empty() {
    return const SlabDesignResult(
      bendingMoment: 0.0,
      mainRebar: '-',
      distributionSteel: '-',
      isShearSafe: true,
      isDeflectionSafe: true,
      isCrackingSafe: true,
      astProvided: 0,
      astRequired: 0,
    );
  }

  @override
  List<Object?> get props => [
    bendingMoment,
    mainRebar,
    distributionSteel,
    isShearSafe,
    isDeflectionSafe,
    isCrackingSafe,
    astProvided,
    astRequired,
    projectId,
  ];
}



