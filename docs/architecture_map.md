# SiteBuddy Architecture Map
Generated on: 2026-03-08T12:56:16.552801

## Feature Modules

### LEVELLING_LOG
- **LevellingLogScreen**
  - Components: `AppLocalizations`, `SbPage`, `SbCard`, `AppLayout`, `SbInput`

### CURRENCY
- **CurrencyConverterScreen**
  - Components: `SbCard`, `AppLayout`, `SbPage`, `AppNumberField`, `SbDropdown`, `SbButton`

### HISTORY
- **HistoryDetailScreen**
  - Components: `SbPage`, `AppLayout`, `SbButton`, `SbCard`, `SbListItem`, `SbFeedback`
- **CalculationHistoryScreen**
  - Components: `SbPage`, `SbEmptyState`, `AppLayout`, `SbCard`
  - Navigates to: `/history-detail`

### REPORTS
- **ReportsScreen**
  - Components: `SbPage`, `AppTextStyles`
- **SiteReportPreviewScreen**
  - Components: `SbPage`, `SbFeedback`

### AI
- **AiSharePreviewScreen**
  - Components: `SbPage`
- **AiChatScreen**
  - Components: `SbPage`, `AppSizes`
- **AiAssistantScreen**
  - Components: `SbPage`, `SbButton`, `AppLayout`
  - Navigates to: `/report/preview`, `/settings/branding`
- **AiHistoryScreen**
  - Components: `SbPage`, `AppLayout`, `SbFeedback`

### UNIT_CONVERTER
- **UnitConverterScreen**
  - Components: `SbPage`, `AppLayout`, `SbDropdown`, `AppNumberField`, `SbButton`, `SbCard`, `SbInput`, `SbListItem`

### SETTINGS
- **PrivacyPolicyScreen**
  - Components: `SbPage`, `AppLayout`
- **SettingsScreen**
  - Components: `AppLocalizations`, `SbPage`, `SbCard`, `AppLayout`
  - Navigates to: `/settings/terms`, `/settings/privacy`
- **BrandingSettingsScreen**
  - Components: `SbFeedback`, `SbPage`, `AppLayout`, `SbInput`, `SbButton`
- **TermsConditionsScreen**
  - Components: `SbPage`, `AppLayout`

### DESIGN
- **DesignReportScreen**
  - Components: `SbFeedback`, `SbPage`, `AppLayout`, `SbButton`, `AppCard`, `SbListItem`
- **DesignHomeScreen**
  - Components: `SbPage`, `AppLayout`, `SbSection`
- **LoadDefinitionScreen**
  - Components: `SbFeedback`, `SbPage`, `AppLayout`, `SbCard`, `AppNumberField`, `SbSwitch`, `SbButton`
  - Navigates to: `/beam/analysis`
- **BeamSafetyCheckScreen**
  - Components: `SbPage`, `AppLayout`, `DesignResultCard`, `AppCard`, `SbButton`, `SbFeedback`, `SbInput`
  - Navigates to: `/`
- **AnalysisSummaryScreen**
  - Components: `SbPage`, `AppLayout`, `DesignResultCard`, `SbButton`
  - Navigates to: `/beam/rebar`
- **ReinforcementDesignScreen**
  - Components: `SbPage`, `AppLayout`, `SbFeedback`, `SbCard`, `SbDropdown`, `DesignResultCard`, `SbButton`
  - Navigates to: `/beam/safety`
- **BeamInputScreen**
  - Components: `SbFeedback`, `SbPage`, `AppLayout`, `SbCard`, `SbDropdown`, `AppNumberField`, `SbButton`
  - Navigates to: `/beam/load`
- **ReinforcementDetailingScreen**
  - Components: `SbPage`, `AppLayout`, `AppCard`, `SbDropdown`, `DesignResultCard`, `SbButton`
  - Navigates to: `/column/safety`
- **DesignCalculationScreen**
  - Components: `SbPage`, `AppLayout`, `DesignResultCard`, `SbCard`, `SbDropdown`, `SbSwitch`, `AppNumberField`, `SbFeedback`, `SbButton`
  - Navigates to: `/column/detailing`
- **LoadSupportScreen**
  - Components: `SbPage`, `AppLayout`, `AppCard`, `AppNumberField`, `SbDropdown`, `SbButton`
  - Navigates to: `/column/slenderness`
- **ColumnHistoryScreen**
  - Components: `SbPage`, `SbEmptyState`, `AppLayout`, `SbCard`
  - Navigates to: `/history-detail`
