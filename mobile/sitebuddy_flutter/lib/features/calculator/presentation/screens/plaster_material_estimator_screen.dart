import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
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

    final aError = state.failure?.message.contains('Area') == true ? state.failure?.message : null;
    final tError = state.failure?.message.contains('Thickness') == true ? state.failure?.message : null;

    return AppScreenWrapper(
      title: EngineeringTerms.plasterEstimator,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionLabel(label: EngineeringTerms.plasterArea),
          const SizedBox(height: SbSpacing.lg),
          AppNumberField(
            label: EngineeringTerms.wallArea,
            hint: EngineeringTerms.areaHint,
            suffixIcon: SbIcons.area,
            onChanged: controller.updateArea,
            errorText: aError,
          ),
          const SizedBox(height: SbSpacing.sm),
          AppNumberField(
            label: EngineeringTerms.plasterThickness,
            hint: EngineeringTerms.diameterHint,
            suffixIcon: SbIcons.layers,
            onChanged: controller.updateThickness,
            errorText: tError,
          ),
          const SizedBox(height: SbSpacing.sm),
          Text(
            EngineeringTerms.typicalThicknessNote,
            style: Theme.of(context).textTheme.labelMedium!,
          ),
          const SizedBox(height: SbSpacing.xxl),
          Text(
            EngineeringTerms.mortarRatio,
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.lg),
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
          const SizedBox(height: SbSpacing.xxl),
          if (state.failure != null) ...[
            SbCard(
              child: Text(
                state.failure!.message,
                style: Theme.of(context).textTheme.bodyLarge!,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: SbSpacing.xxl),
          ],
          if (state.result != null) ...[
            _ResultSection(result: state.result!),
            const SizedBox(height: SbSpacing.xxl),
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
          const SizedBox(height: SbSpacing.xxl),
          Text(
            EngineeringTerms.isPlasterCodeNote,
            style: Theme.of(context).textTheme.labelMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.xxl),
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

class _ResultSection extends StatelessWidget {
  final PlasterMaterialResult result;
  const _ResultSection({required this.result});

  @override
  Widget build(BuildContext context) {
    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            EngineeringTerms.resultSummary,
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.lg),
          const Divider(),

          SbListItemTile(
            title: EngineeringTerms.cementBags,
            onTap: () {},
            trailing: Text(
              '${result.cementBags.toStringAsFixed(0)} ${AppStrings.bags}',
                style: Theme.of(context).textTheme.labelLarge!,
            ),
          ),
          SbListItemTile(
            title: EngineeringTerms.sandVolume,
            onTap: () {},
            trailing: Text(
              '${result.sandVolume.toStringAsFixed(3)} m³',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),
          const Divider(),
          const SizedBox(height: SbSpacing.xxl),
          SbListItemTile(
            title: EngineeringTerms.dryMortarVolume,
            onTap: () {},
            trailing: Text(
              '${result.dryVolume.toStringAsFixed(3)} m³',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(EngineeringTerms.mortarRatioLabel, style: Theme.of(context).textTheme.labelMedium!),
              Text(
                result.mortarRatio,
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(EngineeringTerms.thicknessLabel, style: Theme.of(context).textTheme.labelMedium!),
              Text(
                '${(result.thickness * 1000).toStringAsFixed(0)} mm',
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
