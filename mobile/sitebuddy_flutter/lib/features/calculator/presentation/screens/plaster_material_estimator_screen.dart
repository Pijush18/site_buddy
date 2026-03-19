import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/calculator/application/controllers/plaster_controller.dart';
import 'package:site_buddy/shared/domain/models/plaster_ratio.dart';
import 'package:site_buddy/shared/domain/models/plaster_material_result.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

class PlasterMaterialEstimatorScreen extends ConsumerWidget {
  const PlasterMaterialEstimatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plasterProvider);
    final controller = ref.read(plasterProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final aError = state.failure?.message.contains('Area') == true ? state.failure?.message : null;
    final tError = state.failure?.message.contains('Thickness') == true ? state.failure?.message : null;

    return AppScreenWrapper(
      title: EngineeringTerms.plasterEstimator,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionLabel(label: EngineeringTerms.plasterArea),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          AppNumberField(
            label: EngineeringTerms.wallArea,
            hint: EngineeringTerms.areaHint,
            suffixIcon: SbIcons.area,
            onChanged: controller.updateArea,
            errorText: aError,
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          AppNumberField(
            label: EngineeringTerms.plasterThickness,
            hint: EngineeringTerms.diameterHint, // Reuse diameter hint or add specific thickness hint
            suffixIcon: SbIcons.layers,
            onChanged: controller.updateThickness,
            errorText: tError,
          ),
          const SizedBox(height: AppSpacing.sm / 2), // Replaced AppLayout.vGap4
          Text(
            EngineeringTerms.typicalThicknessNote,
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          Text(
            EngineeringTerms.mortarRatio,
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
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
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          if (state.failure != null) ...[
            SbCard(
              child: Text(
                state.failure!.message,
                style: TextStyle(
                  fontSize: AppFontSizes.subtitle,
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          ],
          if (state.result != null) ...[
            _ResultSection(result: state.result!),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          ],
          ActionButtonsGroup(
            children: [
              SbButton.outline(
                label: AppStrings.reset,
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              SbButton.primary(
                label: state.isLoading ? AppStrings.calculating : EngineeringTerms.calculateMaterials,
                icon: SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: controller.calculate,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          Text(
            EngineeringTerms.isPlasterCodeNote,
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg), // Added for bottom padding consistency
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
    final theme = Theme.of(context);
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: AppFontSizes.title,
        fontWeight: FontWeight.w600,
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
            EngineeringTerms.resultSummary,
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          const Divider(),

          SbListItemTile(
            title: EngineeringTerms.cementBags,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.cementBags.toStringAsFixed(0)} ${AppStrings.bags}',
              style: TextStyle(
                fontSize: AppFontSizes.subtitle,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
          SbListItemTile(
            title: EngineeringTerms.sandVolume,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.sandVolume.toStringAsFixed(3)} m³',
              style: const TextStyle(fontSize: AppFontSizes.subtitle),
            ),
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.lg
          SbListItemTile(
            title: EngineeringTerms.dryMortarVolume,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.dryVolume.toStringAsFixed(3)} m³',
              style: const TextStyle(fontSize: AppFontSizes.subtitle),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(EngineeringTerms.mortarRatioLabel, style: TextStyle(fontSize: AppFontSizes.tab)),
              Text(
                result.mortarRatio,
                style: TextStyle(
                  fontSize: AppFontSizes.tab,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(EngineeringTerms.thicknessLabel, style: TextStyle(fontSize: AppFontSizes.tab)),
              Text(
                '${(result.thickness * 1000).toStringAsFixed(0)} mm',
                style: TextStyle(
                  fontSize: AppFontSizes.tab,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
