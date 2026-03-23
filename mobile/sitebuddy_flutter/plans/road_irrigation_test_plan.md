# Road & Irrigation Module Testing Strategy

## Overview

This document defines the testing strategy for Road (transport) and Irrigation (water) modules, focusing on **business logic accuracy** rather than UI testing.

---

## 1. TEST PLAN

### Priority Matrix

| Priority | Domain Area | Test Type | Risk |
|----------|--------------|------------|------|
| P0-Critical | Pavement thickness calculation | Golden case | High |
| P0-Critical | Traffic ESAL calculation | Golden case | High |
| P0-Critical | FAO-56 ET₀ calculation | Golden case | High |
| P0-Critical | Scenario factor consistency | Validation | High |
| P1-High | Soil moisture balance | Golden case | Medium |
| P1-High | Crop water requirement | Golden case | Medium |
| P2-Medium | Traffic classification | Boundary | Low |
| P2-Medium | Irrigation efficiency | Golden case | Low |
| P3-Low | Edge case handling | Error cases | Low |

### Testing Scope

**In Scope:**
- Domain calculations (standards, services)
- Scenario factor validation
- Edge case handling
- Notifier state transitions

**Out of Scope:**
- UI rendering tests
- Animation tests
- Network/integration tests
- Third-party service mocking

---

## 2. TEST STRUCTURE

```
lib/core/qa/test_cases/
├── [existing test files...]
├── road_pavement_test_cases.dart      # Pavement & traffic domain tests
├── irrigation_fao_test_cases.dart     # FAO-56 crop water tests
├── soil_moisture_test_cases.dart      # Soil irrigation logic tests
├── pavement_controller_test_cases.dart # Road notifier tests
├── irrigation_controller_test_cases.dart # Irrigation notifier tests
└── scenario_consistency_test_cases.dart  # Cross-module scenario validation
```

### Naming Convention

- Test file: `<feature>_<aspect>_test_cases.dart`
- Test case ID: `<PREFIX>_<NUMBER>`
  - Road: `RD_<NNN>` (e.g., RD_001)
  - Irrigation: `IR_<NNN>` (e.g., IR_001)
  - Scenario: `SC_<NNN>` (e.g., SC_001)

---

## 3. IMPLEMENTATION

### Domain Test Cases

#### Road Module (Pavement & Traffic)

1. **RD_001**: Standard CBR (10%) + MSA (10) → Verify thickness ≥ 300mm
2. **RD_002**: Poor subgrade (CBR 2%) → Verify penalty applied
3. **RD_003**: ESAL calculation with growth
4. **RD_004**: Layer distribution proportions
5. **RD_005**: Traffic classification boundaries

#### Irrigation Module (FAO-56)

1. **IR_001**: Standard climate → ET₀ calculation
2. **IR_002**: Crop Kc at different growth stages
3. **IR_003**: Effective rainfall calculation
4. **IR_004**: Crop water requirement for wheat
5. **IR_005**: Soil moisture balance

### Notifier Test Cases

#### Road (PavementController)

1. **NC_RD_001**: Standard input → verify state transitions
2. **NC_RD_002**: Pro feature gating (optimized scenario)
3. **NC_RD_003**: Error handling (invalid CBR)

#### Irrigation

1. **NC_IR_001**: Standard input → verify calculation triggers
2. **NC_IR_002**: Pro feature gating (optimization)
3. **NC_IR_003**: Edge case (zero area)

### Scenario Consistency Tests

1. **SC_001**: Road scenarios (conservative ≥ standard ≥ optimized)
2. **SC_002**: Irrigation scenarios (conservative ≥ standard ≥ optimized)
3. **SC_003**: Cross-module scenario isolation

---

## 4. MOCKING STRATEGY

### Layer Isolation

```
┌─────────────────────────────────────────────┐
│            PRESENTATION (Screens)           │  ← NOT TESTED
├─────────────────────────────────────────────┤
│            NOTIFIERS / CONTROLLERS          │  ← Test state only
├─────────────────────────────────────────────┤
│              APPLICATION (Services)         │  ← Test calculations
├─────────────────────────────────────────────┤
│              DOMAIN (Models/Standards)      │  ← Test logic
├─────────────────────────────────────────────┤
│                 CORE (Engine)               │  ← Test utilities
└─────────────────────────────────────────────┘
```

### Mocking Rules

1. **Domain tests**: No mocking needed - test pure functions
2. **Service tests**: Inject mock standards
3. **Notifier tests**: Mock services, verify state changes
4. **No network mocking** - all tests are deterministic

---

## 5. EDGE CASES TO COVER

### Input Validation

| Edge Case | Expected Behavior |
|-----------|------------------|
| Zero CBR | Return minimum thickness (300mm) |
| Negative MSA | Clamp to 0.01 MSA |
| Zero temperature | Calculate ET₀ (valid) |
| 100% humidity | Calculate ET₀ (valid) |
| Extreme rainfall | Cap at reasonable maximum |

### Boundary Conditions

| Boundary | Test |
|----------|------|
| CBR = 3% | Poor subgrade threshold |
| MSA = 10 | Medium traffic threshold |
| MSA = 30 | Heavy traffic threshold |
| Humidity = 0% | Valid calculation |

---

## 6. VALIDATION CHECKLIST

- [ ] All tests pass locally
- [ ] No flaky tests (deterministic)
- [ ] Tolerances are reasonable (1-5%)
- [ ] Tests document expected behavior
- [ ] Edge cases documented
- [ ] Scenario consistency verified

---

## 7. REGRESSION SAFETY

### When to Add Tests

1. New standard implementation
2. New scenario type
3. Bug fix with calculation change
4. New crop/soil type
5. Algorithm optimization

### Golden Case Protection

- Golden cases are versioned
- Any change requires test update + approval
- Tolerance changes require explicit justification
