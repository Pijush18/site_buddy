import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:site_buddy/core/widgets/sb_input.dart';

void main() {
  testWidgets('SbInput renders label and accepts input', (WidgetTester tester) async {
    String? value;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SbInput(
            label: 'Username',
            onChanged: (v) => value = v,
          ),
        ),
      ),
    );

    expect(find.text('Username'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'pijush');
    expect(value, 'pijush');
  });
}
