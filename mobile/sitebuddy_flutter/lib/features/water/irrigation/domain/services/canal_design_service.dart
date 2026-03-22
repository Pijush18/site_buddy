
import 'dart:math' as math;
import 'package:site_buddy/core/engineering/standards/hydrology/hydrology_standard.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/canal_input.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/canal_result.dart';
import 'package:site_buddy/features/water/irrigation/domain/services/manning_service.dart';

/// SERVICE: CanalDesignService
/// PURPOSE: Orchestrates irrigation design for Rectangular and Trapezoidal shapes.
class CanalDesignService {
  final HydrologyStandard standard;
  final ManningService manning;

  CanalDesignService(this.standard, this.manning);

  CanalResult designCanal(CanalInput input) {
    final double n = standard.manningCoefficient(input.material);
    final double s = input.longitudinalSlope;
    final double b = input.bedWidth;
    final double y = input.flowDepth;
    final double z = input.sideSlope;

    double a; // Area
    double p; // Perimeter

    if (input.shape == CanalShape.rectangular) {
      a = b * y;
      p = b + (2 * y);
    } else {
      // Trapezoidal: A = (b + zy) * y, P = b + 2y * sqrt(1 + z²)
      a = (b + (z * y)) * y;
      p = b + (2 * y * math.sqrt(1 + (z * z)));
    }

    final double r = a / p; // Hydraulic Radius
    final double v = manning.calculateVelocity(n: n, hydraulicRadius: r, slope: s);
    final double q = a * v; // Discharge

    // Efficiency Calculation
    final double efficiency = _calculateEfficiency(input, a, p);
    
    // Pro features and guidance
    String note = _evaluateVelocity(v);
    note += " | ${standard.slopeGuidance(input.material)}";

    if (input.isProUser && efficiency < 90) {
      final double optWidth = (a / y) - (z * y);
      note += " | PRO TIP: Optimize Bed Width to ${optWidth.toStringAsFixed(2)}m.";
    }

    return CanalResult(
      discharge: q,
      velocity: v,
      crossArea: a,
      wettedPerimeter: p,
      hydraulicRadius: r,
      efficiency: efficiency,
      isOptimized: input.isProUser && efficiency >= 95,
      safetyNote: note,
    );
  }

  double _calculateEfficiency(CanalInput input, double a, double p) {
    // Economic Section Efficiency (Min Perimeter for Area A)
    double pMin;
    if (input.shape == CanalShape.rectangular) {
      pMin = 2 * math.sqrt(2 * a);
    } else {
      pMin = 2 * math.sqrt(a * math.sqrt(3));
    }
    return (pMin / p) * 100;
  }

  String _evaluateVelocity(double v) {
    if (v < 0.6) return "SILTING RISK: v < 0.6 m/s";
    if (v > 2.5) return "SCOURING RISK: v > 2.5 m/s";
    return "SAFE VELOCITY: Non-silting/scouring";
  }
}
