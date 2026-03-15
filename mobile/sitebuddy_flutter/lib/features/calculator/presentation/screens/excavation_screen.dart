import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/calculator/application/controllers/excavation_controller.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/shared/domain/models/excavation_result.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

class ExcavationScreen extends ConsumerWidget {
  const ExcavationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(excavationProvider);
    final controller = ref.read(excavationProvider.notifier);

    // Prefill logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is ExcavationPrefillData) {
        controller.initializeWithPrefill(extra);
      }
    });

    final lError = state.failure?.message.contains('Length') == true ? state.failure?.message : null;
    final wError = state.failure?.message.contains('Width') == true ? state.failure?.message : null;
    final dError = state.failure?.message.contains('Depth') == true ? state.failure?.message : null;

    final isValid = state.lengthInput.isNotEmpty && state.widthInput.isNotEmpty && state.depthInput.isNotEmpty;

    return SbPage.detail(
      title: 'Excavation Calculator',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionLabel(label: 'Pit Dimensions'),
          AppLayout.vGap8,
          AppNumberField(
            label: 'Length (m)',
            hint: 'e.g. 2.0',
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          AppLayout.vGap8,
          AppNumberField(
            label: 'Width (m)',
            hint: 'e.g. 2.0',
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          AppLayout.vGap8,
          AppNumberField(
            label: 'Depth (m)',
            hint: 'e.g. 1.5',
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          AppLayout.vGap24,
          const _SectionLabel(label: 'Parameters'),
          AppLayout.vGap8,
          AppNumberField(
            label: 'Clearance (m)',
            hint: 'e.g. 0.3',
            initialValue: '0.3',
            onChanged: controller.updateClearance,
            onInfoPressed: () => SbFeedback.showToast(
              context: context,
              message: 'Extra space added around the pit for working room (IS 3764).',
            ),
          ),
          AppLayout.vGap8,
          AppNumberField(
            label: 'Swell Factor',
            hint: 'e.g. 1.25',
            initialValue: '1.25',
            onChanged: controller.updateSwellFactor,
            onInfoPressed: () => SbFeedback.showToast(
              context: context,
              message: 'Ratio of loose volume to bank volume. 1.25 for typical soil.',
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
      child: Padding(
        padding: AppLayout.paddingMd,
        child: Text(
          message,
          style: SbTextStyles.body(context).copyWith(color: Theme.of(context).colorScheme.error),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final ExcavationResult result;
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
              
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          AppLayout.vGap16,
          const Divider(),
          SbListItem(
            title: 'Total Volume (Loose)',
            trailing: Text(
              '${result.volumeM3.toStringAsFixed(2)} m³',
              style: SbTextStyles.title(context).copyWith(
                color: colorScheme.primary,
                
              ),
            ),
          ),
          SbListItem(
            title: 'Bank Volume (Natural)',
            trailing: Text(
              '${(result.volumeM3 / result.swellFactor).toStringAsFixed(2)} m³',
              style: SbTextStyles.body(context),
            ),
          ),
          const Divider(height: AppLayout.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Clearance:', style: SbTextStyles.caption(context)),
              Text('${result.clearance} m', style: SbTextStyles.bodySecondary(context)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Swell Factor:', style: SbTextStyles.caption(context)),
              Text('${result.swellFactor}', style: SbTextStyles.bodySecondary(context)),
            ],
          ),
        ],
      ),
    );
  }
}
