# SiteBuddy Architecture Map
Generated on: 2026-03-15T17:14:39.507854

## Feature Modules

### LEVELLING_LOG
- **LevellingLogScreen**
  - Components: `AppLocalizations`, `SbPage`, `SbCard`, `SbInput`, `AppLayout`, `SbTextStyles`

### CURRENCY
- **CurrencyConverterScreen**
  - Components: `SbCard`, `SbTextStyles`, `AppLayout`, `SbPage`, `AppNumberField`, `SbIcons`, `SbDropdown`, `SbButton`

### HISTORY
- **HistoryDetailScreen**
  - Components: `SbPage`, `AppLayout`, `SbTextStyles`, `SbButton`, `SbCard`, `SbListItem`, `SbFeedback`
- **CalculationHistoryScreen**
  - Components: `SbPage`, `SbTextStyles`, `SbEmptyState`, `SbIcons`, `AppLayout`, `SbCard`
  - Navigates to: `/history-detail`

### SPLASH
- **SplashScreen**
  - Components: `SbPage`, `SbIcons`, `AppLayout`
  - Navigates to: `/`

### REPORTS
- **ReportsScreen**
  - Components: `SbPage`, `SbCard`, `AppLayout`, `SbIcons`, `SbTextStyles`, `SbButton`
  - Navigates to: `/calculator`, `/design`
- **SiteReportPreviewScreen**
  - Components: `SbPage`, `SbIcons`, `SbFeedback`

### AI
- **AiSharePreviewScreen**
  - Components: `SbPage`, `SbIcons`
- **AiChatScreen**
  - Components: `SbPage`, `AppLayout`
- **AiAssistantScreen**
  - Components: `SbPage`, `SbButton`, `SbIcons`, `AppLayout`
  - Navigates to: `/report/preview`, `/settings/branding`
- **AiHistoryScreen**
  - Components: `SbPage`, `SbTextStyles`, `SbEmptyState`, `SbIcons`, `AppLayout`, `SbFeedback`

### UNIT_CONVERTER
- **UnitConverterScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `SbDropdown`, `AppNumberField`, `SbButton`, `SbIcons`, `SbCard`, `SbInput`, `SbListItem`

### SETTINGS
- **PrivacyPolicyScreen**
  - Components: `SbPage`, `AppLayout`, `SbTextStyles`
- **SettingsScreen**
  - Components: `AppLocalizations`, `SbPage`, `AppLayout`, `SbCard`, `SbSettingsTile`, `SbIcons`, `SbTextStyles`
  - Navigates to: `/subscription`, `/login`
- **BrandingSettingsScreen**
  - Components: `SbFeedback`, `SbPage`, `AppLayout`, `SbTextStyles`, `SbInput`, `SbButton`
- **TermsConditionsScreen**
  - Components: `SbPage`, `AppLayout`, `SbTextStyles`

### SUBSCRIPTION
- **SubscriptionScreen**
  - Components: `SbPage`, `AppLayout`, `SbTextStyles`, `SbCard`, `SbIcons`, `SbButton`

### DESIGN
- **DesignReportScreen**
  - Components: `SbFeedback`, `SbPage`, `AppLayout`, `SbButton`, `SbIcons`, `SbTextStyles`, `SbCard`, `SbListItem`
- **DesignHomeScreen**
  - Components: `SbPage`, `AppLayout`, `SbSection`, `SbModuleHero`, `SbIcons`
- **LoadDefinitionScreen**
  - Components: `SbFeedback`, `SbPage`, `SbTextStyles`, `AppLayout`, `SbCard`, `AppNumberField`, `SbSwitch`, `SbButton`, `SbIcons`
  - Navigates to: `/beam/analysis`
- **BeamSafetyCheckScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `DesignResultCard`, `AppCard`, `SbButton`, `SbIcons`, `SbFeedback`, `SbInput`
  - Navigates to: `/`
- **AnalysisSummaryScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `DesignResultCard`, `SbButton`
  - Navigates to: `/beam/rebar`
- **ReinforcementDesignScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `SbCard`, `SbDropdown`, `DesignResultCard`, `SbButton`
  - Navigates to: `/beam/safety`
- **BeamInputScreen**
  - Components: `SbFeedback`, `SbPage`, `SbButton`, `SbIcons`, `SbTextStyles`, `AppLayout`, `SbCard`, `SbDropdown`, `AppNumberField`
  - Navigates to: `/beam/load`
- **ReinforcementDetailingScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `AppCard`, `SbDropdown`, `DesignResultCard`, `SbButton`
  - Navigates to: `/column/safety`
- **DesignCalculationScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `DesignResultCard`, `SbCard`, `SbDropdown`, `SbSwitch`, `AppNumberField`, `SbButton`
  - Navigates to: `/column/detailing`
- **LoadSupportScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `SbCard`, `AppNumberField`, `SbIcons`, `SbDropdown`, `SbButton`
  - Navigates to: `/column/slenderness`
