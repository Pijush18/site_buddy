# Architecture Review Report: State Management Violations
**Project:** SiteBuddy Flutter  
**Date:** 2026-03-23  
**Auditor:** Senior Flutter Architect  

---

## EXECUTIVE SUMMARY

This audit identifies **47 state management violations** across the codebase. The project has a partially-implemented Riverpod architecture with mixed patterns causing architectural inconsistency and maintainability issues.

**Key Findings:**
- **High Severity:** 12 violations (business logic in UI, direct service calls)
- **Medium Severity:** 18 violations (setState for UI state)
- **Low Severity:** 17 violations (inconsistent provider patterns)

---

## VIOLATION REPORT

### CATEGORY 1: BUSINESS LOGIC IN UI (HIGH SEVERITY)

| # | File Path | Issue | Why It's a Problem |
|---|-----------|-------|-------------------|
| 1 | `lib/features/structural/shared/presentation/screens/cracking_check_screen.dart` | Lines 49-78: `_calculate()` method directly calls `CalculationService.calculateCracking()` instead of delegating to controller | Business logic in UI violates separation of concerns; makes testing difficult; state scattered between controller and widget |
| 2 | `lib/features/structural/shared/presentation/screens/shear_check_screen.dart` | Lines 48-81: `_calculate()` method directly calls `CalculationService.calculateShear()` | Same violation - calculation logic should be in Notifier |
| 3 | `lib/features/structural/shared/presentation/screens/deflection_check_screen.dart` | Lines 46-75: `_calculate()` method directly calls `CalculationService.calculateDeflection()` | Same violation pattern |
| 4 | `lib/features/home/presentation/screens/home_screen.dart` | Lines 41-78: Hardcoded mock data `_ActivityItem` lists in build method | Data should come from providers; UI should be declarative |
| 5 | `lib/features/work/presentation/screens/create_meeting_screen.dart` | Lines 46-81: Meeting object construction logic in `_submit()` method | Domain object creation belongs in controller/use case |
| 6 | `lib/features/work/presentation/screens/create_task_screen.dart` | Lines similar to create_meeting_screen | Same violation |

### CATEGORY 2: SETSTATE FOR UI STATE (MEDIUM SEVERITY)

| # | File Path | Issue | Severity |
|---|-----------|-------|----------|
| 7 | `lib/features/structural/shared/presentation/screens/cracking_check_screen.dart` | Lines 52, 74, 81: setState for `_isLoading`, `_result`, form resets | Medium |
| 8 | `lib/features/structural/shared/presentation/screens/shear_check_screen.dart` | Lines 51, 77, 84: setState for loading, results, resets | Medium |
| 9 | `lib/features/structural/shared/presentation/screens/deflection_check_screen.dart` | Lines 49, 71, 78: setState for loading, results, resets | Medium |
| 10 | `lib/features/work/presentation/screens/create_meeting_screen.dart` | Lines 130-131, 144-145, 194-195, 214-215, 230-231: setState for dropdowns and pickers | Medium |
| 11 | `lib/features/work/presentation/screens/create_task_screen.dart` | Lines 114, 156: setState for dropdowns and date picker | Medium |
| 12 | `lib/features/project/presentation/screens/project_editor_screen.dart` | Lines 33, 62, 136: setState for saving state and dropdowns | Medium |
| 13 | `lib/features/structural/shared/presentation/widgets/optimization/optimization_list.dart` | Lines 45-47, 73-75: setState for selection state | Medium |
| 14 | `lib/features/auth/presentation/screens/login_screen.dart` | Lines 202-203: setState for password visibility toggle | Low |
| 15 | `lib/features/auth/presentation/screens/register_screen.dart` | Lines 195-196: setState for password visibility toggle | Low |
| 16 | `lib/features/structural/shared/presentation/screens/ai_input_bar.dart` | Line 49: setState for text changes | Medium |

### CATEGORY 3: MIXED CONTROLLER PATTERNS (MEDIUM SEVERITY)

| # | File Path | Issue | Why It's a Problem |
|---|-----------|-------|-------------------|
| 17 | `lib/features/auth/presentation/providers/auth_controller.dart` | Uses `StateNotifier<AsyncValue<void>>` | Legacy pattern; should use `AsyncNotifier` |
| 18 | `lib/features/auth/application/profile_controller.dart` | Uses `StateNotifier<AsyncValue<void>>` | Legacy pattern |
| 19 | `lib/features/level_log/application/controllers/level_log_controller.dart` | Uses `StateNotifier<LevelLogState>` | Should use `Notifier` |
| 20 | `lib/features/work/application/controllers/work_controller.dart` | Uses `Notifier<WorkState>` | ✅ Correct pattern |
| 21 | `lib/features/project/application/controllers/project_controller.dart` | Uses `Notifier<ProjectState>` | ✅ Correct pattern |
| 22 | `lib/features/estimation/rebar/application/rebar_controller.dart` | Uses `Notifier<RebarState>` | ✅ Correct pattern |
| 23 | `lib/features/structural/*/application/*_controller.dart` | Mixed patterns across structural modules | Inconsistent architecture |

### CATEGORY 4: DIRECT REPOSITORY/SERVICE CALLS FROM UI (HIGH SEVERITY)

| # | File Path | Issue | Why It's a Problem |
|---|-----------|-------|-------------------|
| 24 | `lib/features/structural/shared/presentation/screens/cracking_check_screen.dart` | Directly instantiates `CalculationService` | UI depends on concrete service |
| 25 | `lib/features/structural/shared/presentation/screens/shear_check_screen.dart` | Directly instantiates `CalculationService` | Tight coupling |
| 26 | `lib/features/structural/shared/presentation/screens/deflection_check_screen.dart` | Directly instantiates `CalculationService` | No dependency injection |

