import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/calculator/application/controllers/rebar_controller.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// SCREEN: RebarScreen
/// PURPOSE: Estimate steel rebar quantity, length, and weight based on spacing and member dimensions.
class RebarScreen extends ConsumerWidget {
  const RebarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rebarControllerProvider);
    final controller = ref.read(rebarControllerProvider.notifier);
    final l10n = context.l10n;

    // Prefill logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is SteelWeightPrefillData) {
        controller.initializeWithPrefill(extra);
      }
    });

    final lError = state.failure?.message.toLowerCase().contains('length') == true ? state.failure?.message : null;
    final sError = state.failure?.message.toLowerCase().contains('spacing') == true ? state.failure?.message : null;
    final dError = state.failure?.message.toLowerCase().contains('diameter') == true ? state.failure?.message : null;

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
            const SizedBox(height: SbSpacing.lg),
            const Divider(),
            SbListItemTile(
              title: l10n.labelBars,
              onTap: () {}, // Detail view entry
              trailing: Text(
                res.numberOfBars.toStringAsFixed(0),
                style: Theme.of(context).textTheme.labelLarge!,
              ),
            ),
            SbListItemTile(
              title: l10n.labelTotalLength,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.totalLength.toStringAsFixed(2)} m',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            SbListItemTile(
              title: l10n.labelTotalWeight,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.totalWeight.toStringAsFixed(2)} kg',
                style: Theme.of(context).textTheme.labelLarge!,
              ),
            ),
          ],
        ),
      );
    }

    final bool isValid = state.memberLength != null && state.spacing != null && state.diameter != null;

    return SbPage.scaffold(
      title: l10n.titleRebarEstimator,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.labelStructure,
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.sm),

          SbInput(
            label: '${l10n.labelLength} (m)',
            suffixIcon: const Icon(SbIcons.ruler),
            onChanged: controller.updateMemberLength,
            errorText: lError,
          ),
          const SizedBox(height: SbSpacing.md),

          SbInput(
            label: '${l10n.labelSpacing} (m)',
            suffixIcon: const Icon(SbIcons.spacing),
            onChanged: controller.updateSpacing,
            errorText: sError,
          ),
          const SizedBox(height: SbSpacing.md),

          Row(
            children: [
              Expanded(
                child: SbInput(
                  label: '${l10n.labelDiameter} (mm)',
                  suffixIcon: const Icon(SbIcons.diameter),
                  onChanged: controller.updateDiameter,
                  errorText: dError,
                ),
              ),
              const SizedBox(width: SbSpacing.lg),
              Expanded(
                child: SbInput(
                  label: '${l10n.labelWastage} (%)',
                  suffixIcon: const Icon(SbIcons.percent),
                  onChanged: controller.updateWaste,
                ),
              ),
            ],
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
                icon: state.isLoading ? null : SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.lg),

          if (state.failure != null) ...[
            SbCard(
              child: Text(
                state.failure!.message,
                style: Theme.of(context).textTheme.bodyLarge!,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: SbSpacing.lg),
          ],

          if (state.result != null) ...[
            buildResultCard(),
            const SizedBox(height: SbSpacing.md),
            PrimaryCTA(
              label: l10n.actionExportPdf,
              icon: Icons.picture_as_pdf,
              onPressed: () {
                AppLogger.info('Export PDF clicked - implementation pending', tag: 'RebarUI');
              },
            ),
            const SizedBox(height: SbSpacing.xxl),
          ],
        ],
      ),
    );
  }
}