- **ColumnHistoryScreen**
  - Components: `SbPage`, `SbEmptyState`, `SbIcons`, `AppLayout`, `SbCard`, `SbTextStyles`
  - Navigates to: `/history-detail`
- **SafetyCheckScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `AppCard`, `SbIcons`, `DesignResultCard`, `SbButton`, `SbFeedback`
  - Navigates to: `/`
- **SlendernessCheckScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `DesignResultCard`, `SbButton`
  - Navigates to: `/column/design`
- **ColumnInputScreen**
  - Components: `SbPage`, `SbButton`, `SbIcons`, `SbTextStyles`, `AppLayout`, `SbCard`, `SbDropdown`, `AppNumberField`
  - Navigates to: `/column/load`, `/design/column/input/history`
- **SlabSafetyScreen**
  - Components: `SbPage`, `SbButton`, `SbIcons`, `SbTextStyles`, `AppLayout`, `DesignResultCard`
- **SlabAnalysisScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `DesignResultCard`, `SbCard`, `SbIcons`, `SbButton`
  - Navigates to: `/slab/reinforcement`
- **SlabInputScreen**
  - Components: `SbPage`, `SbButton`, `SbIcons`, `SbTextStyles`, `AppLayout`, `SbCard`, `SbDropdown`, `AppNumberField`
  - Navigates to: `/slab/load`
- **SlabReinforcementScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `DesignResultCard`, `SbCard`, `SbIcons`, `SbButton`
  - Navigates to: `/slab/safety`
- **SlabLoadScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `SbCard`, `AppNumberField`, `SbButton`, `SbIcons`
  - Navigates to: `/slab/analysis`
- **ShearCheckScreen**
  - Components: `AppLayout`, `SbPage`, `SbTextStyles`, `SbIcons`
- **DeflectionCheckScreen**
  - Components: `AppLayout`, `SbPage`, `SbTextStyles`
- **CrackingCheckScreen**
  - Components: `AppAnimation`, `SbPage`, `SbTextStyles`, `AppLayout`, `SbIcons`
- **FootingSafetyCheckScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `SbCard`, `SbIcons`, `DesignResultCard`, `SbButton`
  - Navigates to: `/design`
- **FootingTypeScreen**
  - Components: `SbPage`, `SbButton`, `SbIcons`, `AppLayout`, `SbTextStyles`
  - Navigates to: `/footing/soil-load`
- **FootingAnalysisScreen**
  - Components: `SbPage`, `SbButton`, `SbIcons`, `AppLayout`, `SbTextStyles`, `DesignResultCard`, `SbCard`, `SbListItem`
  - Navigates to: `/footing/reinforcement`
- **FootingSoilLoadScreen**
  - Components: `SbPage`, `SbButton`, `SbIcons`, `AppLayout`, `SbTextStyles`, `SbCard`, `AppNumberField`
  - Navigates to: `/footing/geometry`
- **FootingGeometryScreen**
  - Components: `SbPage`, `SbButton`, `SbIcons`, `AppLayout`, `SbTextStyles`, `SbCard`, `AppNumberField`
  - Navigates to: `/footing/analysis`
- **FootingReinforcementScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `DesignResultCard`, `SbCard`, `SbDropdown`, `SbButton`
  - Navigates to: `/footing/safety`

### CALCULATOR
- **CalculatorHubScreen**
  - Components: `SbPage`, `SbSection`, `AppLayout`, `SbIcons`
  - Navigates to: `/calculator/material`, `/calculator/brick-wall`, `/calculator/rebar`, `/calculator/excavation`, `/calculator/shuttering`, `/level`, `/calculator/gradient`, `/converter`, `/currency`
- **GradientScreen**
  - Components: `SbCard`, `SbTextStyles`, `AppLayout`, `SbListItem`, `SbPage`, `SbIcons`, `AppNumberField`, `SbButton`
- **BrickWallEstimatorScreen**
  - Components: `SbPage`, `AppLayout`, `AppNumberField`, `SbIcons`, `SbCard`, `SbTextStyles`, `SbButton`, `SbFeedback`, `SbDropdown`, `SbListItem`
- **CementScreen**
  - Components: `SbCard`, `SbTextStyles`, `AppLayout`, `SbListItem`, `SbPage`, `AppNumberField`, `SbIcons`, `SbFeedback`, `SbButton`
- **SandScreen**
  - Components: `SbCard`, `SbTextStyles`, `AppLayout`, `SbListItem`, `SbPage`, `AppNumberField`, `SbIcons`, `SbButton`
- **MaterialCalculatorScreen**
  - Components: `SbPage`, `AppLayout`, `SbTextStyles`, `SbDropdown`, `AppNumberField`, `SbIcons`, `SbButton`, `SbCard`, `SbListItem`
- **RebarScreen**
  - Components: `SbCard`, `SbTextStyles`, `AppLayout`, `SbListItem`, `SbPage`, `AppNumberField`, `SbIcons`, `SbButton`
- **ShutteringScreen**
  - Components: `SbPage`, `AppLayout`, `AppNumberField`, `SbListItem`, `SbButton`, `SbIcons`, `SbTextStyles`, `SbCard`
