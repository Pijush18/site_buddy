import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/calculator/presentation/screens/calculator_hub_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('CalculatorHubScreen renders engineering tools', (WidgetTester tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const CalculatorHubScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    // Section Headers are Uppercased in SbSection
    expect(find.text('QUANTITY TOOLS'), findsOneWidget);
    expect(find.text('FIELD SURVEYING'), findsOneWidget);
    
    // Feature Cards maintain case
    expect(find.text('Concrete Material Estimator'), findsOneWidget);
    expect(find.text('Gradient Tool'), findsOneWidget);
  });
}
