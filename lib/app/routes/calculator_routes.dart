import 'package:go_router/go_router.dart';
import 'package:site_buddy/features/calculator/presentation/screens/calculator_hub_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/material_calculator_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/level_calculator_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/gradient_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/rebar_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/cement_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/sand_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/brick_wall_estimator_screen.dart';
import 'package:site_buddy/features/calculator/presentation/screens/plaster_material_estimator_screen.dart';

final calculatorRoutes = [
  GoRoute(
    path: '/calculator',
    builder: (context, state) => const CalculatorHubScreen(),
    routes: [
      GoRoute(
        path: 'material',
        builder: (context, state) => const MaterialCalculatorScreen(),
      ),
      GoRoute(
        path: 'level',
        builder: (context, state) => const LevelCalculatorScreen(),
      ),
      GoRoute(
        path: 'gradient',
        builder: (context, state) => const GradientScreen(),
      ),
      GoRoute(
        path: 'cement',
        builder: (context, state) => const CementScreen(),
      ),
      GoRoute(path: 'sand', builder: (context, state) => const SandScreen()),
      GoRoute(path: 'rebar', builder: (context, state) => const RebarScreen()),
      GoRoute(
        path: 'brick-wall',
        builder: (context, state) => const BrickWallEstimatorScreen(),
      ),
      GoRoute(
        path: 'plaster',
        builder: (context, state) => const PlasterMaterialEstimatorScreen(),
      ),
    ],
  ),
];
