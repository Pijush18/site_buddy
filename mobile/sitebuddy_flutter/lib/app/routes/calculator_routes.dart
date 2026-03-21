import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_transitions.dart';
import 'package:site_buddy/features/calculator/presentation/screens/calculator_hub_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/material_calculator_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/level_calculator_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/gradient_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/rebar_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/cement_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/sand_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/brick_wall_estimator_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/plaster_material_estimator_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/excavation_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/shuttering_screen.dart';

final calculatorRoutes = [
  GoRoute(
    path: '/calculator',
    pageBuilder: (context, state) => AppTransitions.fadeSlide(
      state: state,
      child: const CalculatorHubScreen(),
    ),
    routes: [
      GoRoute(
        path: 'material',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const MaterialCalculatorScreen(),
        ),
      ),
      GoRoute(
        path: 'level',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const LevelCalculatorScreen(),
        ),
      ),
      GoRoute(
        path: 'gradient',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const GradientScreen(),
        ),
      ),
      GoRoute(
        path: 'cement',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const CementScreen(),
        ),
      ),
      GoRoute(
        path: 'sand',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const SandScreen(),
        ),
      ),
      GoRoute(
        path: 'rebar',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const RebarScreen(),
        ),
      ),
      GoRoute(
        path: 'brick-wall',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const BrickWallEstimatorScreen(),
        ),
      ),
      GoRoute(
        path: 'plaster',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const PlasterMaterialEstimatorScreen(),
        ),
      ),
      GoRoute(
        path: 'excavation',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const ExcavationScreen(),
        ),
      ),
      GoRoute(
        path: 'shuttering',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const ShutteringScreen(),
        ),
      ),
    ],
  ),
];



