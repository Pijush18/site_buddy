# Domain Layer Pro Gating Violation Report

**Date:** 2026-03-23  
**Auditor:** Senior Flutter Architect  
**Task:** Remove Pro/premium gating from domain layer, relocate to Application layer  

---

## 1. VIOLATION SUMMARY

| File | Violations | Severity | Lines |
|------|------------|----------|-------|
| `pavement_design_service.dart` | 3 | HIGH | 13, 16, 22-34, 42 |
| `flow_simulation_service.dart` | 2 | HIGH | 10-13, 77-87 |
| `canal_design_service.dart` | 2 | MEDIUM | 46-49, 58 |

---

## 2. DETAILED VIOLATION ANALYSIS

### VIOLATION #1: `pavement_design_service.dart`

**Path:** `lib/features/transport/road/domain/services/pavement_design_service.dart`

#### Violation A: Method signature contains `isProUser`
```dart
// Line 13-16: VIOLATION - Domain knows about user plans
PavementDesignResult designPavement({
  required double cbr,
  required double msa,
  required bool isProUser,  // ❌ REMOVE
});
```
**Why:** Domain methods should only receive business parameters, not user plan information.

#### Violation B: Layer restriction logic based on Pro status
```dart
// Lines 22-34: VIOLATION - Business logic gated by user plan
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
**Why:** Domain should return complete, truthful results. Policy decisions belong in Application layer.

#### Violation C: `isProUser` passed to result model
```dart
// Line 42: VIOLATION - Result model contains user plan info
return PavementDesignResult(
  // ...
  isProUser: isProUser,  // ❌ REMOVE
  // ...
);
```

---

### VIOLATION #2: `flow_simulation_service.dart`

**Path:** `lib/features/water/irrigation/domain/services/flow_simulation_service.dart`

#### Violation A: Early return for non-Pro users
```dart
// Lines 10-13: VIOLATION - Domain chooses what to return based on user plan
FlowResult simulate(FlowInput input) {
  if (!input.isProUser) {  // ❌ REMOVE check
    return _generateBasicResult(input);  // Returns truncated result
  }
  // ...
}
```

#### Violation B: Truncated result generation
```dart
// Lines 77-87: VIOLATION - Returns "locked" message instead of actual data
FlowResult _generateBasicResult(FlowInput input) {
  return FlowResult(
    distancePoints: [0.0, input.totalLength],
    velocityProfile: [input.initialVelocity, input.initialVelocity],
    dischargeProfile: [0.0, 0.0],  // ❌ Fake data
    depthProfile: [input.initialDepth, input.initialDepth],
    totalHeadLoss: 0.0,  // ❌ Zero instead of real calculation
    simulationSummary: "[PRO FEATURE] ... locked.",  // ❌ Gating message
  );
}
```

**Why:** Domain should ALWAYS compute full results. The Application layer decides what to show.

---

### VIOLATION #3: `canal_design_service.dart`

**Path:** `lib/features/water/irrigation/domain/services/canal_design_service.dart`

#### Violation A: Pro-only optimization tip
```dart
// Lines 46-49: VIOLATION - Business logic gated by user plan
if (input.isProUser && efficiency < 90) {
  final double optWidth = (a / y) - (z * y);
  note += " | PRO TIP: Optimize Bed Width to ${optWidth.toStringAsFixed(2)}m.";
}
```
**Why:** Optimization suggestions should be computed always, Application layer decides to show them.

#### Violation B: Pro-only optimization flag
```dart
// Line 58: VIOLATION - Result field is Pro-specific
isOptimized: input.isProUser && efficiency >= 95,  // ❌ GATED
```

---

## 3. MODEL POLLUTION ANALYSIS

### Models Containing Pro Flags (Domain Contamination)

| Model | Fields | Action |
|-------|--------|--------|
| `PavementDesignResult` | `isProUser` | Remove from domain, add to state |
| `PavementLayer` | `isLocked` | Remove - replaced by `upgradeRequired` in state |
| `FlowInput` | `isProUser` | Remove - passed separately to Notifier |
| `CanalInput` | `isProUser` | Remove - passed separately to Notifier |
| `CanalResult` | `isOptimized` | Remove - replaced by `upgradeRequired` in state |

---

## 4. CLEANUP PLAN

### Step 1: Clean Domain Models
- Remove `isProUser` from `PavementDesignResult`, `FlowInput`, `CanalInput`
- Remove `isLocked` from `PavementLayer`
- Remove `isOptimized` from `CanalResult`

### Step 2: Clean Domain Services
- `pavement_design_service.dart`: Remove `isProUser` param, always return full layers
- `flow_simulation_service.dart`: Remove `isProUser` check, always run full simulation
- `canal_design_service.dart`: Always compute optimization data, remove gating

### Step 3: Update Application Layer (Notifiers)
- Add `upgradeRequired` flag to state classes
- After calling domain, apply Pro restrictions in Notifier
- Set `upgradeRequired = true` for locked features

### Step 4: Update Result Models (Optional State)
- Create wrapper models in Application layer with Pro-specific fields
- Or: Add Pro fields directly to state classes (simpler approach)

---

## 5. SUCCESS CRITERIA

✅ Domain services accept ONLY business parameters  
✅ Domain services return ONLY computed results  
✅ Domain services have ZERO knowledge of user plans  
✅ Notifiers call domain, then apply policy  
✅ State classes carry Pro-specific UI flags  
✅ Full calculations always performed before any restriction  
