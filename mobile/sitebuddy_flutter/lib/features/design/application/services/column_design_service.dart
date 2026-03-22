

import 'dart:math';
import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';
import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';

/// SERVICE: ColumnDesignService
/// PURPOSE: IS 456:2000 calculations for Column Design.
class ColumnDesignService {
  final DesignStandard standard;
  ColumnDesignService(this.standard);

  /// METHOD: calculateSlenderness
  ColumnDesignState calculateSlenderness(ColumnDesignState state) {
    // Effective length factors (IS 456:2000 Table 28)
    double k = 0.65;
    switch (state.endCondition) {
      case EndCondition.fixed:
        k = 0.65;
        break;
      case EndCondition.free:
        k = 2.0;
        break;
      case EndCondition.pinned:
        k = 1.0;
        break;
      case EndCondition.partial:
        k = 0.85;
        break;
    }

    final lex = k * state.length;
    final ley = k * state.length;

    final dimensionX = state.type == ColumnType.circular ? state.b : state.d;
    final dimensionY = state.b;

    final sx = lex / dimensionX;
    final sy = ley / dimensionY;

    // IS 456 Cl 25.1.2: Short if l/D < 12
    final isShort = sx < 12 && sy < 12;

    // Minimum Eccentricity
    final eminX = max(state.length / standard.eccentricityFactorL + dimensionX / standard.eccentricityFactorD, standard.eccentricityMin);
    final eminY = max(state.length / standard.eccentricityFactorL + dimensionY / standard.eccentricityFactorD, standard.eccentricityMin);

    // Moment Magnification for Slender Columns (Cl 39.7.1)
    // Ma = (Pu * D / 2000) * (le/D)^2
    double maxMomentAddX = 0;
    double maxMomentAddY = 0;
    if (!isShort) {
      maxMomentAddX = (state.pu * dimensionX / 2000) * pow(sx / 12, 2);
      maxMomentAddY = (state.pu * dimensionY / 2000) * pow(sy / 12, 2);
    }

    return state.copyWith(
      lex: lex,
      ley: ley,
      slendernessX: sx,
      slendernessY: sy,
      eminX: eminX,
      eminY: eminY,
      magnifiedMx: state.mx + maxMomentAddX,
      magnifiedMy: state.my + maxMomentAddY,
      isShort: isShort,
      isSlendernessSafe: sx <= 60 && sy <= 60, // Max limit as per Cl 25.3.1
    );
  }

  /// METHOD: calculateDesign
  ColumnDesignState calculateDesign(ColumnDesignState state) {
    final fck = _getGradeValue(state.concreteGrade);
    final fy = _getGradeValue(state.steelGrade);

    // Ag = Gross Area
    double ag = state.type == ColumnType.circular
        ? (pi * pow(state.b, 2) / 4)
        : (state.b * state.d);

    // Asc = Steel Area (Default 1% if auto)
    double p = state.steelPercentage / 100;
    if (state.isAutoSteel) p = 0.01; // 1% default

    // Cl 26.5.3.1: Reinforcement Limits 0.8% to 6%
    final asc = p * ag;
    final ac = ag - asc;

    // Uzal Capacity (Puz) - Pure axial capacity
    final puz = (standard.stressBlockFactor * fck * ac + standard.compressionSteelFactor * fy * asc) / 1000; // kN

    // Moment Capacities (Mux1, Muy1) - Simplified based on SP-16 assumptions
    // For a given Pu, we find Mux1 and Muy1
    // This is an approximation for interaction logic
    final dimensionX = state.type == ColumnType.circular ? state.b : state.d;
    final dimensionY = state.b;

    // Approx Mux1 = 0.138 * fck * b * d^2 (Simplified balance point approximation)
    final mux1 = (0.138 * fck * dimensionY * pow(dimensionX, 2)) / 1000000;
    final muy1 = (0.138 * fck * dimensionX * pow(dimensionY, 2)) / 1000000;

    double interaction = 0;
    if (state.loadType == LoadType.axial) {
      interaction = state.pu / puz;
    } else {
      // Cl 39.6 Interaction Formula: (Mux/Mux1)^an + (Muy/Muy1)^an <= 1
      double an = 1.0;
      final puRatio = state.pu / puz;
      if (puRatio <= 0.2) {
        an = 1.0;
      } else if (puRatio >= 0.8) {
        an = 2.0;
      } else {
        an = 1.0 + (puRatio - 0.2) / 0.6;
      }

      if (state.loadType == LoadType.uniaxial) {
        interaction = pow(state.magnifiedMx / mux1, an) as double;
      } else {
        interaction =
            pow(state.magnifiedMx / mux1, an) +
                    pow(state.magnifiedMy / muy1, an)
                as double;
      }
    }

    // Failure Mode Prediction
    ColumnFailureMode mode = ColumnFailureMode.axial;
    if (!state.isShort) {
      mode = ColumnFailureMode.buckling;
    } else if (interaction > 1.0) {
      if (state.pu > puz * 0.5) {
        mode = ColumnFailureMode.compression;
      } else {
        mode = ColumnFailureMode.tension;
      }
    }

    return state.copyWith(
      ag: ag,
      astRequired: asc,
      steelPercentage: p * 100,
      interactionRatio: interaction,
      isCapacitySafe: interaction <= 1.0,
      failureMode: mode,
    );
  }

  /// METHOD: calculateDetailing
  ColumnDesignState calculateDetailing(ColumnDesignState state) {
    final areaPerBar = (pi * pow(state.mainBarDia, 2)) / 4;
    int n = (state.astRequired / areaPerBar).ceil();

    // Detailing
    if (state.type == ColumnType.circular) {
      n = max(n, standard.minBarsCircular);
    } else {
      n = max(n, standard.minBarsRectangular);
      if (n % 2 != 0) n++; // Symmetry
    }

    // Tie spacing Cl 26.5.3.2 (c): min of:
    // 1. Least lateral dimension
    // 2. 16 * longitudinal bar dia
    // 3. 300 mm
    final spacing = min(state.b, min(16 * state.mainBarDia, 300.0));

    // Tie diameter Cl 26.5.3.2 (a): max (dia/4, 6mm)
    final tieDia = max(state.mainBarDia / 4, 8.0); // Using 8mm as practical min

    return state.copyWith(
      numBars: n,
      tieSpacing: spacing,
      tieDia: tieDia,
      isReinforcementSafe:
          state.steelPercentage >= 0.8 && state.steelPercentage <= 4.0,
    );
  }

  double _getGradeValue(String grade) {
    return double.tryParse(grade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 25;
  }
}