- **ExcavationScreen**
  - Components: `SbPage`, `AppLayout`, `AppNumberField`, `SbFeedback`, `SbButton`, `SbIcons`, `SbTextStyles`, `SbCard`, `SbListItem`
- **PlasterMaterialEstimatorScreen**
  - Components: `AppLocalizations`, `SbPage`, `AppLayout`, `AppNumberField`, `SbIcons`, `SbTextStyles`, `SbDropdown`, `SbCard`, `SbButton`, `SbListItem`
- **LevelCalculatorScreen**
  - Components: `SbCard`, `SbTextStyles`, `AppLayout`, `SbListItem`, `SbPage`, `SbIcons`, `AppNumberField`, `SbButton`

### PROJECT
- **ProjectDetailScreen**
  - Components: `SbPage`, `AppLayout`, `SbIcons`, `SbCard`, `SbTextStyles`, `SbSection`, `SbListItem`, `SbButton`, `SbButtonVariant`
  - Navigates to: `/projects/$projectId/history`, `/projects/$projectId/level-log`, `/projects/$projectId/edit`
- **ProjectEditorScreen**
  - Components: `SbPage`, `SbButton`, `SbButtonVariant`, `SbIcons`, `SbSection`, `SbInput`, `AppLayout`, `SbDropdown`
- **ProjectListScreen**
  - Components: `SbPage`, `AppLayout`, `SbIcons`, `SbTextStyles`, `SbButton`, `SbEmptyState`
  - Navigates to: `/projects/create`, `/projects/detail`
- **ProjectShareScreen**
  - Components: `SbPage`, `AppLayout`, `SbIcons`, `SbCard`, `SbTextStyles`

### AUTH
- **LoginScreen**
  - Components: `SbFeedback`, `SbButton`, `AppLayout`, `SbIcons`, `SbCard`, `SbInput`
  - Navigates to: `/`, `/reset-password`, `/register`
- **ResetPasswordScreen**
  - Components: `SbFeedback`, `SbButton`, `AppLayout`, `SbIcons`, `SbCard`, `SbInput`
  - Navigates to: `/login`
- **RegisterScreen**
  - Components: `SbFeedback`, `SbButton`, `AppLayout`, `SbIcons`, `SbCard`, `SbInput`
  - Navigates to: `/login`

### LEVEL_LOG
- **LevelLogScreen**
  - Components: `AppLocalizations`, `SbPage`, `SbButton`, `SbIcons`, `AppLayout`, `SbCard`, `SbTextStyles`

### WORK
- **TaskDetailScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `SbCard`, `SbListItem`, `SbButton`, `SbIcons`
- **CreateMeetingScreen**
  - Components: `SbFeedback`, `SbPage`, `SbButton`, `SbIcons`, `SbInput`, `AppLayout`, `SbTextStyles`, `SbDropdown`
- **CreateTaskScreen**
  - Components: `SbPage`, `SbButton`, `SbIcons`, `SbFeedback`, `SbInput`, `AppLayout`, `SbTextStyles`, `SbDropdown`
- **MeetingDetailScreen**
  - Components: `SbPage`, `SbTextStyles`, `AppLayout`, `AppCard`, `SbListItem`, `SbInput`, `SbButton`, `SbIcons`
- **WorkDashboardScreen**
  - Components: `AppLayout`, `SbIcons`, `SbSurface`, `SbCard`, `SbTextStyles`, `SbPage`, `SbButton`, `SbFeedback`, `SbListItem`, `SbDropdown`, `SbEmptyState`
  - Navigates to: `/tasks/detail`, `/meetings/detail`, `/tasks/create`, `/meetings/create`

### HOME
- **HomeScreen**
  - Components: `AppLocalizations`, `SbPage`, `SbButton`, `SbIcons`, `AppLayout`, `SbSection`, `SbGridCard`, `SbTextStyles`
  - Navigates to: `/settings`, `/projects`, `/level`, `/calculator/gradient`, `/converter`, `/currency`, `/projects/create`, `/reports`

## Router Entry Points
- `/splash` → **SplashScreen**
- `/login` → **RegisterScreen**
- `/reset-password` → **ResetPasswordScreen**
- `/subscription` → **SubscriptionScreen**
- `/` → **LevellingLogScreen**
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
- `level` → **LevelCalculatorScreen**
- `gradient` → **GradientScreen**
- `cement` → **CementScreen**
- `sand` → **SandScreen**
- `rebar` → **RebarScreen**
- `brick-wall` → **BrickWallEstimatorScreen**
- `plaster` → **PlasterMaterialEstimatorScreen**
- `excavation` → **ExcavationScreen**
- `shuttering` → **ShutteringScreen**
- `/design` → **DesignHomeScreen**
- `slab/input` → **SlabInputScreen**
- `slab/load` → **SlabLoadScreen**
- `slab/analysis` → **SlabAnalysisScreen**
- `slab/reinforcement` → **SlabReinforcementScreen**
- `slab/safety` → **SlabSafetyScreen**
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
