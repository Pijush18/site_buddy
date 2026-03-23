# Hardcoded Engineering Defaults Extraction Report

**Date:** 2026-03-23  
**Task:** Identify and extract hardcoded engineering defaults into configurable providers  
**Status:** ANALYSIS COMPLETE

---

## 1. CRITICAL FILES WITH HARDCODED DEFAULTS

### Category: ROAD MODULE

#### File: `road_calculator.dart` (HIGH PRIORITY)

| Value | Default | Line | Why Risky |
|-------|---------|------|-----------|
| `initialTrafficInput` | `'1500'` | 43 | India-specific CVPD typical value |
| `growthRateInput` | `'5.0'` | 44 | India urban growth rate |
| `designLifeInput` | `'15'` | 45 | IRC standard (may vary by country) |
| `vdfInput` | `'3.5'` | 46 | Vehicle Damage Factor for NH/SH |
| `ldfInput` | `'0.75'` | 47 | Lane Distribution Factor |

**Impact:** Cannot support multi-country without code changes

---

#### File: `irc_37_2018.dart` (MEDIUM PRIORITY)

| Value | Default | Line | Why Risky |
|-------|---------|------|-----------|
| `minBaseThickness` | `225.0` | 9 | IRC-specific WMM minimum |
| `minSurfaceThickness` | `40.0` | 10 | IRC-specific BC minimum |
| `poorSubgradeThreshold` | `3.0` | 11 | IRC CBR threshold |
| `heavyTrafficThreshold` | `30.0` | 12 | MSA classification |
| `mediumTrafficThreshold` | `10.0` | 13 | MSA classification |
| `defaultVDF` | `3.5` | 19 | India-specific |
| `growthRateLimits.max` | `12.0` | 24 | IRC guideline |
| `growthRateLimits.default` | `5.0` | 25 | India urban |
| `minCBR` | `5.0` | 29 | IRC minimum |
| `layerDistribution` | 7/18/35/40% | 66-69 | IRC layer ratios |
| `designThickness formula` | `3432 * msa^0.116 * CBR^-0.6` | 46 | IRC-specific equation |
| `safety thickness` | `600.0 / 800.0` | 109, 112 | IRC thresholds |

**Impact:** IRC-specific, cannot swap to AASHTO without complete rewrite

---

#### File: `camber_design_service.dart` (MEDIUM PRIORITY)

| Value | Default | Line | Why Risky |
|-------|---------|------|-----------|
| Camber % - CC/Bit | `2.0 / 1.7` | 13 | IRC surface type specific |
| Camber % - WBM | `3.0 / 2.5` | 15-16 | IRC surface type specific |
| Camber % - Earth | `4.0 / 3.0` | 17-18 | IRC surface type specific |

**Impact:** Surface type thresholds are IRC-specific

---

### Category: IRRIGATION MODULE

#### File: `canal_calculator.dart` (HIGH PRIORITY)

| Value | Default | Line | Why Risky |
|-------|---------|------|-----------|
| `sideSlopeInput` | `'1.5'` | 35 | Typical but may vary by soil |
| `longitudinalSlopeInput` | `'0.001'` | 37 | Common but site-specific |

**Impact:** Typical defaults that should be configurable

---

#### File: `flow_simulation_calculator.dart` (HIGH PRIORITY)

| Value | Default | Line | Why Risky |
|-------|---------|------|-----------|
| `velocityInput` | `'1.0'` | 36 | Arbitrary starting value |
| `depthInput` | `'1.5'` | 37 | Arbitrary depth |
| `widthInput` | `'3.0'` | 38 | Arbitrary width |
| `slopeInput` | `'0.001'` | 39 | Common but site-specific |
| `roughnessInput` | `'0.013'` | 40 | Concrete Manning's n |
| `lengthInput` | `'100'` | 41 | Arbitrary length |
| `segmentsInput` | `'10'` | 42 | Simulation precision |

**Impact:** All values are site-specific, should come from user context or standards

---

#### File: `canal_design_service.dart` (MEDIUM PRIORITY)

