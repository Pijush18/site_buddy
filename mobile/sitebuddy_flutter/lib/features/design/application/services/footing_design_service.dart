import 'dart:math';
import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/footing_type.dart';
import 'package:site_buddy/features/design/application/services/footing_validator.dart';

/// SERVICE: FootingDesignService
/// PURPOSE: Business logic for footing calculations based on IS 456:2000.
class FootingDesignService {
  /// Main pipeline orchestrator
  FootingDesignState runPipeline(FootingDesignState state) {
    // 0. Validation
    final error = FootingValidator.validate(state);
    if (error != null) {
      return state.copyWith(errorMessage: error);
    }

    var newState = state;

    // 1. Working Load Analysis (for Area & SBC)
    newState = _calculateBasicAnalysis(newState);

    // 2. Factored Load Analysis (for Structural Design)
    newState = _calculateStructuralAnalysis(newState);

    return newState;
  }

  FootingDesignState _calculateBasicAnalysis(FootingDesignState state) {
    double totalVerticalLoad = 0;
    double netMomentX = 0;
    double netMomentY = 0;

    if (state.type == FootingType.combined || state.type == FootingType.strap) {
      totalVerticalLoad = state.columnLoad + state.columnLoad2;
      // Resultant location for eccentricity (simplified)
      netMomentX = state.momentX + state.momentX2;
      netMomentY = state.momentY + state.momentY2;
    } else if (state.type == FootingType.raft) {
      totalVerticalLoad =
          state.columnLoad * 4; // Simplified: 4 identical columns for raft demo
    } else {
      totalVerticalLoad = state.columnLoad;
      netMomentX = state.momentX;
      netMomentY = state.momentY;
    }

    // Add 10% self-weight
    final totalWorkingLoad = totalVerticalLoad * 1.1;
    final reqArea = totalWorkingLoad / state.sbc;

    final L = state.footingLength / 1000;
    final B = state.footingWidth / 1000;
    final provArea = L * B;

    // pressure distribution q = P/A +/- M/Z
    // Z = B*L^2 / 6 (for bending about B axis)
    final ex = totalVerticalLoad > 0 ? (netMomentX / totalVerticalLoad) : 0.0;
    final ey = totalVerticalLoad > 0 ? (netMomentY / totalVerticalLoad) : 0.0;

    final qAvg = totalWorkingLoad / provArea;
    final qMax = qAvg * (1 + (6 * ex / L) + (6 * ey / B));
    final qMin = qAvg * (1 - (6 * ex / L) - (6 * ey / B));

    final isAreaSafe = qMax <= state.sbc;

    // Pile logic
    int pilesReq = 0;
    if (state.type == FootingType.pile) {
      pilesReq = (totalWorkingLoad / state.pileCapacity).ceil();
    }

    return state.copyWith(
      requiredArea: reqArea,
      providedArea: provArea,
      maxSoilPressure: qMax,
      minSoilPressure: qMin,
      isAreaSafe: isAreaSafe,
      pileCount: pilesReq,
      isSettlementWarning: state.sbc < 100,
      eccentricityX: ex * 1000,
      eccentricityY: ey * 1000,
    );
  }

  FootingDesignState _calculateStructuralAnalysis(FootingDesignState state) {
    final pu1 = state.columnLoad * 1.5;
    final pu2 = state.columnLoad2 * 1.5;
    final totalPu = pu1 + pu2;

    final B = state.footingWidth / 1000;
    final qu = totalPu / state.providedArea; // Factored Net Pressure

    const cover = 50.0;
    final dEff = state.footingThickness - cover - (state.mainBarDia / 2);

    // Mu calculation (at face of strongest loaded column)
    final maxProjL = (state.footingLength - state.colA) / 2000;
    final mu = (qu * B * maxProjL * maxProjL) / 2;

    // One-way shear at distance d
    final distD = dEff / 1000;
    final criticalProjL = maxProjL - distD;
    final vu = (qu * B) * (criticalProjL > 0 ? criticalProjL : 0);

    // Punching shear at d/2
    final perimDist = dEff / 1000 / 2;
    final perimA = (state.colA / 1000) + 2 * perimDist;
    final perimB = (state.colB / 1000) + 2 * perimDist;
    final areaInside = perimA * perimB;
    final vup = qu * (state.providedArea - areaInside);

    // Reinforcement
    final fck = _getGradeValue(state.concreteGrade);
    final fy = _getGradeValue(state.steelGrade);
    final rootTerm =
        1 - (4.6 * mu * 1000000 / (fck * state.footingWidth * dEff * dEff));
    final ast = (rootTerm > 0)
        ? (0.5 * (fck / fy) * (1 - sqrt(rootTerm)) * state.footingWidth * dEff)
        : (state.providedArea * 12 / 10000);

    // Safety checks
    final tauCPunch = 0.25 * sqrt(fck);
    final punchPerim = 2 * (perimA + perimB) * 1000;
    final tauVPunch = (vup * 1000) / (punchPerim * dEff);
    final isPunchSafe = tauVPunch <= tauCPunch;

    const tauC1Way = 0.35;
    final tauV1Way = (vu * 1000) / (state.footingWidth * dEff);
    final is1WaySafe = tauV1Way <= tauC1Way;

    return state.copyWith(
      qu: qu,
      effDepth: dEff,
      mu: mu,
      vu: vu,
      vup: vup,
      astProvidedX: ast,
      astProvidedY: ast,
      tauC: tauC1Way,
      tauV: tauV1Way,
      isOneWayShearSafe: is1WaySafe,
      isPunchingShearSafe: isPunchSafe,
      isBendingSafe: rootTerm > 0,
    );
  }

  double _getGradeValue(String grade) {
    return double.tryParse(grade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 25;
  }
}



