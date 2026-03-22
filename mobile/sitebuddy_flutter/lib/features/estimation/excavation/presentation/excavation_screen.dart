import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/estimation/excavation/application/excavation_controller.dart';
import 'package:site_buddy/core/models/prefill_data.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/features/estimation/excavation/domain/excavation_models.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

class ExcavationScreen extends ConsumerWidget {
  const ExcavationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(excavationProvider);
    final controller = ref.read(excavationProvider.notifier);
    final l10n = context.l10n;

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

    return SbPage.scaffold(
      title: l10n.titleExcavationEstimator,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionLabel(label: l10n.labelDimensions),
          const SizedBox(height: SbSpacing.sm),
          SbInput(
            label: '${l10n.labelLength} (m)',
            hint: l10n.hintPitLength,
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          const SizedBox(height: SbSpacing.md),
          SbInput(
            label: '${l10n.labelWidth} (m)',
            hint: l10n.hintPitLength,
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          const SizedBox(height: SbSpacing.md),
          SbInput(
            label: '${l10n.labelDepth} (m)',
            hint: l10n.hintPitDepth,
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          const SizedBox(height: SbSpacing.lg),
          _SectionLabel(label: l10n.labelParameters),
          const SizedBox(height: SbSpacing.sm),
          SbInput(
            label: '${l10n.labelClearance} (m)',
            hint: l10n.hintWidth,
            initialValue: '0.3',
            onChanged: controller.updateClearance,
            onInfoPressed: () => SbFeedback.showToast(
              context: context,
              message: l10n.msgClearanceInfo,
            ),
          ),
          const SizedBox(height: SbSpacing.md),
          SbInput(
            label: l10n.labelSwellFactor,
            hint: l10n.hintSwellFactor,
            initialValue: '1.25',
            onChanged: controller.updateSwellFactor,
            onInfoPressed: () => SbFeedback.showToast(
              context: context,
              message: l10n.msgSwellFactorInfo,
            ),
          ),
          const SizedBox(height: SbSpacing.lg),
          ActionButtonsGroup(
            children: [
              SecondaryButton(isOutlined: true, 
                label: l10n.actionClearAll,
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              PrimaryCTA(
                label: l10n.actionCalculate,
                icon: SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.lg),
          if (state.failure != null)
            _ErrorBanner(message: state.failure!.message),
          if (state.result != null) ...[
            _ResultCard(result: state.result!),
            const SizedBox(height: SbSpacing.md),
            PrimaryCTA(
              label: l10n.actionExportPdf,
              icon: Icons.picture_as_pdf,
              onPressed: () {
                AppLogger.info('Export PDF clicked - implementation pending', tag: 'ExcavationUI');
              },
            ),
            const SizedBox(height: SbSpacing.lg),
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
      style: Theme.of(context).textTheme.titleMedium!,
      textAlign: TextAlign.center,
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SbCard(
      color: colorScheme.errorContainer.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(SbSpacing.lg),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge!,
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
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.labelEstimationResults,
            style: theme.textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.lg),
          const Divider(),
          SbListItemTile(
            title: l10n.labelTotalVolume,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.volumeM3.toStringAsFixed(2)} m³',
              style: theme.textTheme.titleMedium!,
            ),
          ),
          SbListItemTile(
            title: l10n.labelBankVolumeNatural,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${(result.volumeM3 / result.swellFactor).toStringAsFixed(2)} m³',
              style: theme.textTheme.bodyLarge!,
            ),
          ),
          const Divider(),
          const SizedBox(height: SbSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.labelClearance,
                  style: theme.textTheme.labelMedium!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: SbSpacing.md),
              Text(
                '${result.clearance} m',
                style: theme.textTheme.labelMedium!,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.labelSwellFactor,
                  style: theme.textTheme.labelMedium!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: SbSpacing.md),
              Text(
                '${result.swellFactor}',
                style: theme.textTheme.labelMedium!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


