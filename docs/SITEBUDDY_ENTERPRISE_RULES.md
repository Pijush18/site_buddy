# SiteBuddy Enterprise Architecture Governance

## Core Operational Principles

### 1. Zero-Guessing Policy
Never invent design values.
**Allowed sources:**
- `AppLayout`
- `SbSurface / AppColors`
- `AppTypography / SbTextStyles`
- `Theme.of(context).colorScheme`

If a value does not exist → **STOP** and request clarification.

### 2. Artifact-First Workflow
If a change modifies:
- more than 2 files
- **OR** more than 120 lines

Generate an **Implementation Plan** first and wait for approval.

### 3. Two-File Boundary Rule
AI agents may edit maximum **two files** per iteration.

### 4. Full File Context
Agents must read the entire file before editing.

### 5. Absolute Import Rule
All imports must use:
`package:site_buddy/...`
Relative imports are forbidden.

### 6. Exclusion Zone
Never automatically refactor:
- `lib/features/design/painters/`
- `lib/core/utils/pdf_generator.dart`

**Also exclude:**
- Diagram renderers
- Canvas drawing utilities

## UI Design System Rules

### 1. Spacing Rules
**Sibling spacing:**
- `AppLayout.vGap*`
- `AppLayout.hGap*`

**Container internal padding:**
- `AppLayout.padding*`

**Forbidden patterns:**
- `SizedBox(height: number)`
- `EdgeInsets.all(number)`

### 2. Surface Rules
**Use:**
- `SbSurface.card(context)`
- `SbSurface.section(context)`
- `SbSurface.highlight(context)`

**Allowed:**
- `Theme.of(context).colorScheme`

**Forbidden:**
- `Colors.grey`
- `Colors.white`
- `Color(0xFF...)`

### 3. Typography Rules
**Use:**
- `AppTypography`
- `SbTextStyles`

**Forbidden:**
- `TextStyle(fontSize: ...)`

### 4. Icon Rules
**Use:**
- `SbIcons`

**Allowed exceptions:**
- `Icons.close`
- `Icons.menu`
- `Icons.search`
- `Icons.arrow_back`

### 5. UI Composition Rules
**Preferred primitives:**
- `SbPage`
- `SbCard`
- `SbButton`
- `SbListItem`
- `SbInput`
- `SbEmptyState`

**Avoid:**
- `Scaffold`
- `ElevatedButton`
- `ListTile`
inside feature modules.

### 6. Screen Structure Rule
All feature screens must use:
- `SbPage`

## Clean Architecture Rules

### 1. Clean Architecture Enforcement
- **Widgets contain UI only.**
- **State logic must exist in:**
  - Riverpod Notifiers
  - UseCase classes
- **Widgets must not directly access:**
  - Hive
  - SharedPreferences
  - Repositories
  - Network APIs
- **Widgets interact only with Providers.**

### 2. Code Generation Protocol
When modifying files using generators (`.freezed`, `.g.dart`, `.riverpod`, `.hive`), run:
`dart run build_runner build --delete-conflicting-outputs`

## Feature Isolation Boundaries
Feature modules must remain independent.

**Forbidden imports:**
- `feature → feature`
- *Example forbidden:* `features/project` importing `features/calculator`

**Allowed shared modules:**
- `shared/domain`
- `shared/models`
- `shared/services`
- `shared/utils`

**Dependency flow:**
`feature` → `shared` → `data layer`

## Stability Verification

### 1. Stability Verification
After changes run:
1. `flutter analyze`
   - **Result must be:** 0 errors
2. `flutter test`
   - **Result must be:** 100% pass rate

### 2. Self-Correction Protocol
If a build fails:
1. Analyze the error log.
2. Attempt **ONE** automatic fix.
3. Re-run build.

If the second attempt fails:
- **STOP**
- Report the error
- Report attempted fixes
- Wait for human input

## Submission Checklist
Every PR must confirm:
- [ ] **Tokens:** `AppLayout` tokens used
- [ ] **Layout:** No redundant `SafeArea` under `SbPage`
- [ ] **Icons:** Using `SbIcons`
- [ ] **Architecture:** Widgets depend only on Providers
- [ ] **Generators:** `build_runner` executed if needed
- [ ] **Quality:** `flutter analyze` clean
- [ ] **Tests:** `flutter test` passed
- [ ] **Imports:** `package:site_buddy` imports

---

## Final Architecture Target
The SiteBuddy architecture must enforce:
- **Pages:** `SbPage`
- **Cards:** `SbCard`
- **Buttons:** `SbButton`
- **Lists:** `SbListItem`
- **Spacing:** `AppLayout`
- **Typography:** `SbTextStyles`
- **Colors:** `SbSurface`
- **Icons:** `SbIcons`
- **Motion:** `AppMotion`
- **State:** `Riverpod`

**Architecture Classification:** 10/10 Enterprise Flutter Architecture
