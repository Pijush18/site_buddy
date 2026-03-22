import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/calculator/application/controllers/plaster_controller.dart';
import 'package:site_buddy/shared/domain/models/plaster_ratio.dart';
import 'package:site_buddy/shared/domain/models/plaster_material_result.dart';

class PlasterMaterialEstimatorScreen extends ConsumerWidget {
  const PlasterMaterialEstimatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _PlasterContent();
  }
}

class _PlasterContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plasterProvider);
    final controller = ref.read(plasterProvider.notifier);
    final l10n = context.l10n;

    final aError = state.failure?.message.contains('Area') == true ? state.failure?.message : null;
    final tError = state.failure?.message.contains('Thickness') == true ? state.failure?.message : null;

    return SbPage.scaffold(
      title: l10n.titlePlasterEstimator,
      body: SbSectionList(
        sections: [
          // ── INPUT SECTION ──
          SbSection(
            title: l10n.labelArea,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SbInput(
                  label: '${l10n.labelArea} (m²)',
                  hint: l10n.hintArea,
                  suffixIcon: const Icon(SbIcons.area),
                  onChanged: controller.updateArea,
                  errorText: aError,
                ),
                const SizedBox(height: SbSpacing.md),
                SbInput(
                  label: '${l10n.labelThickness} (mm)',
                  hint: l10n.hintDiameter,
                  suffixIcon: const Icon(SbIcons.layers),
                  onChanged: controller.updateThickness,
                  errorText: tError,
                ),
                const SizedBox(height: SbSpacing.sm),
                Text(
                  l10n.msgPlasterThicknessNote,
                  style: Theme.of(context).textTheme.labelMedium!,
                ),
              ],
            ),
          ),

          // ── RATIO SECTION ──
          SbSection(
            title: l10n.labelRatio,
            child: SbDropdown<PlasterRatio>(
              value: state.selectedRatio,
              items: PlasterRatio.values,
              itemLabelBuilder: (r) => r.label,
              onChanged: (val) {
                if (val != null) {
                  controller.updateRatio(val);
                }
              },
            ),
          ),

          // ── FAILURE/RESULT SECTION ──
          if (state.failure != null)
            SbSection(
              child: SbCard(
                child: Text(
                  state.failure!.message,
                  style: Theme.of(context).textTheme.bodyLarge!,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          
          if (state.result != null)
            SbSection(
              child: _ResultSection(result: state.result!),
            ),

          // ── ACTION SECTION ──
          SbSection(
            child: PrimaryCTA(
              label: l10n.actionCalculate,
              icon: SbIcons.calculator,
              isLoading: state.isLoading,
              onPressed: controller.calculate,
              width: double.infinity,
            ),
          ),

          // ── RESET ACTION ──
          SbSection(
            child: SecondaryButton(isOutlined: true, 
              label: l10n.actionReset,
              icon: SbIcons.refresh,
              onPressed: controller.reset,
              width: double.infinity,
            ),
          ),

          // ── CODEX NOTE ──
          SbSection(
            child: Text(
              l10n.msgIsCodeNote,
              style: Theme.of(context).textTheme.labelMedium!,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}


class _ResultSection extends StatelessWidget {
  final PlasterMaterialResult result;
  const _ResultSection({required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

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
            title: l10n.labelCement,
            onTap: () {},
            trailing: Text(
              '${result.cementBags.toStringAsFixed(0)} ${l10n.labelBags}',
                style: theme.textTheme.labelLarge!,
            ),
          ),
          SbListItemTile(
            title: l10n.labelSand,
            onTap: () {},
            trailing: Text(
              '${result.sandVolume.toStringAsFixed(3)} m³',
              style: theme.textTheme.bodyLarge!,
            ),
          ),
          const Divider(),
          const SizedBox(height: SbSpacing.lg),
          SbListItemTile(
            title: l10n.labelDryVolume,
            onTap: () {},
            trailing: Text(
              '${result.dryVolume.toStringAsFixed(3)} m³',
              style: theme.textTheme.bodyLarge!,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.labelRatio, 
                  style: theme.textTheme.labelMedium!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: SbSpacing.md),
              Text(
                result.mortarRatio,
                style: theme.textTheme.labelMedium!,
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.labelThickness, 
                  style: theme.textTheme.labelMedium!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: SbSpacing.md),
              Text(
                '${(result.thickness * 1000).toStringAsFixed(0)} mm',
                style: theme.textTheme.labelMedium!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