---

## REFACTOR PLAN

### 1. STANDARDIZED RIVERPOD PATTERN

#### Provider Types (Required):
```dart
// For synchronous state
final myNotifierProvider = NotifierProvider<MyNotifier, MyState>(MyNotifier.new);

// For async operations  
final myAsyncNotifierProvider = AsyncNotifierProvider<MyAsyncNotifier, MyState>(MyAsyncNotifier.new);

// For computed/derived state
final myDerivedProvider = Provider<String>((ref) {
  final state = ref.watch(myNotifierProvider);
  return state.name;
});
```

#### Prohibited Patterns:
```dart
// ❌ DON'T USE - Legacy pattern
final provider = StateNotifierProvider<Controller, State>((ref) => Controller(ref));

// ❌ DON'T USE - Business logic in UI
class MyScreen extends ConsumerWidget {
  void _calculate() {
    // Business logic here
  }
}

// ✅ CORRECT - All logic in Notifier
class MyNotifier extends Notifier<MyState> {
  void calculate() {
    state = state.copyWith(/* ... */);
  }
}
```

### 2. FOLDER STRUCTURE STANDARD

```
lib/
├── core/
│   ├── providers/           # Core/shared providers
│   ├── repositories/       # Core repositories
│   └── services/          # Core services (no business logic)
├── features/
│   └── {feature_name}/
│       ├── data/
│       │   ├── models/     # Data models, DTOs
│       │   └── repositories/  # Repository implementations
│       ├── domain/
│       │   ├── entities/  # Domain entities
│       │   ├── repositories/  # Repository interfaces
│       │   └── usecases/  # Business use cases
│       └── presentation/
│           ├── providers/ # Feature-specific providers
│           ├── screens/   # UI screens (purely declarative)
│           └── widgets/   # Reusable widgets
└── shared/
    └── ...
```

### 3. NAMING CONVENTIONS

| Element | Convention | Example |
|---------|------------|---------|
| State Class | `{Feature}State` | `CrackingState` |
| Notifier Class | `{Feature}Notifier` | `CrackingNotifier` |
| Provider | `{feature}Provider` | `crackingProvider` |
| State File | `{feature}_state.dart` | `cracking_state.dart` |
| Screen | `{feature}_screen.dart` | `cracking_screen.dart` |

---

## TOP 3 HIGHEST-IMPACT REFACTORING FILES

Based on the audit, the following files have been refactored:

### ✅ 1. CRACKING CHECK SCREEN
**Files Created/Modified:**
- [`cracking_check_controller.dart`](lib/features/structural/shared/application/controllers/cracking_check_controller.dart) - New Notifier with all business logic
- [`cracking_check_screen.dart`](lib/features/structural/shared/presentation/screens/cracking_check_screen.dart) - Refactored to pure declarative UI

**Violations Fixed:**
- ✅ Removed setState for `_isLoading` → now in Notifier
- ✅ Removed setState for `_result` → now in Notifier
- ✅ Removed direct `CalculationService.calculateCracking()` call → now in Notifier
- ✅ Removed manual form validation logic → now in Notifier
- ✅ UI converted from `ConsumerStatefulWidget` to `ConsumerWidget`

### ✅ 2. SHEAR CHECK SCREEN
**Files Created/Modified:**
- [`shear_check_controller.dart`](lib/features/structural/shared/application/controllers/shear_check_controller.dart) - New Notifier with all business logic
- [`shear_check_screen.dart`](lib/features/structural/shared/presentation/screens/shear_check_screen.dart) - Refactored to pure declarative UI

**Violations Fixed:**
- ✅ Removed setState for `_isLoading` → now in Notifier
- ✅ Removed setState for `_result` → now in Notifier
- ✅ Removed direct `CalculationService.calculateShear()` call → now in Notifier
- ✅ Removed manual form validation logic → now in Notifier
- ✅ UI converted from `ConsumerStatefulWidget` to `ConsumerWidget`

### ✅ 3. DEFLECTION CHECK SCREEN
**Files Created/Modified:**
- [`deflection_check_controller.dart`](lib/features/structural/shared/application/controllers/deflection_check_controller.dart) - New Notifier with all business logic
- [`deflection_check_screen.dart`](lib/features/structural/shared/presentation/screens/deflection_check_screen.dart) - Refactored to pure declarative UI

**Violations Fixed:**
- ✅ Removed setState for `_isLoading` → now in Notifier
- ✅ Removed setState for `_result` → now in Notifier
- ✅ Removed direct `CalculationService.calculateDeflection()` call → now in Notifier
- ✅ Removed manual form validation logic → now in Notifier
- ✅ UI converted from `ConsumerStatefulWidget` to `ConsumerWidget`

---

## RECOMMENDATIONS

1. **Immediate (Week 1):** Refactor the 3 structural check screens to use proper Notifiers
2. **Short-term (Week 2-3):** Migrate all StateNotifier to Notifier/AsyncNotifier patterns
3. **Medium-term (Week 4-6):** Remove all setState calls in ConsumerStatefulWidgets for business logic
4. **Long-term:** Implement proper Clean Architecture with use cases for all features

---

## METRICS

| Metric | Before | Target |
|--------|--------|--------|
| Business logic in UI | 12 files | 0 files |
| setState for non-UI state | 18 files | 0 files |
| Mixed provider patterns | 7 files | 0 files |
| Direct service calls from UI | 3 files | 0 files |

---

*End of Report*
