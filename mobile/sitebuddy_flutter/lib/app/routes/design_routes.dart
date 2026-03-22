import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_transitions.dart';
import 'package:site_buddy/features/home/presentation/screens/home_screen.dart';
import 'package:site_buddy/features/structural/shared/presentation/screens/design_report_screen.dart';
import 'package:site_buddy/features/structural/slab/presentation/screens/slab_input_screen.dart';
import 'package:site_buddy/features/structural/slab/presentation/screens/slab_load_screen.dart';
import 'package:site_buddy/features/structural/slab/presentation/screens/slab_analysis_screen.dart';
import 'package:site_buddy/features/structural/slab/presentation/screens/slab_reinforcement_screen.dart';
import 'package:site_buddy/features/structural/slab/presentation/screens/slab_safety_screen.dart';
import 'package:site_buddy/features/structural/beam/presentation/screens/beam_input_screen.dart';
import 'package:site_buddy/features/structural/beam/presentation/screens/load_definition_screen.dart';
import 'package:site_buddy/features/structural/beam/presentation/screens/analysis_summary_screen.dart';
import 'package:site_buddy/features/structural/beam/presentation/screens/reinforcement_design_screen.dart';
import 'package:site_buddy/features/structural/beam/presentation/screens/beam_safety_check_screen.dart';
import 'package:site_buddy/features/structural/column/presentation/screens/column_input_screen.dart';
import 'package:site_buddy/features/structural/column/presentation/screens/column_history_screen.dart';
import 'package:site_buddy/features/structural/column/presentation/screens/load_support_screen.dart';
import 'package:site_buddy/features/structural/column/presentation/screens/slenderness_check_screen.dart';
import 'package:site_buddy/features/structural/column/presentation/screens/design_calculation_screen.dart';
import 'package:site_buddy/features/structural/column/presentation/screens/reinforcement_detailing_screen.dart';
import 'package:site_buddy/features/structural/column/presentation/screens/safety_check_screen.dart';
import 'package:site_buddy/features/structural/footing/presentation/screens/footing_type_screen.dart';
import 'package:site_buddy/features/structural/footing/presentation/screens/footing_soil_load_screen.dart';
import 'package:site_buddy/features/structural/footing/presentation/screens/footing_geometry_screen.dart';
import 'package:site_buddy/features/structural/footing/presentation/screens/footing_analysis_screen.dart';
import 'package:site_buddy/features/structural/footing/presentation/screens/footing_reinforcement_screen.dart';
import 'package:site_buddy/features/structural/footing/presentation/screens/footing_safety_check_screen.dart';
import 'package:site_buddy/features/structural/shared/presentation/screens/shear_check_screen.dart';
import 'package:site_buddy/features/structural/shared/presentation/screens/deflection_check_screen.dart';
import 'package:site_buddy/features/structural/shared/presentation/screens/cracking_check_screen.dart';
import 'package:site_buddy/shared/domain/models/report_data.dart';

final designRoutes = [
  GoRoute(
    path: '/design',
    pageBuilder: (context, state) => AppTransitions.fadeSlide(
      state: state,
      child: const HomeScreen(),
    ),
    routes: [
      // Slab Design flow
      GoRoute(
        path: 'slab/input',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const SlabInputScreen(),
        ),
      ),
      GoRoute(
        path: 'slab/load',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const SlabLoadScreen(),
        ),
      ),
      GoRoute(
        path: 'slab/analysis',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const SlabAnalysisScreen(),
        ),
      ),
      GoRoute(
        path: 'slab/reinforcement',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const SlabReinforcementScreen(),
        ),
      ),
      GoRoute(
        path: 'slab/safety',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const SlabSafetyScreen(),
        ),
      ),
      // Beam Design flow
      GoRoute(
        path: 'beam/input',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const BeamInputScreen(),
        ),
      ),
      GoRoute(
        path: 'beam/load',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const LoadDefinitionScreen(),
        ),
      ),
      GoRoute(
        path: 'beam/analysis',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const AnalysisSummaryScreen(),
        ),
      ),
      GoRoute(
        path: 'beam/rebar',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const ReinforcementDesignScreen(),
        ),
      ),
      GoRoute(
        path: 'beam/safety',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const BeamSafetyCheckScreen(),
        ),
      ),
      // Column Design flow
      GoRoute(
        path: 'column/input',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const ColumnInputScreen(),
        ),
        routes: [
          GoRoute(
            path: 'history',
            pageBuilder: (context, state) => AppTransitions.fadeSlide(
              state: state,
              child: const ColumnHistoryScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: 'column/load',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const LoadSupportScreen(),
        ),
      ),
      GoRoute(
        path: 'column/slenderness',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const SlendernessCheckScreen(),
        ),
      ),
      GoRoute(
        path: 'column/design',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const DesignCalculationScreen(),
        ),
      ),
      GoRoute(
        path: 'column/detailing',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const ReinforcementDetailingScreen(),
        ),
      ),
      GoRoute(
        path: 'column/safety',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const SafetyCheckScreen(),
        ),
      ),
      // Footing Design flow
      GoRoute(
        path: 'footing/type',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const FootingTypeScreen(),
        ),
      ),
      GoRoute(
        path: 'footing/soil-load',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const FootingSoilLoadScreen(),
        ),
      ),
      GoRoute(
        path: 'footing/geometry',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const FootingGeometryScreen(),
        ),
      ),
      GoRoute(
        path: 'footing/analysis',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const FootingAnalysisScreen(),
        ),
      ),
      GoRoute(
        path: 'footing/reinforcement',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const FootingReinforcementScreen(),
        ),
      ),
      GoRoute(
        path: 'footing/safety',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const FootingSafetyCheckScreen(),
        ),
      ),
      // Common Design Routes
      GoRoute(
        path: 'report',
        pageBuilder: (context, state) {
          final report = state.extra as ReportData?;
          return AppTransitions.fadeSlide(
            state: state,
            child: DesignReportScreen(data: report),
          );
        },
      ),
      GoRoute(
        path: 'shear-check',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const ShearCheckScreen(),
        ),
      ),
      GoRoute(
        path: 'deflection-check',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const DeflectionCheckScreen(),
        ),
      ),
      GoRoute(
        path: 'cracking-check',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const CrackingCheckScreen(),
        ),
      ),
    ],
  ),
];

final designRedirects = [
  GoRoute(path: '/slab/design', redirect: (context, state) => '/design/slab/input'),
  GoRoute(path: '/slab/input', redirect: (context, state) => '/design/slab/input'),
  GoRoute(path: '/slab/load', redirect: (context, state) => '/design/slab/load'),
  GoRoute(path: '/slab/analysis', redirect: (context, state) => '/design/slab/analysis'),
  GoRoute(path: '/slab/reinforcement', redirect: (context, state) => '/design/slab/reinforcement'),
  GoRoute(path: '/slab/safety', redirect: (context, state) => '/design/slab/safety'),
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





