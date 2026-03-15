import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/calculator/application/controllers/shuttering_controller.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/shared/domain/models/shuttering_result.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

class ShutteringScreen extends ConsumerWidget {
  const ShutteringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shutteringProvider);
    final controller = ref.read(shutteringProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    // Prefill logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is ShutteringPrefillData) {
        controller.initializeWithPrefill(extra);
      }
    });

    final lError = state.failure?.message.contains('Length') == true ? state.failure?.message : null;
    final wError = state.failure?.message.contains('Width') == true ? state.failure?.message : null;
    final dError = state.failure?.message.contains('Depth') == true ? state.failure?.message : null;

    final isValid = state.lengthInput.isNotEmpty && state.widthInput.isNotEmpty && state.depthInput.isNotEmpty;

    return SbPage.detail(
      title: 'Shuttering Area Estimator',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionLabel(label: 'Element Dimensions'),
          AppLayout.vGap8,
          AppNumberField(
            label: 'Length (m)',
            hint: 'e.g. 5.0',
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          AppLayout.vGap8,
          AppNumberField(
            label: 'Width (m)',
            hint: 'e.g. 0.3',
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          AppLayout.vGap8,
          AppNumberField(
            label: 'Depth (m)',
            hint: 'e.g. 0.6',
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          AppLayout.vGap8,
          SbListItem(
            title: 'Include Bottom Area?',
            trailing: Switch(
              value: state.includeBottom,
              onChanged: controller.updateIncludeBottom,
              activeThumbColor: colorScheme.primary,
            ),
          ),
          AppLayout.vGap24,
          ActionButtonsGroup(
            children: [
              SbButton.outline(
                label: 'Clear All',
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              SbButton.primary(
                label: state.isLoading ? 'Calculating...' : 'Calculate',
                icon: SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),
          AppLayout.vGap24,
          if (state.failure != null)
             _ErrorBanner(message: state.failure!.message),
          if (state.result != null) ...[
            _ResultCard(result: state.result!),
            AppLayout.vGap24,
          ],
          Text(
            'Estimation for simple beams, slabs, or footings.\n'
            'Area = 2 × (Length + Width) × Depth + Optional Bottom.',
            style: SbTextStyles.caption(context).copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: SbTextStyles.title(context).copyWith(
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 1.1,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return SbCard(
      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
      child: Text(
        message,
        style: SbTextStyles.body(context).copyWith(color: Theme.of(context).colorScheme.error),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final ShutteringResult result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'RESULT SUMMARY',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          AppLayout.vGap16,
          const Divider(),
          SbListItem(
            title: 'Total Shuttering Area',
            trailing: Text(
              '${result.areaM2.toStringAsFixed(2)} m²',
              style: SbTextStyles.title(context).copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SbListItem(
            title: 'Perimeter',
            trailing: Text('${(2 * (result.length + result.width)).toStringAsFixed(2)} m'),
          ),
          SbListItem(
            title: 'Depth',
            trailing: Text('${result.depth} m'),
          ),
        ],
      ),
    );
  }
}
