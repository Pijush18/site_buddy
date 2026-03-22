import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';
import 'package:site_buddy/features/design/application/services/footing_validator.dart';
import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/design/footing/footing_models.dart';
import 'package:site_buddy/features/design/footing/footing_design_service.dart' as domain;

/// SERVICE: FootingDesignService (Application Layer)
/// PURPOSE: Orchestrates footing design by delegating to domain logic.
class FootingDesignService {
  final domain.FootingDesignService domainService;

  FootingDesignService(DesignStandard standard) 
      : domainService = domain.FootingDesignService(standard);

  /// Main pipeline orchestrator
  FootingDesignState runPipeline(FootingDesignState state) {
    // 1. Validation
    final error = FootingValidator.validate(state);
    if (error != null) {
      return state.copyWith(errorMessage: error);
    }

    // 2. Convert to Domain Input
    final input = FootingInput(
      type: state.type,
      columnLoad: state.columnLoad,
      sbc: state.sbc,
      footingLength: state.footingLength,
      footingWidth: state.footingWidth,
      footingThickness: state.footingThickness,
      concreteGrade: state.concreteGrade,
      steelGrade: state.steelGrade,
      momentX: state.momentX,
      momentY: state.momentY,
    );

    // 3. Delegate to Domain Service
    final result = domainService.designFooting(input);

    // 4. Map Result back to State
    return state.copyWith(
      requiredArea: result.areaRequired,
      providedArea: result.providedArea,
      maxSoilPressure: result.maxSoilPressure,
      minSoilPressure: result.minSoilPressure,
      isAreaSafe: result.isAreaSafe,
      qu: (state.columnLoad * domainService.standard.gammaLoad) / result.providedArea,
      effDepth: state.footingThickness - 50,
      mu: result.muX,
      vu: result.shearForceOneWay,
      vup: result.shearForcePunching,
      astProvidedX: result.astProvidedX,
      astProvidedY: result.astProvidedY,
      isOneWayShearSafe: result.isOneWayShearSafe,
      isPunchingShearSafe: result.isPunchingShearSafe,
      isBendingSafe: result.isBendingSafe,
    );
  }
}



