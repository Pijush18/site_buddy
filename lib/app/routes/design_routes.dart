import 'package:go_router/go_router.dart';
import 'package:site_buddy/features/design/presentation/screens/design_home_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/design_report_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/slab_design_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/beam_design/beam_input_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/beam_design/load_definition_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/beam_design/analysis_summary_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/beam_design/reinforcement_design_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/beam_design/beam_safety_check_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/column_design/column_input_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/column_design/column_history_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/column_design/load_support_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/column_design/slenderness_check_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/column_design/design_calculation_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/column_design/reinforcement_detailing_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/column_design/safety_check_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/footing_design/footing_type_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/footing_design/footing_soil_load_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/footing_design/footing_geometry_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/footing_design/footing_analysis_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/footing_design/footing_reinforcement_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/footing_design/footing_safety_check_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/safety_check/shear_check_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/safety_check/deflection_check_screen.dart';
import 'package:site_buddy/features/design/presentation/screens/safety_check/cracking_check_screen.dart';
import 'package:site_buddy/shared/domain/models/report_data.dart';

final designRoutes = [
  GoRoute(
    path: '/design',
    builder: (context, state) => const DesignHomeScreen(),
    routes: [
      // Slab Design
      GoRoute(
        path: 'slab',
        builder: (context, state) => const SlabDesignScreen(),
      ),
      // Beam Design flow
      GoRoute(
        path: 'beam/input',
        builder: (context, state) => const BeamInputScreen(),
      ),
      // ... [rest of beam routes]
      GoRoute(
        path: 'beam/load',
        builder: (context, state) => const LoadDefinitionScreen(),
      ),
      GoRoute(
        path: 'beam/analysis',
        builder: (context, state) => const AnalysisSummaryScreen(),
      ),
      GoRoute(
        path: 'beam/rebar',
        builder: (context, state) => const ReinforcementDesignScreen(),
      ),
      GoRoute(
        path: 'beam/safety',
        builder: (context, state) => const BeamSafetyCheckScreen(),
      ),
      // Column Design flow
      GoRoute(
        path: 'column/input',
        builder: (context, state) => const ColumnInputScreen(),
        routes: [
          GoRoute(
            path: 'history',
            builder: (context, state) => const ColumnHistoryScreen(),
          ),
        ],
      ),
      GoRoute(
        path: 'column/load',
        builder: (context, state) => const LoadSupportScreen(),
      ),
      GoRoute(
        path: 'column/slenderness',
        builder: (context, state) => const SlendernessCheckScreen(),
      ),
      GoRoute(
        path: 'column/design',
        builder: (context, state) => const DesignCalculationScreen(),
      ),
      GoRoute(
        path: 'column/detailing',
        builder: (context, state) => const ReinforcementDetailingScreen(),
      ),
      GoRoute(
        path: 'column/safety',
        builder: (context, state) => const SafetyCheckScreen(),
      ),
      // Footing Design flow
      GoRoute(
        path: 'footing/type',
        builder: (context, state) => const FootingTypeScreen(),
      ),
      GoRoute(
        path: 'footing/soil-load',
        builder: (context, state) => const FootingSoilLoadScreen(),
      ),
      GoRoute(
        path: 'footing/geometry',
        builder: (context, state) => const FootingGeometryScreen(),
      ),
      GoRoute(
        path: 'footing/analysis',
        builder: (context, state) => const FootingAnalysisScreen(),
      ),
      GoRoute(
        path: 'footing/reinforcement',
        builder: (context, state) => const FootingReinforcementScreen(),
      ),
      GoRoute(
        path: 'footing/safety',
        builder: (context, state) => const FootingSafetyCheckScreen(),
      ),
      // Common Design Routes
      GoRoute(
        path: 'report',
        builder: (context, state) {
          final report = state.extra as ReportData?;
          return DesignReportScreen(data: report);
        },
      ),
      GoRoute(
        path: 'shear-check',
        builder: (context, state) => const ShearCheckScreen(),
      ),
      GoRoute(
        path: 'deflection-check',
        builder: (context, state) => const DeflectionCheckScreen(),
      ),
      GoRoute(
        path: 'cracking-check',
        builder: (context, state) => const CrackingCheckScreen(),
      ),
    ],
  ),
];

final designRedirects = [
  GoRoute(path: '/slab/design', redirect: (context, state) => '/design/slab'),
  GoRoute(
    path: '/beam/input',
    redirect: (context, state) => '/design/beam/input',
  ),
  GoRoute(
    path: '/beam/load',
    redirect: (context, state) => '/design/beam/load',
  ),
  GoRoute(
    path: '/beam/analysis',
    redirect: (context, state) => '/design/beam/analysis',
  ),
  GoRoute(
    path: '/beam/rebar',
    redirect: (context, state) => '/design/beam/rebar',
  ),
  GoRoute(
    path: '/beam/safety',
    redirect: (context, state) => '/design/beam/safety',
  ),
  GoRoute(
    path: '/column/input',
    redirect: (context, state) => '/design/column/input',
  ),
  GoRoute(
    path: '/column/load',
    redirect: (context, state) => '/design/column/load',
  ),
  GoRoute(
    path: '/column/slenderness',
    redirect: (context, state) => '/design/column/slenderness',
  ),
  GoRoute(
    path: '/column/design',
    redirect: (context, state) => '/design/column/design',
  ),
  GoRoute(
    path: '/column/detailing',
    redirect: (context, state) => '/design/column/detailing',
  ),
  GoRoute(
    path: '/column/safety',
    redirect: (context, state) => '/design/column/safety',
  ),
  GoRoute(
    path: '/footing/type',
    redirect: (context, state) => '/design/footing/type',
  ),
  GoRoute(
    path: '/footing/soil-load',
    redirect: (context, state) => '/design/footing/soil-load',
  ),
  GoRoute(
    path: '/footing/geometry',
    redirect: (context, state) => '/design/footing/geometry',
  ),
  GoRoute(
    path: '/footing/analysis',
    redirect: (context, state) => '/design/footing/analysis',
  ),
  GoRoute(
    path: '/footing/reinforcement',
    redirect: (context, state) => '/design/footing/reinforcement',
  ),
  GoRoute(
    path: '/footing/safety',
    redirect: (context, state) => '/design/footing/safety',
  ),
  GoRoute(
    path: '/footing/design',
    redirect: (context, state) => '/design/footing/type',
  ),
];
