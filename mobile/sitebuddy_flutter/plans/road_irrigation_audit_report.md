# Road & Irrigation Module Architecture Audit Report

**Date:** 2026-03-23  
**Auditor:** Senior Flutter Architect  
**Modules Audited:** `lib/features/transport/road` and `lib/features/water/irrigation`  
**Status:** Phase 4 Complete

---

## Executive Summary

The Road and Irrigation modules follow a **mostly clean architecture** with proper separation between Application, Domain, and Presentation layers. Both modules use Riverpod's `NotifierProvider` pattern correctly. However, **critical domain violations exist** around Pro user feature gating and hardcoded engineering values that violate multi-country support requirements.

---

## 1. CRITICAL FILES (Priority Order)

### CRITICAL-1: Pro User Feature Gating in Domain Services

**Files Affected:**
- [`lib/features/transport/road/domain/services/pavement_design_service.dart`](lib/features/transport/road/domain/services/pavement_design_service.dart:22) (Lines 22-34)
- [`lib/features/water/irrigation/domain/services/flow_simulation_service.dart`](lib/features/water/irrigation/domain/services/flow_simulation_service.dart:11) (Lines 11-13, 77-87)
- [`lib/features/water/irrigation/domain/services/canal_design_service.dart`](lib/features/water/irrigation/domain/services/canal_design_service.dart:46) (Lines 46-49, 58)

**Severity:** MEDIUM-HIGH

**Problem:** Domain services contain business logic mixed with Pro user feature gating. This violates the Single Responsibility Principle and makes the domain layer dependent on user subscription status.

**Why It's a Problem:**
1. Domain services should be pure business logic
2. Feature gating should happen at the Application/Presentation layer
3. Testing becomes harder when business logic is mixed with access control
4. Cannot reuse domain services in automated testing without mocking user status

**Example from `pavement_design_service.dart`:**
```dart
// Lines 22-34: PROBLEMATIC - Mixed responsibility
if (!isProUser) {
  allLayers = allLayers.map((l) {
    if (l.name.contains('GSB')) return l;
    return PavementLayer(
      name: 'Restricted Layer',
      thickness: l.thickness,
      materialType: 'Pro Feature Only',
      isLocked: true,
    );
  }).toList();
}
```

**Recommended Fix:**
- Domain services return full results with all data
- Application layer (Notifier) filters/restricts based on Pro status
- Presentation layer shows appropriate UI based on Pro status

---

### CRITICAL-2: Hardcoded Engineering Defaults in Calculator State

**Files Affected:**
- [`lib/features/transport/road/application/road_calculator.dart`](lib/features/transport/road/application/road_calculator.dart:34) (Lines 34-38)
- [`lib/features/water/irrigation/application/canal_calculator.dart`](lib/features/water/irrigation/application/canal_calculator.dart:28) (Lines 28-31)

**Severity:** MEDIUM

**Problem:** Calculator state classes contain hardcoded default values that represent India-specific engineering standards.

**Hardcoded Values in `road_calculator.dart`:**
```dart
this.initialTrafficInput = '1500',   // CVPD - India urban typical
this.growthRateInput = '5.0',         // % - India urban growth
this.designLifeInput = '15',          // years - IRC standard
this.vdfInput = '3.5',                // Vehicle Damage Factor
this.ldfInput = '0.75',               // Lane Distribution Factor
```

**Hardcoded Values in `canal_calculator.dart`:**
```dart
this.sideSlopeInput = '1.5',          // 1.5:1 typical
this.longitudinalSlopeInput = '0.001', // 1 in 1000
```

**Why It's a Problem:**
1. Defaults are India/IRC-specific
2. Cannot easily support multiple countries with different standards
3. Defaults should come from configurable standard providers
4. Violates the project's multi-country support goal

**Recommended Fix:**
- Create a `RoadDefaultsProvider` that returns country-specific defaults
- Inject defaults into Calculator state from providers
- Make defaults configurable per country/region

---

### CRITICAL-3: Hardcoded Safety Thresholds

**Files Affected:**
- [`lib/features/transport/road/domain/services/pavement_design_service.dart`](lib/features/transport/road/domain/services/pavement_design_service.dart:48) (Lines 48-51)
- [`lib/features/water/irrigation/domain/services/canal_design_service.dart`](lib/features/water/irrigation/domain/services/canal_design_service.dart:74) (Lines 74-78)

**Severity:** MEDIUM

**Problem:** Safety evaluation logic contains hardcoded threshold values that are IRC/India-specific.

**Hardcoded Thresholds in `pavement_design_service.dart`:**
```dart
String _evaluateSafety(double cbr, double thickness) {
  if (cbr < 3.0 && thickness < 600.0) 
    return 'CRITICAL (Subgrade too weak for current thickness)';
  if (thickness > 800.0) 
    return 'OVER-DESIGNED (Consider optimization)';
  return 'SAFE (As per IRC 37-2018)';
}
```

