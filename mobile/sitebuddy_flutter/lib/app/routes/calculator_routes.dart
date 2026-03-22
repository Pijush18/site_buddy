import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_transitions.dart';
import 'package:site_buddy/features/estimation/presentation/estimation_hub_screen.dart';
import 'package:site_buddy/features/estimation/concrete/presentation/concrete_estimator_screen.dart';
import 'package:site_buddy/features/surveying/level/presentation/level_calculator_screen.dart';
import 'package:site_buddy/features/surveying/gradient/presentation/gradient_screen.dart';
import 'package:site_buddy/features/estimation/rebar/presentation/rebar_screen.dart';
import 'package:site_buddy/features/estimation/cement/presentation/cement_screen.dart';
import 'package:site_buddy/features/estimation/sand/presentation/sand_screen.dart';
import 'package:site_buddy/features/estimation/brick/presentation/brick_wall_estimator_screen.dart';
import 'package:site_buddy/features/estimation/plaster/presentation/plaster_material_estimator_screen.dart';
import 'package:site_buddy/features/estimation/excavation/presentation/excavation_screen.dart';
import 'package:site_buddy/features/estimation/shuttering/presentation/shuttering_screen.dart';
import 'package:site_buddy/features/history/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/features/history/presentation/screens/history_detail_screen.dart';

final calculatorRoutes = [
  GoRoute(
    path: '/calculator',
    pageBuilder: (context, state) => AppTransitions.fadeSlide(
      state: state,
      // Using uri.toString() is more sensitive to navigation events
      // than matchedLocation which is just a static pattern string.
      child: EstimationHubScreen(key: ValueKey(state.uri.toString())),
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
      GoRoute(
        path: 'history-detail',
        pageBuilder: (context, state) {
          final entry = state.extra as CalculationHistoryEntry;
          return AppTransitions.fadeSlide(
            state: state,
            child: HistoryDetailScreen(entry: entry),
          );
        },
      ),
    ],
  ),
];







