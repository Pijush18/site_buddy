// lib/core/constants/concrete_mix_constants.dart
//
// Nominal concrete mix ratio constants as per IS 456:2000.
// These constants define standard grade definitions for common concrete mixes
// used across all material estimation calculations in SiteBuddy.
//
// Usage:
//   final mix = ConcreteMixConstants.byGrade('M20');
//   print(mix.cementRatio); // 1.0

/// Represents a single nominal concrete mix grade with its constituent ratios.
///
/// The ratios are defined as (Cement : Fine Aggregate : Coarse Aggregate) by volume.
class ConcreteMix {
  /// Human-readable grade name (e.g. "M20").
  final String grade;

  /// Cement part in the mix ratio (always 1.0 for nominal mixes).
  final double cementRatio;

  /// Fine aggregate (sand) part in the mix ratio.
  final double sandRatio;

  /// Coarse aggregate (gravel/stone) part in the mix ratio.
  final double aggregateRatio;

  const ConcreteMix({
    required this.grade,
    required this.cementRatio,
    required this.sandRatio,
    required this.aggregateRatio,
  });

  /// Total parts in the mix (used as the denominator when computing volumes).
  double get totalParts => cementRatio + sandRatio + aggregateRatio;

  @override
  String toString() =>
      '$grade (${cementRatio.toStringAsFixed(1)} : '
      '${sandRatio.toStringAsFixed(1)} : '
      '${aggregateRatio.toStringAsFixed(1)})';
}

/// Registry of standard nominal concrete mix grades as per IS 456:2000.
///
/// Wet concrete has a bulking factor of approximately 1.54 (dry to wet
/// volume conversion). This is **not** stored here — it lives in
/// [MaterialEstimationService] to keep this file purely declarative.
class ConcreteMixConstants {
  ConcreteMixConstants._(); // prevent instantiation

  // ---------------------------------------------------------------------------
  // Standard nominal mix grades
  // ---------------------------------------------------------------------------

  /// M10 — nominal mix 1 : 3 : 6
  /// Typical use: lean concrete / PCC.
  static const ConcreteMix m10 = ConcreteMix(
    grade: 'M10',
    cementRatio: 1.0,
    sandRatio: 3.0,
    aggregateRatio: 6.0,
  );

  /// M15 — nominal mix 1 : 2 : 4
  /// Typical use: plain cement concrete, unreinforced footings.
  static const ConcreteMix m15 = ConcreteMix(
    grade: 'M15',
    cementRatio: 1.0,
    sandRatio: 2.0,
    aggregateRatio: 4.0,
  );

  /// M20 — nominal mix 1 : 1.5 : 3
  /// Typical use: general RCC structures (slabs, beams, columns).
  static const ConcreteMix m20 = ConcreteMix(
    grade: 'M20',
    cementRatio: 1.0,
    sandRatio: 1.5,
    aggregateRatio: 3.0,
  );

  /// M25 — nominal mix 1 : 1 : 2
  /// Typical use: higher strength RCC, water-retaining structures.
  static const ConcreteMix m25 = ConcreteMix(
    grade: 'M25',
    cementRatio: 1.0,
    sandRatio: 1.0,
    aggregateRatio: 2.0,
  );

  // ---------------------------------------------------------------------------
  // Convenience helpers
  // ---------------------------------------------------------------------------

  /// All supported grades in ascending strength order.
  static const List<ConcreteMix> all = [m10, m15, m20, m25];

  /// Grade names as strings — useful for populating UI dropdowns.
  static List<String> get gradeNames => all.map((m) => m.grade).toList();

  /// Returns the [ConcreteMix] for [grade] (case-insensitive), or `null`
  /// if the grade is not found in the standard list.
  ///
  /// Example:
  /// ```dart
  /// final mix = ConcreteMixConstants.byGrade('M20');
  /// ```
  static ConcreteMix? byGrade(String grade) {
    final upper = grade.toUpperCase();
    try {
      return all.firstWhere((m) => m.grade.toUpperCase() == upper);
    } catch (_) {
      return null;
    }
  }
}
