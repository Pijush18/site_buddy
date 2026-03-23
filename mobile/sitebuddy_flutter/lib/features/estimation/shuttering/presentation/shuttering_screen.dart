import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/estimation/shuttering/application/shuttering_controller.dart';
import 'package:site_buddy/core/models/prefill_data.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/features/estimation/shuttering/domain/shuttering_models.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

class ShutteringScreen extends ConsumerWidget {
  const ShutteringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shutteringProvider);
    final controller = ref.read(shutteringProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

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

    return SbPage.scaffold(
      title: l10n.titleShutteringEstimator,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionLabel(label: l10n.labelDimensions),
          const SizedBox(height: AppSpacing.sm),
          SbInput(
            label: '${l10n.labelLength} (m)',
            hint: l10n.hintLength,
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          const SizedBox(height: AppSpacing.md),
          SbInput(
            label: '${l10n.labelWidth} (m)',
            hint: l10n.hintWidth,
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          const SizedBox(height: AppSpacing.md),
          SbInput(
            label: '${l10n.labelDepth} (m)',
            hint: l10n.hintDepth,
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          const SizedBox(height: AppSpacing.md),
          SbListItemTile(
            title: l10n.labelIncludeBottom,
            onTap: () => controller.updateIncludeBottom(!state.includeBottom),
            trailing: Switch(
              value: state.includeBottom,
              onChanged: controller.updateIncludeBottom,
              activeThumbColor: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
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
          const SizedBox(height: AppSpacing.lg),
          if (state.failure != null)
             _ErrorBanner(message: state.failure!.message),
          if (state.result != null) ...[
            _ResultCard(result: state.result!),
            const SizedBox(height: AppSpacing.md),
            PrimaryCTA(
              label: l10n.actionExportPdf,
              icon: Icons.picture_as_pdf,
              onPressed: () {
                AppLogger.info('Export PDF clicked - implementation pending', tag: 'ShutteringUI');
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          Text(
            l10n.msgShutteringNote,
            style: Theme.of(context).textTheme.labelMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
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
        padding: const EdgeInsets.all(AppSpacing.lg),
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
  final ShutteringResult result;
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
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          SbListItemTile(
            title: l10n.labelTotalArea,
            onTap: () {},
            trailing: Text(
              '${result.areaM2.toStringAsFixed(2)} m²',
              style: theme.textTheme.titleMedium!,
            ),
          ),
          SbListItemTile(
            title: l10n.labelPerimeter,
            onTap: () {},
            trailing: Text(
              '${(2 * (result.length + result.width)).toStringAsFixed(2)} m',
              style: theme.textTheme.bodyLarge!,
            ),
          ),
          SbListItemTile(
            title: l10n.labelDepth,
            onTap: () {},
            trailing: Text(
              '${result.depth} m',
              style: theme.textTheme.bodyLarge!,
            ),
          ),
        ],
      ),
    );
  }
}


