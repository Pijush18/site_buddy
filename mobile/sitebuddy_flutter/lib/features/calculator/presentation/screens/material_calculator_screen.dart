import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/core/constants/concrete_mix_constants.dart';
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
    final l10n = context.l10n;

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

    return SbPage.scaffold(
      title: l10n.titleConcreteEstimator,
      body: SbSectionList(
        sections: [
          SbSection(
            title: l10n.labelGrade,
            child: SbCard(
              child: SbDropdown<ConcreteGrade>(
                value: state.grade,
                items: ConcreteGrade.values,
                itemLabelBuilder: _gradeLabel,
                onChanged: (val) {
                  if (val != null) controller.updateGrade(val);
                },
              ),
            ),
          ),
          SbSection(
            title: l10n.labelDimensions,
            child: SbCard(
              child: Column(
                children: [
                  SbInput(
                    label: '${l10n.labelLength} (m)',
                    suffixIcon: const Icon(SbIcons.ruler),
                    onChanged: controller.updateLength,
                    errorText: lError,
                  ),
                  const SizedBox(height: SbSpacing.md),
                  SbInput(
                    label: '${l10n.labelWidth} (m)',
                    suffixIcon: const Icon(SbIcons.width),
                    onChanged: controller.updateWidth,
                    errorText: wError,
                  ),
                  const SizedBox(height: SbSpacing.md),
                  SbInput(
                    label: '${l10n.labelThickness} (m)',
                    suffixIcon: const Icon(SbIcons.layers),
                    onChanged: controller.updateDepth,
                    errorText: dError,
                  ),
                ],
              ),
            ),
          ),
          SbSection(
            title: l10n.labelSpecification,
            child: SbCard(
              child: Row(
                children: [
                  Expanded(
                    child: SbInput(
                      label: '${l10n.labelSteel} (%)',
                      hint: l10n.hintSteelRatio,
                      suffixIcon: const Icon(SbIcons.rebarVertical),
                      onChanged: controller.updateSteelRatio,
                    ),
                  ),
                  const SizedBox(width: SbSpacing.lg),
                  Expanded(
                    child: SbInput(
                      label: '${l10n.labelWastage} (%)',
                      hint: l10n.hintWastage,
                      suffixIcon: const Icon(SbIcons.percent),
                      onChanged: controller.updateWasteFactor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SbSection(
            child: ActionButtonsGroup(
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
          ),
          if (state.failure != null)
            SbSection(
              child: SbCard(
                child: Text(
                  state.failure!.message,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (state.concreteResult != null) _ResultSection(result: state.concreteResult!),
          SbSection(
            child: Text(
              l10n.msgIsCodeNote,
              style: Theme.of(context).textTheme.labelMedium!,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: SbSpacing.lg),
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
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SbSection(
      title: l10n.labelEstimationResults,
      child: SbListGroup(
        children: [
          SbListItemTile(
            title: l10n.labelVolume,
            onTap: () {},
            trailing: Text(
              '${result.concreteVolume.toStringAsFixed(3)} m³',
              style: theme.textTheme.bodyLarge,
            ),
          ),
          SbListItemTile(
            title: l10n.labelCement,
            onTap: () {},
            trailing: Text(
              '${result.cementBags.toStringAsFixed(0)} ${l10n.labelBags}',
              style: theme.textTheme.labelLarge,
            ),
          ),
          SbListItemTile(
            title: l10n.labelSand,
            onTap: () {},
            trailing: Text(
              '${result.sandVolume.toStringAsFixed(3)} m³',
              style: theme.textTheme.bodyLarge,
            ),
          ),
          SbListItemTile(
            title: l10n.labelAggregate,
            onTap: () {},
            trailing: Text(
              '${result.aggregateVolume.toStringAsFixed(3)} m³',
              style: theme.textTheme.bodyLarge,
            ),
          ),
          SbListItemTile(
            title: l10n.labelSteel,
            onTap: () {},
            trailing: Text(
              '${result.steelWeight.toStringAsFixed(1)} kg',
              style: theme.textTheme.labelLarge,
            ),
          ),
          SbListItemTile(
            title: l10n.labelBindingWire,
            onTap: () {},
            trailing: Text(
              '${result.bindingWire.toStringAsFixed(2)} kg',
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
