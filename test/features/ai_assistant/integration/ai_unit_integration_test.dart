import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:site_buddy/core/providers/shared_prefs_provider.dart';
import 'package:site_buddy/features/ai/application/controllers/ai_assistant_controller.dart';
import 'package:site_buddy/shared/domain/models/ai_intent.dart';

void main() {
  group('AI-Unit System Integration Test', () {
    test(
      'AI Process should use Imperial units when setting is Imperial',
      () async {
        // 1. Setup Mock SharedPreferences with Imperial mode (unitSystem = 1)
        SharedPreferences.setMockInitialValues({
          'app_unit_system': 1, // Imperial
        });
        final prefs = await SharedPreferences.getInstance();

        // 2. Setup ProviderContainer with Overrides
        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );

        // 3. Access Controller and execute input
        final controller = container.read(aiControllerProvider.notifier);

        // "10x10x0.15 slab m20" -> 15m3
        // In Imperial: 15m3 * 1.30795 = ~19.62 yd3
        await controller.processInput(null, "10x10x0.15 slab m20");

        final state = container.read(aiControllerProvider);

        // 4. Validation
        expect(state.isLoading, false);
        expect(state.error, isNull);
        expect(state.response?.intent, AiIntent.calculation);

        // Verification of conversion: 15m3 should be ~19.62 yd3
        final volume = state.response?.calculation?.volume;
        expect(volume, closeTo(19.62, 0.1));

        // Assert that the response string contains imperial units
        expect(
          state.response.toString().toLowerCase(),
          anyOf(contains('yd³'), contains('yards')),
        );
      },
    );

    test('AI Process should use Metric units when setting is Metric', () async {
      // 1. Setup Mock SharedPreferences with Metric mode (unitSystem = 0)
      SharedPreferences.setMockInitialValues({
        'app_unit_system': 0, // Metric
      });
      final prefs = await SharedPreferences.getInstance();

      // 2. Setup ProviderContainer
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      // 3. Execute
      await container
          .read(aiControllerProvider.notifier)
          .processInput(null, "10x10x0.15 slab m20");

      final state = container.read(aiControllerProvider);

      // 4. Validation
      expect(state.response?.intent, AiIntent.calculation);
      expect(state.response?.calculation?.volume, closeTo(15.0, 0.01));
      expect(state.response.toString().toLowerCase(), contains('m³'));
    });
  });
}
