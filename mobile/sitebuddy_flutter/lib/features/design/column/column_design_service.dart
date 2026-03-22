import 'dart:math' as math;
import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/design/column/column_models.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';

/// SERVICE: ColumnDesignService
/// PURPOSE: Encapsulates all engineering formulas and logic for column design.
class ColumnDesignService {
  final DesignStandard standard;

  ColumnDesignService(this.standard);

  /// METHOD: designColumn
  /// Performs full structural design pipeline for a column.
  ColumnResult designColumn(ColumnInput input) {
    // 1. Slenderness & Initial Analysis
    final analysis = _calculateSlenderness(input);
    
    // 2. Capacity Design
    final capacity = _calculateCapacity(input, analysis);
    
    // 3. Detailing
    final detailing = _calculateDetailing(input, capacity);

    return ColumnResult(
      reinforcement: detailing.reinforcement,
      ties: detailing.ties,
      interactionRatio: capacity.interactionRatio,
      isCapacitySafe: capacity.isCapacitySafe,
      isSlendernessSafe: analysis.isSlendernessSafe,
      lex: analysis.lex,
      ley: analysis.ley,
      slendernessX: analysis.slendernessX,
      slendernessY: analysis.slendernessY,
      eminX: analysis.eminX,
      eminY: analysis.eminY,
      magnifiedMx: analysis.magnifiedMx,
      magnifiedMy: analysis.magnifiedMy,
      isShort: analysis.isShort,
      ag: capacity.ag,
      astRequired: capacity.astRequired,
      numBars: detailing.numBars,
      tieSpacing: detailing.tieSpacing,
      tieDia: detailing.tieDia,
      failureMode: capacity.failureMode,
      isReinforcementSafe: detailing.isReinforcementSafe,
    );
  }

  ColumnAnalysis _calculateSlenderness(ColumnInput input) {
    double k = 0.65;
    switch (input.endCondition) {
      case EndCondition.fixed: k = 0.65; break;
      case EndCondition.free: k = 2.0; break;
      case EndCondition.pinned: k = 1.0; break;
      case EndCondition.partial: k = 0.85; break;
    }

    final lex = k * input.length;
    final ley = k * input.length;
    final dimX = input.type == ColumnType.circular ? input.b : input.d;
    final dimY = input.b;

    final sx = lex / dimX;
    final sy = ley / dimY;
    final isShort = sx < 12 && sy < 12;

    final eminX = math.max(input.length / standard.eccentricityFactorL + dimX / standard.eccentricityFactorD, standard.eccentricityMin);
    final eminY = math.max(input.length / standard.eccentricityFactorL + dimY / standard.eccentricityFactorD, standard.eccentricityMin);

    double maxAddMx = 0;
    double maxAddMy = 0;
    if (!isShort) {
      maxAddMx = (input.pu * dimX / 2000) * math.pow(sx / 12, 2);
      maxAddMy = (input.pu * dimY / 2000) * math.pow(sy / 12, 2);
    }

    return ColumnAnalysis(
      lex: lex, ley: ley,
      slendernessX: sx, slendernessY: sy,
      isShort: isShort,
      isSlendernessSafe: sx <= 60 && sy <= 60,
      eminX: eminX, eminY: eminY,
      magnifiedMx: input.mx + maxAddMx,
      magnifiedMy: input.my + maxAddMy,
    );
  }

  ColumnCapacity _calculateCapacity(ColumnInput input, ColumnAnalysis analysis) {
    final fck = _getGradeValue(input.concreteGrade);
    final fy = _getGradeValue(input.steelGrade);

    double ag = input.type == ColumnType.circular
        ? (math.pi * math.pow(input.b, 2) / 4)
        : (input.b * input.d);

    double p = input.steelPercentage / 100;
    if (input.isAutoSteel) p = standard.minReinforcementRatio;

    final asc = p * ag;
    final ac = ag - asc;

    // Pure axial capacity
    final puz = (standard.stressBlockFactor * fck * ac + standard.compressionSteelFactor * fy * asc) / 1000;

    final dimX = input.type == ColumnType.circular ? input.b : input.d;
    final dimY = input.b;
    final mux1 = (standard.muLimitFactor(fy) * fck * dimY * math.pow(dimX, 2)) / 1e6;
    final muy1 = (standard.muLimitFactor(fy) * fck * dimX * math.pow(dimY, 2)) / 1e6;

    double interaction = 0;
    final puRatio = input.pu / puz;
    double an = standard.interactionPowerLow;
    if (puRatio <= standard.interactionLimitLow) {
      an = standard.interactionPowerLow;
    } else if (puRatio >= standard.interactionLimitHigh) {
      an = standard.interactionPowerHigh;
    } else {
      an = standard.interactionPowerLow + (puRatio - standard.interactionLimitLow) / (standard.interactionLimitHigh - standard.interactionLimitLow);
    }

    if (input.mx == 0 && input.my == 0) {
      interaction = input.pu / puz;
    } else {
      interaction = (math.pow(analysis.magnifiedMx / mux1, an) +
                    math.pow(analysis.magnifiedMy / muy1, an)).toDouble();
    }

    ColumnFailureMode mode = ColumnFailureMode.axial;
    if (!analysis.isShort) {
      mode = ColumnFailureMode.buckling;
    } else if (interaction > 1.0) {
      mode = (input.pu > puz * 0.5) ? ColumnFailureMode.compression : ColumnFailureMode.tension;
    }

    return ColumnCapacity(
      ag: ag,
      astRequired: asc,
      interactionRatio: interaction,
      isCapacitySafe: interaction <= 1.0,
      failureMode: mode,
    );
  }

  _ColumnDetailing _calculateDetailing(ColumnInput input, ColumnCapacity capacity) {
    final astReq = capacity.astRequired;
    final areaPerBar = (math.pi * math.pow(input.mainBarDia, 2)) / 4;
    int n = (astReq / areaPerBar).ceil();

    if (input.type == ColumnType.circular) {
      n = math.max(n, standard.minBarsCircular);
    } else {
      n = math.max(n, standard.minBarsRectangular);
      if (n % 2 != 0) n++;
    }

    final spacing = math.min(input.b, math.min(standard.tieSpacingFactor * input.mainBarDia, standard.tieSpacingLimit));
    final tieDia = math.max(input.mainBarDia / 4, 8.0);

    return _ColumnDetailing(
      numBars: n,
      tieSpacing: spacing,
      tieDia: tieDia,
      reinforcement: '$n Nos ${input.mainBarDia.toInt()}mm Longitudinal',
      ties: '${tieDia.toInt()}mm @ ${spacing.toInt()}mm c/c (Lateral)',
      isReinforcementSafe: (astReq / capacity.ag) >= standard.minReinforcementRatio,
    );
  }

  double _getGradeValue(String grade) {
    return double.tryParse(grade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 25;
  }
}

class _ColumnDetailing {
  final int numBars;
  final double tieSpacing;
  final double tieDia;
  final String reinforcement;
  final String ties;
  final bool isReinforcementSafe;

  _ColumnDetailing({
    required this.numBars,
    required this.tieSpacing,
    required this.tieDia,
    required this.reinforcement,
    required this.ties,
    required this.isReinforcementSafe,
  });
}