**Hardcoded Thresholds in `canal_design_service.dart`:**
```dart
String _evaluateVelocity(double v) {
  if (v < 0.6) return "SILTING RISK: v < 0.6 m/s";
  if (v > 2.5) return "SCOURING RISK: v > 2.5 m/s";
  return "SAFE VELOCITY: Non-silting/scouring";
}
```

**Why It's a Problem:**
1. Thresholds are India/IRC-specific (e.g., IRC 37-2018)
2. Cannot support multiple countries without code changes
3. Standards should be abstracted into configurable standard providers
4. Makes internationalization of engineering rules impossible

**Recommended Fix:**
- Thresholds should come from `RoadStandard` and `HydrologyStandard` providers
- Each country standard implementation provides its own thresholds
- Services call `standard.evaluateSafety(...)` instead of hardcoded logic

---

### CRITICAL-4: Missing Flow Simulation Calculator Notifier

**Files Affected:**
- [`lib/features/water/irrigation/domain/services/flow_simulation_service.dart`](lib/features/water/irrigation/domain/services/flow_simulation_service.dart) (Entire file)

**Severity:** LOW (Structural Gap)

**Problem:** A `FlowSimulationService` exists in the domain layer, but no corresponding `FlowSimulationCalculator` Notifier in the application layer.

**Why It's a Problem:**
1. Inconsistent with other domain services (all have corresponding calculators)
2. Flow simulation cannot be easily integrated into the UI
3. Violates the established application/domain separation pattern

**Recommended Fix:**
- Create `FlowSimulationCalculator` Notifier in `application/flow_simulation_calculator.dart`
- Follow the same pattern as `CanalCalculator` and `IrrigationCalculator`

---

## 2. QUICK WINS (High Impact, Low Effort)

### QW-1: Extract Default Values to Providers (30 min)

**Impact:** HIGH - Enables multi-country support  
**Effort:** LOW - Move constants to provider

**Action:**
```dart
// Create road_defaults_provider.dart
final roadDefaultsProvider = Provider<RoadDefaults>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return RoadDefaults.forCountry(settings.countryCode);
});

class RoadDefaults {
  final double defaultTraffic;
  final double defaultGrowthRate;
  final int defaultDesignLife;
  // ...
}
```

### QW-2: Extract Safety Thresholds to Standards (20 min)

**Impact:** MEDIUM - Standards become configurable  
**Effort:** LOW - Add methods to existing standard classes

**Action:**
```dart
// In RoadStandard interface
String evaluateSafety(double cbr, double thickness);

// In IRC37Standard implementation
@override
String evaluateSafety(double cbr, double thickness) {
  if (cbr < 3.0 && thickness < 600.0) 
    return 'CRITICAL';
  // ...
}
```

### QW-3: Create Flow Simulation Calculator (45 min)

**Impact:** MEDIUM - Completes the architecture  
**Effort:** LOW - Follow existing patterns

**Action:** Create `application/flow_simulation_calculator.dart` following `CanalCalculator` pattern

---

## 3. STRUCTURAL GAPS

### Gap-1: No UseCase Layer

**Current Structure:**
```
Application (Calculator Notifiers)
    ↓ calls
Domain (Services)
    ↓ uses
Core (Standards)
```

**Recommended Structure:**
```
Application (Calculator Notifiers)
    ↓ calls
UseCase (Business Operations)
    ↓ calls
Domain (Services)
    ↓ uses
Core (Standards)
```

**Why:** Complex calculations like pavement design benefit from a UseCase layer that orchestrates multiple services.

### Gap-2: No Country/Region Configuration Model

**Missing:** A `RegionConfig` model that defines:
- Country code
- Default standards to use
- Unit system
- Currency
- Engineering defaults

**Why:** Currently, standards are selected at compile time or hardcoded. Runtime region configuration would enable true multi-country support.

### Gap-3: No Standard Registry Pattern

**Current:** Each standard is a separate class  
**Recommended:** Registry pattern for standards

```dart
final standardRegistryProvider = Provider<StandardRegistry>((ref) {
  return StandardRegistry()
    ..register(RoadStandardType.irc37, IRC37Standard())
    ..register(RoadStandardType.aashto, AASHTOStandard())
    // ...
});
```

---

## 4. FILES THAT ARE WORKING CORRECTLY

The following files follow clean architecture principles correctly:

### ✅ Application Layer (Correct)
- [`lib/features/transport/road/application/road_calculator.dart`](lib/features/transport/road/application/road_calculator.dart) - Proper NotifierProvider pattern
- [`lib/features/water/irrigation/application/canal_calculator.dart`](lib/features/water/irrigation/application/canal_calculator.dart) - Proper NotifierProvider pattern
- [`lib/features/water/irrigation/application/irrigation_calculator.dart`](lib/features/water/irrigation/application/irrigation_calculator.dart) - Proper NotifierProvider pattern

