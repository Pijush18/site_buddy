
import 'package:site_buddy/features/estimation/sand/domain/sand_models.dart';

/// STATE: SandState
/// PURPOSE: Standardized state for sand volume estimation.
class SandState {
  final double? length;
  final double? width;
  final double? depth;
  final double? ratePerCubicMeter;
  final SandResult? result;
  final String? error;
  final bool isLoading;
  final bool hasSaved;

  const SandState({
    this.length,
    this.width,
    this.depth,
    this.ratePerCubicMeter,
    this.result,
    this.error,
    this.isLoading = false,
    this.hasSaved = false,
  });

  SandState copyWith({
    double? length,
    double? width,
    double? depth,
    double? ratePerCubicMeter,
    SandResult? result,
    String? error,
    bool? isLoading,
    bool? hasSaved,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return SandState(
      length: length ?? this.length,
      width: width ?? this.width,
      depth: depth ?? this.depth,
      ratePerCubicMeter: ratePerCubicMeter ?? this.ratePerCubicMeter,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : error,
      isLoading: isLoading ?? this.isLoading,
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}
