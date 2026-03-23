import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/features/estimation/sand/application/sand_controller.dart';

/// SCREEN: SandScreen
/// PURPOSE: UI for calculating sand volume based on area dimensions and rates.
class SandScreen extends ConsumerWidget {
  const SandScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sandControllerProvider);
    final controller = ref.read(sandControllerProvider.notifier);
    final l10n = context.l10n;

    final lError = state.error?.toLowerCase().contains('length') == true ? state.error : null;
    final wError = state.error?.toLowerCase().contains('width') == true ? state.error : null;
    final dError = state.error?.toLowerCase().contains('depth') == true ? state.error : null;

    final isValid = state.length != null && state.width != null && state.depth != null;

    Widget buildResultCard() {
      final res = state.result!;
      return SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.labelEstimationResults,
              style: Theme.of(context).textTheme.titleMedium!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${res.dryVolume.toStringAsFixed(2)} m³',
              style: Theme.of(context).textTheme.titleLarge!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            SbListItemTile(
              title: l10n.labelWetVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.wetVolume.toStringAsFixed(2)} m³',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            SbListItemTile(
              title: '${l10n.labelSand} (ft³)',
              onTap: () {}, // Detail view entry
              trailing: Text(
                res.cubicFeet.toStringAsFixed(2),
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            if (res.totalCost != null) ...[
              const SizedBox(height: AppSpacing.sm),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              SbListItemTile(
                title: l10n.labelEstimatedCost,
                onTap: () {}, // Detail view entry
                trailing: Text(
                  '\$ ${res.totalCost!.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return SbPage.scaffold(
      title: l10n.titleSandEstimator,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.labelDimensions,
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),

          SbInput(
            label: '${l10n.labelLength} (m)',
            suffixIcon: const Icon(SbIcons.ruler),
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          const SizedBox(height: AppSpacing.md),

          SbInput(
            label: '${l10n.labelWidth} (m)',
            suffixIcon: const Icon(SbIcons.ruler),
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          const SizedBox(height: AppSpacing.md),

          SbInput(
            label: '${l10n.labelDepth} (m)',
            suffixIcon: const Icon(SbIcons.height),
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          const SizedBox(height: AppSpacing.md),

          SbInput(
            label: '${l10n.labelRate} (opt)',
            suffixIcon: const Icon(SbIcons.payments),
            onChanged: controller.updateRate,
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

          if (state.error != null && lError == null && wError == null && dError == null) ...[
            SbCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  state.error!,
                  style: Theme.of(context).textTheme.bodyLarge!,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          if (state.result != null) ...[
            buildResultCard(),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

