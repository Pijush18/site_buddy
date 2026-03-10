import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/calculator/application/controllers/plaster_controller.dart';
import 'package:site_buddy/shared/domain/models/plaster_ratio.dart';
import 'package:site_buddy/shared/domain/models/plaster_material_result.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';

class PlasterMaterialEstimatorScreen extends ConsumerWidget {
  const PlasterMaterialEstimatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plasterProvider);
    final controller = ref.read(plasterProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbPage.scaffold(
      title: l10n.plasterEstimator,
      bottomAction: SbButton.primary(
        label: state.isLoading ? l10n.calculating : l10n.calculateMaterials,
        icon: SbIcons.calculator,
        isLoading: state.isLoading,
        onPressed: controller.calculate,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppLayout.pMedium),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionLabel(label: l10n.plasterArea),
                AppLayout.vGap16,
                AppNumberField(
                  label: l10n.wallArea,
                  hint: 'e.g. 80.0',
                  suffixIcon: SbIcons.area,
                  onChanged: controller.updateArea,
                ),
                AppLayout.vGap8,
                AppNumberField(
                  label: l10n.plasterThickness,
                  hint: 'e.g. 12',
                  suffixIcon: SbIcons.layers,
                  onChanged: controller.updateThickness,
                ),
                AppLayout.vGap4,
                Text(
                  l10n.typicalThicknessNote,
                  style: SbTextStyles.caption(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                AppLayout.vGap24,
                Text(
                  l10n.mortarRatio,
                  style: SbTextStyles.title(context).copyWith(
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppLayout.vGap16,
                SbDropdown<PlasterRatio>(
                  value: state.selectedRatio,
                  items: PlasterRatio.values,
                  itemLabelBuilder: (r) => r.label,
                  onChanged: (val) {
                    if (val != null) {
                      controller.updateRatio(val);
                    }
                  },
                ),
                AppLayout.vGap24,
                if (state.failure != null) ...[
                  SbCard(
                    child: Text(
                      state.failure!.message,
                      style: SbTextStyles.body(context).copyWith(
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AppLayout.vGap24,
                ],
                if (state.result != null) ...[
                  _ResultSection(result: state.result!),
                  AppLayout.vGap24,
                ],
                SbButton.outline(
                  label: l10n.reset,
                  icon: SbIcons.refresh,
                  onPressed: controller.reset,
                  width: double.infinity,
                ),
                AppLayout.vGap24,
                Text(
                  l10n.isCodeNote,
                  style: SbTextStyles.caption(context).copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label.toUpperCase(),
      style: SbTextStyles.title(context).copyWith(
        color: theme.colorScheme.primary,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _ResultSection extends StatelessWidget {
  final PlasterMaterialResult result;
  const _ResultSection({required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${l10n.estimationResults}  —  '
          '${result.mortarRatio} ${l10n.mixLabel}  ·  '
          '${(result.thickness * 1000).toStringAsFixed(0)} mm ${l10n.thickLabel}',
          style: SbTextStyles.title(context).copyWith(
            color: colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        AppLayout.vGap16,
        SbCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardHeader(
                icon: SbIcons.inventory,
                title: l10n.cementBags,
                color: colorScheme.primary,
              ),
              const Divider(height: AppLayout.md),
              SbListItem(
                title: l10n.cementBags_50kg,
                trailing: Text(
                  '${result.cementBags.toStringAsFixed(0)} ${l10n.bags}',
                  style: SbTextStyles.body(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              SbListItem(
                title: l10n.cementWeight,
                trailing: Text(
                  '${result.cementWeight.toStringAsFixed(1)} kg',
                  style: SbTextStyles.body(context),
                ),
              ),
              SbListItem(
                title: l10n.mixRatio,
                trailing: Text(
                  result.mortarRatio,
                  style: SbTextStyles.body(context),
                ),
              ),
            ],
          ),
        ),
        AppLayout.vGap16,
        SbCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardHeader(
                icon: SbIcons.terrain,
                title: l10n.sandVolume,
                color: colorScheme.secondary,
              ),
              const Divider(height: AppLayout.md),
              SbListItem(
                title: l10n.sandVolume,
                trailing: Text(
                  '${result.sandVolume.toStringAsFixed(3)} m³',
                  style: SbTextStyles.body(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppLayout.vGap16,
        SbCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardHeader(
                icon: SbIcons.waterDrop,
                title: l10n.mortarVolume,
                color: colorScheme.tertiary,
              ),
              const Divider(height: AppLayout.md),
              SbListItem(
                title: l10n.wetMortarVolume,
                trailing: Text(
                  '${result.wetVolume.toStringAsFixed(4)} m³',
                  style: SbTextStyles.body(context),
                ),
              ),
              SbListItem(
                title: l10n.dryMortarVolume,
                trailing: Text(
                  '${result.dryVolume.toStringAsFixed(3)} m³',
                  style: SbTextStyles.body(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              SbListItem(
                title: l10n.plasterArea,
                trailing: Text(
                  '${result.plasterArea.toStringAsFixed(2)} m²',
                  style: SbTextStyles.body(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  const _CardHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        AppLayout.hGap8,
        Text(
          title,
          style: SbTextStyles.title(context).copyWith(color: color),
        ),
      ],
    );
  }
}
