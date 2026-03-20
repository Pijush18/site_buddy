import 'dart:math';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/beam_type.dart';

/// SERVICE: BeamDesignDomainService
/// PURPOSE: Pure engineering logic for Beam Design (IS 456:2000) - Domain Layer.
class BeamDesignDomainService {
  static final BeamDesignDomainService _instance =
      BeamDesignDomainService._internal();
  factory BeamDesignDomainService() => _instance;
  BeamDesignDomainService._internal();

  /// METHOD: calculateAnalysis
  /// Calculates Wu, Mu, Vu and generates BMD/SFD points.
  BeamDesignState calculateAnalysis(BeamDesignState state) {
    if (state.span <= 0) return state;

    final factor = state.isULS ? 1.5 : 1.0;
    final wu = (state.deadLoad + state.liveLoad) * factor;
    final pl = state.pointLoad * factor;
    final l = state.span; // mm

    double muMax = 0;
    double vuMax = 0;
    final List<DiagramPoint> sfd = [];
    final List<DiagramPoint> bmd = [];

    const segments = 50;
    final step = l / segments;

    for (int i = 0; i <= segments; i++) {
      final x = i * step;
      double vx = 0;
      double mx = 0;

      switch (state.type) {
        case BeamType.simplySupported:
          final r = (wu * (l / 1000) + pl) / 2;
          vx = r - (wu * (x / 1000));
          if (x > l / 2) vx -= pl;
          mx = (r * (x / 1000)) - (wu * (x / 1000) * (x / 1000) / 2);
          if (x > l / 2) mx -= pl * (x / 1000 - l / 2000);
          break;

        case BeamType.cantilever:
          vx = (wu * (l - x) / 1000) + (x == l ? 0 : pl);
          mx = (wu * pow((l - x) / 1000, 2) / 2) + (pl * (l - x) / 1000);
          break;

        case BeamType.continuous:
          final r = (wu * (l / 1000) + pl) / 2;
          vx = (r - (wu * (x / 1000))) * 1.2;
          mx = ((r * (x / 1000)) - (wu * (x / 1000) * (x / 1000) / 2)) * 0.8;
          break;
      }

      sfd.add(DiagramPoint(x, vx));
      bmd.add(DiagramPoint(x, mx));

      if (mx.abs() > muMax) muMax = mx.abs();
      if (vx.abs() > vuMax) vuMax = vx.abs();
    }

    return state.copyWith(
      mu: muMax,
      vu: vuMax,
      wu: wu,
      sfdPoints: sfd,
      bmdPoints: bmd,
    );
  }

  /// METHOD: calculateReinforcement
  BeamDesignState calculateReinforcement(BeamDesignState state) {
    var newState = _calculateFlexure(state);
    newState = _calculateShear(newState);
    newState = _calculateDeflection(newState);
    newState = _generateSuggestions(newState);
    return newState;
  }

  BeamDesignState _calculateFlexure(BeamDesignState state) {
    final fck = getGradeValue(state.concreteGrade);
    final fy = getGradeValue(state.steelGrade);
    final b = state.b;
    final d = state.d;
    final mu = state.mu * 1e6; // N-mm

    if (b <= 0 || d <= 0 || mu <= 0) return state;

    final xuMaxLimit = (fy >= 500) ? 0.46 : 0.48;
    final xuMax = xuMaxLimit * d;
    final astMin = (0.85 * b * d) / fy;
    final astMax = 0.04 * b * state.overallDepth;

    final a = (0.87 * fy * fy) / (b * d * fck);
    final bb = -(0.87 * fy * d);
    final c = mu;

    final discriminant = bb * bb - 4 * a * c;
    if (discriminant < 0) {
      return state.copyWith(
        errorMessage: 'Moment exceeds section capacity. Increase Depth.',
        isFlexureSafe: false,
      );
    }

    double astReq = (-bb - sqrt(discriminant)) / (2 * a);
    astReq = max(astReq, astMin);

    final xu = (0.87 * fy * astReq) / (0.36 * fck * b);
    bool isSafe = (xu <= xuMax) && (astReq <= astMax);

    final areaPerBar = (pi * pow(state.mainBarDia, 2)) / 4;
    final numBars = (astReq / areaPerBar).ceil();
    final astProv = numBars * areaPerBar;

    return state.copyWith(
      astRequired: astReq,
      astMin: astMin,
      astMax: astMax,
      xu: xu,
      xuMax: xuMax,
      numBars: numBars,
      astProvided: astProv,
      isFlexureSafe: isSafe,
      clearError: isSafe,
    );
  }

