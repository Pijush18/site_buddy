import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/constants/concrete_mix_constants.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/calculator/application/controllers/calculator_controller.dart';
import 'package:site_buddy/shared/domain/models/concrete_grade.dart';
import 'package:site_buddy/shared/domain/models/concrete_material_result.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:go_router/go_router.dart';

class MaterialCalculatorScreen extends ConsumerWidget {
  const MaterialCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final controller = ref.read(calculatorProvider.notifier);

    // Prefill logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is ConcretePrefillData) {
        controller.initializeWithPrefill(extra);
      }
    });

    final lError = state.failure?.message.contains('Length') == true ? state.failure?.message : null;
    final wError = state.failure?.message.contains('Width') == true ? state.failure?.message : null;
    final dError = state.failure?.message.contains('Depth') == true ? state.failure?.message : null;

    final bool isValid = state.lengthInput.isNotEmpty && state.widthInput.isNotEmpty && state.depthInput.isNotEmpty;

    return AppScreenWrapper(
      title: ScreenTitles.materialCalculator,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: SbSpacing.lg),
          SbSection(
            title: EngineeringTerms.concreteGrade,
            child: SbDropdown<ConcreteGrade>(
              value: state.grade,
              items: ConcreteGrade.values,
              itemLabelBuilder: _gradeLabel,
              onChanged: (val) {
                if (val != null) controller.updateGrade(val);
              },
            ),
          ),
          SbSection(
            title: EngineeringTerms.dimensions,
            child: Column(
              children: [
                AppNumberField(
                  label: EngineeringTerms.wallLength,
                  suffixIcon: SbIcons.ruler,
                  onChanged: controller.updateLength,
                  errorText: lError,
                ),
                const SizedBox(height: SbSpacing.sm),
                AppNumberField(
                  label: EngineeringTerms.width,
                  suffixIcon: SbIcons.width,
                  onChanged: controller.updateWidth,
                  errorText: wError,
                ),
                const SizedBox(height: SbSpacing.sm),
                AppNumberField(
                  label: EngineeringTerms.thicknessDepth,
                  suffixIcon: SbIcons.layers,
                  onChanged: controller.updateDepth,
                  errorText: dError,
                ),
              ],
            ),
          ),
          SbSection(
            title: EngineeringTerms.reinforcementAndWaste,
            child: Wrap(
              spacing: SbSpacing.lg,
              runSpacing: SbSpacing.lg,
              children: [
                SizedBox(
                  width: 160,
                  child: AppNumberField(
                    label: EngineeringTerms.steelRatioPercent,
                    hint: EngineeringTerms.steelRatioHint,
                    suffixIcon: SbIcons.rebarVertical,
                    onChanged: controller.updateSteelRatio,
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: AppNumberField(
                    label: EngineeringTerms.wasteFactorPercent,
                    hint: EngineeringTerms.wasteFactorHint,
                    suffixIcon: SbIcons.percent,
                    onChanged: controller.updateWasteFactor,
                  ),
                ),
              ],
            ),
          ),
          ActionButtonsGroup(
            children: [
              SbButton.outline(
                label: AppStrings.clearAll,
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              SbButton.primary(
                label: state.isLoading ? AppStrings.calculating : AppStrings.calculate,
                icon: state.isLoading ? null : SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
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
          if (state.concreteResult != null) ...[
            _ResultSection(result: state.concreteResult!),
            const SizedBox(height: SbSpacing.xxl),
          ],
          const _IsCodeNote(),
          const SizedBox(height: SbSpacing.xxl),
        ],
      ),
    );
  }

  static String _gradeLabel(ConcreteGrade grade) {
    final mix = ConcreteMixConstants.byGrade(grade.label);
    if (mix == null) return grade.label;
    return '${mix.grade}   '
        '(${mix.cementRatio.toStringAsFixed(0)} : '
        '${mix.sandRatio % 1 == 0 ? mix.sandRatio.toStringAsFixed(0) : mix.sandRatio.toStringAsFixed(1)} : '
        '${mix.aggregateRatio.toStringAsFixed(0)})';
  }
}

class _ResultSection extends StatelessWidget {
  final ConcreteMaterialResult result;
  const _ResultSection({required this.result});

  @override
  Widget build(BuildContext context) {

    return SbSection(
      title: EngineeringTerms.resultSummary,
      child: SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SbListItemTile(
              title: EngineeringTerms.concreteVolume,
              onTap: () {},
              trailing: Text(
                '${result.concreteVolume.toStringAsFixed(3)} m³',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
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
            SbListItemTile(
              title: EngineeringTerms.aggregateVolume,
              onTap: () {},
              trailing: Text(
                '${result.aggregateVolume.toStringAsFixed(3)} m³',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            const Divider(),
            const SizedBox(height: SbSpacing.xxl),
            SbListItemTile(
              title: EngineeringTerms.steelWeight,
              onTap: () {},
              trailing: Text(
                '${result.steelWeight.toStringAsFixed(1)} kg',
                style: Theme.of(context).textTheme.labelLarge!,
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.bindingWire,
              onTap: () {},
              trailing: Text(
                '${result.bindingWire.toStringAsFixed(2)} kg',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            if (result.steelWeight == 0)
              Padding(
                padding: const EdgeInsets.only(top: SbSpacing.sm),
                child: Text(
                  EngineeringTerms.steelRatioZeroNote,
                  style: Theme.of(context).textTheme.labelMedium!,
                  textAlign: TextAlign.center,
                ),
              ),
            const Divider(),
            const SizedBox(height: SbSpacing.xxl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(EngineeringTerms.mixGradeLabel,
                    style: Theme.of(context).textTheme.labelMedium!),
                Text(
                  result.concreteGrade,
                  style: Theme.of(context).textTheme.labelMedium!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IsCodeNote extends StatelessWidget {
  const _IsCodeNote();

  @override
  Widget build(BuildContext context) {
    return Text(
      EngineeringTerms.concreteCodeRef,
      style: Theme.of(context).textTheme.labelMedium!,
      textAlign: TextAlign.center,
    );
  }
}







