import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:site_buddy/core/widgets/sb_button.dart';

void main() {
  testWidgets('SbButton.primary renders label and triggers callback', (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SbButton.primary(
            label: 'Action',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Action'), findsOneWidget);
    await tester.tap(find.text('Action'));
    expect(pressed, isTrue);
  });

  testWidgets('SbButton shows loading spinner when isLoading is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SbButton.primary(
            label: 'Action',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Action'), findsNothing);
  });
}