- **SafetyCheckScreen**
  - Components: `SbPage`, `AppLayout`, `AppCard`, `DesignResultCard`, `SbButton`, `SbFeedback`
  - Navigates to: `/`
- **SlendernessCheckScreen**
  - Components: `SbPage`, `AppLayout`, `DesignResultCard`, `SbButton`
  - Navigates to: `/column/design`
- **ColumnInputScreen**
  - Components: `SbPage`, `SbButton`, `AppLayout`, `AppCard`, `SbDropdown`, `AppNumberField`
  - Navigates to: `/column/load`, `/design/column/input/history`
- **SlabDesignScreen**
  - Components: `AppLocalizations`, `SbPage`, `SbButton`, `AppLayout`, `SbCard`, `AppNumberField`, `DesignResultCard`, `SbFeedback`
- **ShearCheckScreen**
  - Components: `AppLayout`, `SbPage`
- **DeflectionCheckScreen**
  - Components: `AppLayout`, `SbPage`
- **CrackingCheckScreen**
  - Components: `AppAnimation`, `SbPage`, `AppLayout`
- **FootingSafetyCheckScreen**
  - Components: `SbPage`, `AppTextStyles`, `AppLayout`, `AppCard`, `DesignResultCard`, `SbButton`
  - Navigates to: `/design`
- **FootingTypeScreen**
  - Components: `SbPage`, `SbButton`, `AppLayout`
  - Navigates to: `/footing/soil-load`
- **FootingAnalysisScreen**
  - Components: `SbPage`, `SbButton`, `AppLayout`, `AppTextStyles`, `DesignResultCard`, `AppCard`, `SbListItem`
  - Navigates to: `/footing/reinforcement`
- **FootingSoilLoadScreen**
  - Components: `SbPage`, `SbButton`, `AppLayout`, `AppCard`, `AppNumberField`
  - Navigates to: `/footing/geometry`
- **FootingGeometryScreen**
  - Components: `SbPage`, `SbButton`, `AppLayout`, `SbCard`, `AppNumberField`
  - Navigates to: `/footing/analysis`
- **FootingReinforcementScreen**
  - Components: `SbPage`, `AppTextStyles`, `AppLayout`, `DesignResultCard`, `SbFeedback`, `AppCard`, `SbDropdown`, `SbButton`
  - Navigates to: `/footing/safety`

### CALCULATOR
- **CalculatorHubScreen**
  - Components: `SbPage`, `SbSection`, `AppLayout`
  - Navigates to: `/calculator/material`, `/calculator/brick-wall`, `/calculator/plaster`, `/calculator/rebar`, `/level`, `/calculator/gradient`, `/converter`, `/currency`
- **GradientScreen**
  - Components: `SbCard`, `AppLayout`, `SbPage`, `SbButton`, `AppNumberField`
- **BrickWallEstimatorScreen**
  - Components: `SbPage`, `SbButton`, `AppLayout`, `AppNumberField`, `SbCard`, `SbFeedback`, `SbDropdown`, `SbListItem`
- **CementScreen**
  - Components: `SbCard`, `SbListItem`, `AppLayout`, `SbPage`, `SbButton`, `AppNumberField`
- **SandScreen**
  - Components: `SbCard`, `AppLayout`, `SbListItem`, `SbPage`, `SbButton`, `AppNumberField`
- **MaterialCalculatorScreen**
  - Components: `SbPage`, `SbButton`, `AppLayout`, `SbDropdown`, `AppNumberField`, `SbCard`, `SbListItem`
- **RebarScreen**
  - Components: `SbCard`, `SbListItem`, `SbPage`, `SbButton`, `AppLayout`, `AppNumberField`
- **PlasterMaterialEstimatorScreen**
  - Components: `AppLocalizations`, `SbPage`, `SbButton`, `AppLayout`, `AppNumberField`, `SbDropdown`, `SbCard`, `SbListItem`
- **LevelCalculatorScreen**
  - Components: `SbCard`, `AppLayout`, `SbPage`, `SbButton`, `AppNumberField`

### PROJECT
- **ProjectDetailScreen**
  - Components: `SbPage`, `SbCard`, `AppLayout`, `SbSection`, `SbListItem`, `SbButton`, `SbButtonVariant`
  - Navigates to: `/projects/$projectId/history`, `/projects/$projectId/level-log`, `/projects/$projectId/edit`
- **ProjectEditorScreen**
  - Components: `SbPage`, `SbButton`, `SbButtonVariant`, `AppLayout`, `SbSection`, `SbInput`