  BeamDesignState _calculateShear(BeamDesignState state) {
    final fck = getGradeValue(state.concreteGrade);
    final b = state.b;
    final d = state.d;
    final vu = state.vu * 1000; // N

    if (b <= 0 || d <= 0 || vu <= 0) return state;

    final tv = vu / (b * d);
    final tcMax = _getTcMax(fck);

    if (tv > tcMax) {
      return state.copyWith(
        tv: tv,
        tcMax: tcMax,
        isShearSafe: false,
        errorMessage: 'Shear stress tv > tcMax. Increase dimensions.',
      );
    }

    final pt = (state.astProvided * 100) / (b * d);
    final tc = _interpolateTc(pt, fck);

    double spacing = 0;
    final fy = getGradeValue(state.steelGrade);
    if (tv > tc) {
      final vus = vu - (tc * b * d);
      final asv = state.stirrupLegs * (pi * pow(state.stirrupDia, 2) / 4);
      spacing = (0.87 * fy * asv * d) / vus;
    } else {
      final asv = state.stirrupLegs * (pi * pow(state.stirrupDia, 2) / 4);
      spacing = (asv * 0.87 * fy) / (0.4 * b);
    }

    spacing = min(spacing, min(0.75 * d, 300));

    return state.copyWith(
      tv: tv,
      tc: tc,
      tcMax: tcMax,
      stirrupSpacing: spacing,
      isShearSafe: true,
    );
  }

  BeamDesignState _calculateDeflection(BeamDesignState state) {
    if (state.span <= 0 || state.d <= 0) return state;
    double basic = state.type == BeamType.cantilever
        ? 7
        : (state.type == BeamType.continuous ? 26 : 20);
    final pt = (state.astProvided * 100) / (state.b * state.d);
    double kt = 1.0;
    if (pt > 0) {
      kt = 1 / (0.225 + 0.00322 * pt + 0.625 * log(pt) / log(10));
      kt = max(0.7, min(2.0, kt));
    }
    return state.copyWith(
      isDeflectionSafe: (state.span / state.d) <= (basic * kt),
    );
  }

  BeamDesignState _generateSuggestions(BeamDesignState state) {
    final List<DesignSuggestion> list = [];

    if (!state.isFlexureSafe) {
      list.add(
        DesignSuggestion(
          title: 'Increase Depth',
          description:
              'Section is over-reinforced or under-designed for flexure.',
          action: 'Try D = ${(state.overallDepth + 50).toInt()} mm',
        ),
      );
    }

    if (!state.isShearSafe) {
      list.add(
        DesignSuggestion(
          title: 'Increase Width',
          description: 'Nominal shear exceeds permissible limits.',
          action: 'Try b = ${(state.width + 50).toInt()} mm',
        ),
      );
    }

    if (!state.isDeflectionSafe) {
      list.add(
        DesignSuggestion(
          title: 'Improve L/d Ratio',
          description: 'Beam is too slender for its span.',
          action: 'Increase depth or reduce span.',
        ),
      );
    }

    if (state.isFlexureSafe && (state.astProvided / state.astMax > 0.8)) {
      list.add(
        DesignSuggestion(
          title: 'Optimization',
          description: 'Reinforcement density is high.',
          action:
              'Increase Concrete Grade to M${getGradeValue(state.concreteGrade).toInt() + 5}',
        ),
      );
    }

    return state.copyWith(suggestions: list);
  }

  // Helpers
  double getGradeValue(String g) =>
      double.tryParse(g.replaceAll(RegExp(r'[^0-9]'), '')) ?? 25;
  double _getTcMax(double fck) => fck >= 40
      ? 4.0
      : (fck >= 35 ? 3.7 : (fck >= 30 ? 3.5 : (fck >= 25 ? 3.1 : 2.8)));
  double _interpolateTc(double pt, double fck) {
    if (pt <= 0.15) return 0.28;
    if (pt <= 0.25) return 0.36;
    if (pt <= 0.50) return 0.48;
    return 0.71;
  }
}



