# SiteBuddy Clean Architecture Audit Report

## Executive Summary
**Overall Architecture Health Score: 68/100**

The SiteBuddy project shows a "Mixed Architecture" state. While the foundation for Clean Architecture exists (existence of domain/data layers in core modules), there are widespread violations of dependency isolation and layer boundaries, especially in newer or auxiliary features.

---

## 1. Feature Compliance Status

### ✅ Fully Compliant (CA Followed)
*   **Design Module**: Has clear `domain/usecases`, `data/repositories`, and `application/controllers`. (Small leakage found in UI imports).
*   **Currency**: Follows standard Domain/Data/Application structure.
*   **AI**: Well-structured with usecases.

### ⚠️ Partially Compliant (Mixed/Hybrid)
*   **History**: Has Domain/Data layers but UI components like `CalculationHistoryScreen` directly import `HiveHistoryRepository`.
*   **Project**: Heavy direct dependency on `HiveProjectRepository` in controllers and UI.
*   **Reports**: Missing Data layer, logic sits in `application/`.

### ❌ Non-Compliant (Flat/Legacy)
*   **Levelling Log**: No Domain layer. Direct `services` and `models` folders under feature root.
*   **Level Log**: Hybrid structure with `services` and `models` alongside a presentation layer.
*   **Home**: Purely presentation-focused but contains inline navigation logic.

---

## 2. Critical Violations Found

### V1: Dependency Flow Inversion (Presentation → Data)
Several screens bypass the Domain layer and import implementation details from Data.
*   `lib/features/history/presentation/screens/calculation_history_screen.dart` (Imports `hive_history_repository.dart`)
*   `lib/features/project/presentation/screens/project_detail_screen.dart` (Imports `hive_structural_repository.dart`)

### V2: Direct Repository Access in Controllers
Instead of following `UI -> Controller -> UseCase -> Repository`, many controllers invoke repositories directly.
*   `FootingDesignController`: Reads `structuralRepositoryProvider` and `sharedHistoryRepositoryProvider` directly.
*   `LevelLogController`: Direct access to `levelLogRepositoryProvider`.

### V3: Models in Presentation Layer
In features like `levelling_log`, models and services are co-located with presentation widgets, making domain logic hard to reuse.

---

## 3. Metrics
*   **Total Features Analyzed**: 13
*   **Total Screens Sampled**: 59
*   **Features with UseCases**: 5 (38%)
*   **Features with Domain Layer**: 10 (77%)

---

## 4. Refactoring Roadmap (Priority Order)

### Phase 1: Dependency Decoupling (High Priority)
1.  **Isolate Data Imports**: Move all `hive_repository` imports out of `.dart` screen files and use abstraction (Interfaces in Domain).
2.  **Abstract Shared History**: Create a `HistoryRepository` interface in `shared/domain` and ensure all features use the interface, not `HiveHistoryRepository`.

### Phase 2: Domain Layer Remediation
1.  **Levelling Log**: Refactor `services/` into `domain/usecases` and `data/datasources`.
2.  **Project Feature**: Implement formal UseCases for `SaveProject`, `DeleteProject`, etc., to decouple the controller.

### Phase 3: Standardization
1.  **Directory Consolidation**: Move `levelling_log/widgets` and `levelling_log/screens` into a unified `presentation/` folder.
2.  **Core Data Cleanup**: Move IS 456 code references from `core/data` to `core/domain` if they contain business logic (calculation formulas).

---

## 5. Top Files Requiring Refactoring
1.  `lib/features/project/presentation/screens/project_detail_screen.dart`
2.  `lib/features/history/presentation/screens/calculation_history_screen.dart`
3.  `lib/features/design/application/controllers/beam_design_controller.dart`
4.  `lib/features/level_log/application/controllers/level_log_controller.dart`