| Value | Default | Line | Why Risky |
|-------|---------|------|-----------|
| Velocity safety - silting | `0.6 m/s` | 85 | FAO/IS specific |
| Velocity safety - scouring | `2.5 m/s` | 86 | FAO/IS specific |
| Efficiency threshold | `90%` | 56 | Optimization trigger |

**Impact:** Velocity limits vary by soil type and crop

---

#### File: `basic_hydrology_standard.dart` (MEDIUM PRIORITY)

| Value | Default | Line | Why Risky |
|-------|---------|------|-----------|
| Manning's n - Concrete | `0.013` | 19 | Standard value |
| Manning's n - Earth | `0.025` | 20 | Standard value |
| Manning's n - Brick | `0.015` | 22 | Standard value |
| Manning's n - Gravel | `0.020` | 23 | Standard value |
| Slope limits | 1:500 to 1:5000 | 38-40 | Material-specific |

**Impact:** These are fairly universal but could be made configurable

---

## 2. CLASSIFICATION SUMMARY

| Category | Files | Count | Risk Level |
|----------|-------|-------|------------|
| **Road Traffic Defaults** | `road_calculator.dart` | 5 values | HIGH |
| **Road IRC Standards** | `irc_37_2018.dart` | 12 values | MEDIUM |
| **Road Camber** | `camber_design_service.dart` | 6 values | MEDIUM |
| **Canal Defaults** | `canal_calculator.dart` | 2 values | HIGH |
| **Flow Simulation Defaults** | `flow_simulation_calculator.dart` | 7 values | HIGH |
| **Canal Safety Thresholds** | `canal_design_service.dart` | 3 values | MEDIUM |
| **Hydrology Manning's** | `basic_hydrology_standard.dart` | 5 values | LOW |

---

## 3. EXTRACTION PLAN

### Strategy: Provider-Based Configuration

```
┌─────────────────────────────────────────────────────────┐
│                  RegionConfigProvider                     │
│  (Country code → Standard type mapping)                  │
└─────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┼───────────────┐
          ▼               ▼               ▼
   ┌────────────┐  ┌────────────┐  ┌────────────┐
   │RoadDefaults│  │CanalDefaults│ │FlowDefaults│
   │ Provider   │  │ Provider    │ │ Provider   │
   └────────────┘  └────────────┘  └────────────┘
          │               │               │
          ▼               ▼               ▼
   ┌────────────┐  ┌────────────┐  ┌────────────┐
   │ Calculator │  │ Calculator │  │ Calculator │
   │  Notifier  │  │  Notifier  │  │  Notifier  │
   └────────────┘  └────────────┘  └────────────┘
```

### Target: TOP 3 Files for Refactoring

1. **`road_calculator.dart`** - Traffic defaults (highest business impact)
2. **`canal_calculator.dart`** - Canal geometry defaults
3. **`flow_simulation_calculator.dart`** - Flow simulation defaults

### Future Support Requirements

| Requirement | Implementation |
|-------------|----------------|
| Multi-country | `RegionConfig` model with country codes |
| Standard switching | `StandardRegistry` pattern |
| Dynamic defaults | Provider overrides at runtime |
| User preferences | `SharedPreferences` integration |

---

## 4. PROPOSED PROVIDER STRUCTURE

### RoadDefaults

```dart
class RoadDefaults {
  final double defaultInitialTraffic;    // CVPD
  final double defaultGrowthRate;       // %
  final int defaultDesignLife;          // years
  final double defaultVDF;
  final double defaultLDF;
  final int defaultLanes;
}

final roadDefaultsProvider = Provider<RoadDefaults>((ref) {
  final region = ref.watch(regionConfigProvider);
  return region.roadDefaults;
});
```

### CanalDefaults

```dart
class CanalDefaults {
  final double defaultSideSlope;
  final double defaultSlope;
  final String defaultMaterial;
  final double minVelocity;  // Silting threshold
  final double maxVelocity;  // Scouring threshold
}

final canalDefaultsProvider = Provider<CanalDefaults>((ref) {
  final region = ref.watch(regionConfigProvider);
  return region.canalDefaults;
});
```

### FlowSimulationDefaults

