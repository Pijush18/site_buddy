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
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

class PlasterMaterialEstimatorScreen extends ConsumerWidget {
  const PlasterMaterialEstimatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plasterProvider);
    final controller = ref.read(plasterProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final aError = state.failure?.message.contains('Area') == true ? state.failure?.message : null;
    final tError = state.failure?.message.contains('Thickness') == true ? state.failure?.message : null;

    return SbPage.scaffold(
      title: l10n.plasterEstimator,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                  errorText: aError,
                ),
                AppLayout.vGap8,
                AppNumberField(
                  label: l10n.plasterThickness,
                  hint: 'e.g. 12',
                  suffixIcon: SbIcons.layers,
                  onChanged: controller.updateThickness,
                  errorText: tError,
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
                ActionButtonsGroup(
                  children: [
                    SbButton.outline(
                      label: l10n.reset,
                      icon: SbIcons.refresh,
                      onPressed: controller.reset,
                    ),
                    SbButton.primary(
                      label: state.isLoading ? l10n.calculating : l10n.calculateMaterials,
                      icon: SbIcons.calculator,
                      isLoading: state.isLoading,
                      onPressed: controller.calculate,
                    ),
                  ],
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            title: 'Cement Bags (50 kg)',
            trailing: Text(
              '${result.cementBags.toStringAsFixed(0)} bags',
              style: SbTextStyles.body(context).copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SbListItem(
            title: 'Sand Volume',
            trailing: Text(
              '${result.sandVolume.toStringAsFixed(3)} m³',
              style: SbTextStyles.body(context),
            ),
          ),
          const Divider(height: AppLayout.lg),
          SbListItem(
            title: 'Dry Mortar Volume',
            trailing: Text(
              '${result.dryVolume.toStringAsFixed(3)} m³',
              style: SbTextStyles.body(context),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mix Ratio:', style: SbTextStyles.caption(context)),
              Text(result.mortarRatio, style: SbTextStyles.bodySecondary(context)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Thickness:', style: SbTextStyles.caption(context)),
              Text('${(result.thickness * 1000).toStringAsFixed(0)} mm', style: SbTextStyles.bodySecondary(context)),
            ],
          ),
        ],
      ),
    );
  }
}