- **ProjectListScreen**
  - Components: `SbPage`, `SbButton`, `SbEmptyState`, `AppLayout`
  - Navigates to: `/projects/create`
- **ProjectShareScreen**
  - Components: `SbPage`, `AppLayout`, `SbCard`

### LEVEL_LOG
- **LevelLogScreen**
  - Components: `AppLocalizations`, `SbPage`, `SbButton`, `AppLayout`, `SbCard`

### WORK
- **TaskDetailScreen**
  - Components: `SbPage`, `AppLayout`, `SbCard`, `SbListItem`, `SbButton`
- **CreateMeetingScreen**
  - Components: `SbFeedback`, `SbPage`, `SbButton`, `AppLayout`, `SbInput`, `SbDropdown`
- **CreateTaskScreen**
  - Components: `SbPage`, `SbButton`, `SbFeedback`, `AppLayout`, `SbInput`, `SbDropdown`
- **MeetingDetailScreen**
  - Components: `SbPage`, `AppLayout`, `AppCard`, `SbListItem`, `SbInput`, `SbButton`
- **WorkDashboardScreen**
  - Components: `AppLayout`, `SbCard`, `SbPage`, `SbButton`, `SbFeedback`, `SbListItem`, `SbDropdown`, `SbEmptyState`
  - Navigates to: `/tasks/detail`, `/meetings/detail`, `/tasks/create`, `/meetings/create`

### HOME
- **HomeScreen**
  - Components: `AppLocalizations`, `SbPage`, `SbButton`, `AppLayout`, `SbSection`, `SbGridCard`
  - Navigates to: `/settings`, `/projects`, `/level`, `/calculator/gradient`, `/converter`, `/projects/create`, `/reports`

## Router Entry Points
- `/` → **HomeScreen**
- `level` → **LevelCalculatorScreen**
- `reports` → **ReportsScreen**
- `settings/branding` → **BrandingSettingsScreen**
- `report/preview` → **SettingsScreen**
- `privacy` → **PrivacyPolicyScreen**
- `terms` → **TermsConditionsScreen**
- `/history-detail` → **UiLabScreen**
- `ai/interaction` → **AiChatScreen**
- `ai/chat` → **AiAssistantScreen**
- `ai/topic` → **AiHistoryScreen**
- `ai/share` → **AiSharePreviewScreen**
- `converter` → **UnitConverterScreen**
- `currency` → **CurrencyConverterScreen**
- `/projects` → **ProjectListScreen**
- `create` → **ProjectEditorScreen**
- `/projects/detail/:id` → **ProjectEditorScreen**
- `/tasks` → **WorkDashboardScreen**
- `/tasks/detail` → **CreateTaskScreen**
- `/meetings/detail` → **CreateMeetingScreen**
- `/calculator` → **CalculatorHubScreen**
- `material` → **MaterialCalculatorScreen**
- `gradient` → **GradientScreen**
- `cement` → **CementScreen**
- `sand` → **SandScreen**
- `rebar` → **RebarScreen**
- `brick-wall` → **BrickWallEstimatorScreen**
- `plaster` → **PlasterMaterialEstimatorScreen**
- `/design` → **DesignHomeScreen**
- `slab` → **SlabDesignScreen**
- `beam/input` → **BeamInputScreen**
- `beam/load` → **LoadDefinitionScreen**
- `beam/analysis` → **AnalysisSummaryScreen**
- `beam/rebar` → **ReinforcementDesignScreen**
- `beam/safety` → **BeamSafetyCheckScreen**
- `column/input` → **ColumnInputScreen**
- `history` → **ColumnHistoryScreen**
- `column/load` → **LoadSupportScreen**
- `column/slenderness` → **SlendernessCheckScreen**
- `column/design` → **DesignCalculationScreen**
- `column/detailing` → **ReinforcementDetailingScreen**
- `column/safety` → **SafetyCheckScreen**
- `footing/type` → **FootingTypeScreen**
- `footing/soil-load` → **FootingSoilLoadScreen**
- `footing/geometry` → **FootingGeometryScreen**
- `footing/analysis` → **FootingAnalysisScreen**
- `footing/reinforcement` → **FootingReinforcementScreen**
- `footing/safety` → **FootingSafetyCheckScreen**
- `report` → **ShearCheckScreen**
- `deflection-check` → **DeflectionCheckScreen**
- `cracking-check` → **CrackingCheckScreen**