```dart
class FlowSimulationDefaults {
  final double defaultVelocity;
  final double defaultDepth;
  final double defaultWidth;
  final double defaultSlope;
  final double defaultRoughness;
  final double defaultLength;
  final int defaultSegments;
}

final flowSimulationDefaultsProvider = Provider<FlowSimulationDefaults>((ref) {
  final region = ref.watch(regionConfigProvider);
  return region.flowSimulationDefaults;
});
```

---

## 5. TARGET CHANGES (TOP 3 FILES)

### Change 1: `road_calculator.dart`

**Before:**
```dart
const RoadCalculatorState({
  this.initialTrafficInput = '1500',  // ❌ Hardcoded
  this.growthRateInput = '5.0',       // ❌ Hardcoded
  this.designLifeInput = '15',         // ❌ Hardcoded
  this.vdfInput = '3.5',              // ❌ Hardcoded
  this.ldfInput = '0.75',             // ❌ Hardcoded
});
```

**After:**
```dart
class RoadCalculator extends Notifier<RoadCalculatorState> {
  @override
  RoadCalculatorState build() {
    final defaults = ref.watch(roadDefaultsProvider);
    return RoadCalculatorState(
      initialTrafficInput: defaults.defaultInitialTraffic.toString(),
      growthRateInput: defaults.defaultGrowthRate.toString(),
      designLifeInput: defaults.defaultDesignLife.toString(),
      vdfInput: defaults.defaultVDF.toString(),
      ldfInput: defaults.defaultLDF.toString(),
    );
  }
}
```

---

### Change 2: `canal_calculator.dart`

**Before:**
```dart
const CanalCalculatorState({
  this.sideSlopeInput = '1.5',           // ❌ Hardcoded
  this.longitudinalSlopeInput = '0.001', // ❌ Hardcoded
  this.material = 'Concrete',
});
```

**After:**
```dart
class CanalCalculator extends Notifier<CanalCalculatorState> {
  @override
  CanalCalculatorState build() {
    final defaults = ref.watch(canalDefaultsProvider);
    return CanalCalculatorState(
      sideSlopeInput: defaults.defaultSideSlope.toString(),
      longitudinalSlopeInput: defaults.defaultSlope.toString(),
      material: defaults.defaultMaterial,
    );
  }
}
```

---

### Change 3: `flow_simulation_calculator.dart`

**Before:**
```dart
const FlowSimulationCalculatorState({
  this.velocityInput = '1.0',
  this.depthInput = '1.5',
  this.widthInput = '3.0',
  this.slopeInput = '0.001',
  this.roughnessInput = '0.013',
  this.lengthInput = '100',
  this.segmentsInput = '10',
});
```

**After:**
```dart
class FlowSimulationCalculator extends Notifier<FlowSimulationCalculatorState> {
  @override
  FlowSimulationCalculatorState build() {
    final defaults = ref.watch(flowSimulationDefaultsProvider);
    return FlowSimulationCalculatorState(
      velocityInput: defaults.defaultVelocity.toString(),
      depthInput: defaults.defaultDepth.toString(),
      widthInput: defaults.defaultWidth.toString(),
      slopeInput: defaults.defaultSlope.toString(),
      roughnessInput: defaults.defaultRoughness.toString(),
      lengthInput: defaults.defaultLength.toString(),
      segmentsInput: defaults.defaultSegments.toString(),
    );
  }
}
```

---

## 6. IMPLEMENTATION NOTES

1. **Minimal Changes** - Only the state initialization moves to providers
2. **Backward Compatible** - Users who have existing values in state keep them
3. **No UI Changes** - Only Application layer modified
4. **No Domain Changes** - Domain logic remains untouched
5. **Provider Safety** - Use `ref.watch` for reactive defaults

---

## 7. FILES TO CREATE

1. `lib/core/config/road_defaults.dart` - RoadDefaults class and provider
2. `lib/core/config/canal_defaults.dart` - CanalDefaults class and provider
3. `lib/core/config/flow_defaults.dart` - FlowSimulationDefaults class and provider

---

## 8. FILES TO MODIFY

1. `lib/features/transport/road/application/road_calculator.dart`
2. `lib/features/water/irrigation/application/canal_calculator.dart`
3. `lib/features/water/irrigation/application/flow_simulation_calculator.dart`
