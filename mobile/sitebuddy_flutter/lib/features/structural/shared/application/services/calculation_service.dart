import 'package:site_buddy/features/structural/shared/domain/models/safety_check_models.dart';

/// SERVICE: CalculationService
/// PURPOSE: Centralized engineering logic as per IS 456:2000 with smart insights.
class CalculationService {
  /// Calculate Shear Check
  static ShearResult calculateShear({
    required double vu, // kN
    required double b, // mm
    required double d, // mm
    required double pt, // Percentage
    required String concreteGrade,
  }) {
    if (b <= 0 || d <= 0) {
      return ShearResult(tv: 0, tc: 0, isSafe: false, insights: []);
    }

    final double tv = (vu * 1000) / (b * d);
    double tc = 0.0;
    final fck = double.tryParse(concreteGrade.replaceAll('M', '')) ?? 25.0;

    if (pt <= 0.15) {
      tc = 0.28;
    } else if (pt <= 0.25) {
      tc = 0.36;
    } else if (pt <= 0.50) {
      tc = 0.48;
    } else if (pt <= 0.75) {
      tc = 0.56;
    } else if (pt <= 1.00) {
      tc = 0.62;
    } else {
      tc = 0.70;
    }

    if (fck >= 30) tc *= 1.1;

    final insights = <EngineeringInsight>[];
    if (tv > tc) {
      insights.add(
        EngineeringInsight(
          message:
              'Nominal shear stress exceeds capacity. Increase depth (d) or concrete grade.',
          isWarning: true,
        ),
      );
    } else if (tv > 0.5 * tc) {
      insights.add(
        EngineeringInsight(
          message:
              'Shear stress is high. Ensure minimum shear reinforcement is provided.',
        ),
      );
    } else {
      insights.add(EngineeringInsight(message: 'Shear capacity is adequate.'));
    }

    return ShearResult(tv: tv, tc: tc, isSafe: tv <= tc, insights: insights);
  }

  /// Calculate Deflection Check
  static DeflectionResult calculateDeflection({
    required double span, // mm
    required double d, // mm
    required bool isContinuous,
  }) {
    if (d <= 0) {
      return DeflectionResult(
        actualRatio: 0,
        allowableRatio: 0,
        isSafe: false,
        insights: [],
      );
    }

    final double actualRatio = span / d;
    final double basicRatio = isContinuous ? 26.0 : 20.0;
    const double kt = 1.2;
    final double allowableRatio = basicRatio * kt;

    final insights = <EngineeringInsight>[];
    if (actualRatio > allowableRatio) {
      insights.add(
        EngineeringInsight(
          message:
              'Span/Depth ratio high. Increase effective depth to control deflection.',
          isWarning: true,
        ),
      );
    } else {
      insights.add(
        EngineeringInsight(message: 'Deflection is within permissible limits.'),
      );
    }

    return DeflectionResult(
      actualRatio: actualRatio,
      allowableRatio: allowableRatio,
      isSafe: actualRatio <= allowableRatio,
      insights: insights,
    );
  }

  /// Calculate Cracking Check
  static CrackingResult calculateCracking({
    required double spacing, // mm
    required double fs, // MPa
    required double cover, // mm
  }) {
    if (spacing <= 0) {
      return CrackingResult(crackWidth: 0, isSafe: false, insights: []);
    }

    const double es = 200000.0;
    final double crackWidth =
        (fs * spacing) / (es * (cover > 0 ? cover / 10 : 2));

    final insights = <EngineeringInsight>[];
    if (crackWidth > 0.3) {
      insights.add(
        EngineeringInsight(
          message:
              'Crack width exceeds 0.3mm. Reduce rebar spacing or steel stress.',
          isWarning: true,
        ),
      );
    } else {
      insights.add(
        EngineeringInsight(message: 'Crack width is within durable limits.'),
      );
    }

    return CrackingResult(
      crackWidth: crackWidth,
      isSafe: crackWidth <= 0.3,
      insights: insights,
    );
  }
}