### ✅ Presentation Layer (Correct)
- [`lib/features/transport/road/presentation/road_screen.dart`](lib/features/transport/road/presentation/road_screen.dart) - Pure ConsumerWidget, no business logic
- [`lib/features/water/irrigation/presentation/irrigation_screen.dart`](lib/features/water/irrigation/presentation/irrigation_screen.dart) - Pure ConsumerWidget, no business logic

### ✅ Domain Services (Mostly Correct)
- [`lib/features/transport/road/domain/services/traffic_analysis_service.dart`](lib/features/transport/road/domain/services/traffic_analysis_service.dart) - Clean, stateless
- [`lib/features/transport/road/domain/services/camber_design_service.dart`](lib/features/transport/road/domain/services/camber_design_service.dart) - Clean, stateless
- [`lib/features/water/irrigation/domain/services/irrigation_design_service.dart`](lib/features/water/irrigation/domain/services/irrigation_design_service.dart) - Clean, stateless
- [`lib/features/water/irrigation/domain/services/manning_service.dart`](lib/features/water/irrigation/domain/services/manning_service.dart) - Pure mathematical implementation

### ✅ Domain Models (Correct)
- All models in `domain/models/` folders are well-structured
- Proper separation of Input and Result models
- Immutable state with `const` constructors

---

## 5. STOP RULE VALIDATION

✅ **NO UI changes proposed** - All changes are to Application and Domain layers  
✅ **NO complete rewrites** - Incremental improvements only  
✅ **Existing patterns preserved** - NotifierProvider pattern maintained  
✅ **Repository interfaces unchanged** - No data layer changes  

---

## 6. RECOMMENDED REFACTORING ACTIONS

### Priority 1: Extract Pro Gating to Application Layer

**File:** `pavement_design_service.dart`  
**Action:** Return full `PavementDesignResult` without gating

```dart
// Domain service returns complete result
PavementDesignResult designPavement({
  required double cbr,
  required double msa,
}) {
  final double totalT = standard.thicknessFromCBR(cbr: cbr, traffic: msa);
  final List<PavementLayer> allLayers = standard.designLayers(cbr: cbr, msa: msa);
  final String safety = standard.evaluateSafety(cbr, totalT);
  
  return PavementDesignResult(
    totalThickness: totalT,
    layers: allLayers,
    safetyClassification: safety,
    cbrProvided: cbr,
    msaDesign: msa,
  );
}
```

**File:** `road_calculator.dart` (Application layer)  
**Action:** Filter results based on Pro status

```dart
Future<void> calculatePavement() async {
  // ... calculation logic ...
  
  final result = service.designPavement(cbr: cbr, msa: msa);
  
  // Filter layers if not Pro user
  final filteredLayers = state.isProUser 
    ? result.layers 
    : result.layers.where((l) => l.name.contains('GSB')).toList();
  
  state = state.copyWith(
    isLoading: false, 
    result: PavementDesignResult(
      totalThickness: result.totalThickness,
      layers: filteredLayers,
      safetyClassification: result.safetyClassification,
      isProUser: state.isProUser,
      cbrProvided: result.cbrProvided,
      msaDesign: result.msaDesign,
    ),
  );
}
```

### Priority 2: Extract Thresholds to Standards

**Action:** Add `evaluateSafety` method to `RoadStandard` interface and implementations

### Priority 3: Create Default Value Providers

**Action:** Create `RoadDefaultsProvider` that returns country-specific defaults

---

## 7. CONCLUSION

The Road and Irrigation modules have a **solid architectural foundation** with proper separation of concerns. The main issues are:

1. **Pro user gating in domain layer** - Should be moved to application layer
2. **Hardcoded engineering values** - Should be extracted to configurable providers
3. **Missing flow simulation calculator** - Should be created to complete architecture

All identified issues can be fixed **without breaking existing functionality** by following the incremental refactoring approach outlined above.

---

## Appendix: File Analysis Summary

| File | Type | Status | Issues |
|------|------|--------|--------|
| `road_calculator.dart` | Application | ✅ Good | Hardcoded defaults |
| `road_screen.dart` | Presentation | ✅ Good | None |
| `pavement_design_service.dart` | Domain | ⚠️ Review | Pro gating mixed with logic |
| `traffic_analysis_service.dart` | Domain | ✅ Good | None |
| `camber_design_service.dart` | Domain | ✅ Good | None |
| `canal_calculator.dart` | Application | ✅ Good | Hardcoded defaults |
| `irrigation_calculator.dart` | Application | ✅ Good | None |
| `irrigation_screen.dart` | Presentation | ✅ Good | None |
| `irrigation_design_service.dart` | Domain | ✅ Good | None |
| `canal_design_service.dart` | Domain | ⚠️ Review | Pro gating, hardcoded thresholds |
| `flow_simulation_service.dart` | Domain | ⚠️ Review | No calculator, Pro gating |
| `manning_service.dart` | Domain | ✅ Good | None |

**Legend:**
- ✅ Good: No issues, follows architecture
- ⚠️ Review: Needs minor refactoring
- ❌ Critical: Needs major refactoring
