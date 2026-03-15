import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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
    final theme = Theme.of(context);
    final state = ref.watch(calculatorProvider);
    final controller = ref.read(calculatorProvider.notifier);
    final colorScheme = theme.colorScheme;

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
      title: 'Material Calculator',
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
                Text(
                  'CONCRETE GRADE',
                  style: SbTextStyles.title(context).copyWith(
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppLayout.vGap16,
                SbDropdown<ConcreteGrade>(
                  value: state.grade,
                  items: ConcreteGrade.values,
                  itemLabelBuilder: _gradeLabel,
                  onChanged: (val) {
                    if (val != null) controller.updateGrade(val);
                  },
                ),
                AppLayout.vGap24,
                const _SectionLabel(label: 'Dimensions'),
                AppLayout.vGap16,
                AppNumberField(
                  label: 'Length (m)',
                  suffixIcon: SbIcons.ruler,
                  onChanged: controller.updateLength,
                  errorText: lError,
                ),
                AppLayout.vGap8,
                AppNumberField(
                  label: 'Width (m)',
                  suffixIcon: SbIcons.width,
                  onChanged: controller.updateWidth,
                  errorText: wError,
                ),
                AppLayout.vGap8,
                AppNumberField(
                  label: 'Thickness / Depth (m)',
                  suffixIcon: SbIcons.layers,
                  onChanged: controller.updateDepth,
                  errorText: dError,
                ),
                AppLayout.vGap24,
                const _SectionLabel(label: 'Reinforcement & Waste'),
                AppLayout.vGap16,
                Wrap(
                  spacing: AppLayout.md,
                  runSpacing: AppLayout.md,
                  children: [
                    SizedBox(
                      width: 160,
                      child: AppNumberField(
                        label: 'Steel Ratio (%)',
                        hint: '1',
                        suffixIcon: SbIcons.rebarVertical,
                        onChanged: controller.updateSteelRatio,
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: AppNumberField(
                        label: 'Waste Factor (%)',
                        hint: '0',
                        suffixIcon: SbIcons.percent,
                        onChanged: controller.updateWasteFactor,
                      ),
                    ),
                  ],
                ),
                AppLayout.vGap24,
                ActionButtonsGroup(
                  children: [
                    SbButton.outline(
                      label: 'Clear All',
                      icon: SbIcons.refresh,
                      onPressed: controller.reset,
                    ),
                    SbButton.primary(
                      label: state.isLoading ? 'Calculating...' : 'Calculate',
                      icon: state.isLoading ? null : SbIcons.calculator,
                      isLoading: state.isLoading,
                      onPressed: isValid ? controller.calculate : null,
                    ),
                  ],
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
                if (state.concreteResult != null) ...[
                  _ResultSection(result: state.concreteResult!),
                  AppLayout.vGap24,
                ],
                const _IsCodeNote(),
                AppLayout.vGap24,
              ],
            ),
          ),
        ),
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
  final ConcreteMaterialResult result;
  const _ResultSection({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SbCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'RESULT SUMMARY',
                style: SbTextStyles.title(context).copyWith(
                  color: colorScheme.primary,
                  
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              AppLayout.vGap16,
              const Divider(),
              
              // Basic concrete results
              SbListItem(
                title: 'Concrete Volume',
                trailing: Text(
                  '${result.concreteVolume.toStringAsFixed(3)} m³',
                  style: SbTextStyles.body(context),
                ),
              ),
              SbListItem(
                title: 'Cement Bags (50 kg)',
                trailing: Text(
                  '${result.cementBags.toStringAsFixed(0)} bags',
                  style: SbTextStyles.body(context).copyWith(
                    color: colorScheme.primary,
                    
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
              SbListItem(
                title: 'Aggregate Volume',
                trailing: Text(
                  '${result.aggregateVolume.toStringAsFixed(3)} m³',
                  style: SbTextStyles.body(context),
                ),
              ),

              const Divider(height: AppLayout.lg),

              // Steel results
              SbListItem(
                title: 'Steel Weight',
                trailing: Text(
                  '${result.steelWeight.toStringAsFixed(1)} kg',
                  style: SbTextStyles.body(context).copyWith(
                    
                    color: result.steelWeight > 0 ? colorScheme.secondary : null,
                  ),
                ),
              ),
              SbListItem(
                title: 'Binding Wire (≈1%)',
                trailing: Text(
                  '${result.bindingWire.toStringAsFixed(2)} kg',
                  style: SbTextStyles.body(context),
                ),
              ),

              if (result.steelWeight == 0)
                Padding(
                  padding: const EdgeInsets.only(top: AppLayout.pSmall),
                  child: Text(
                    'Steel ratio set to 0 — plain concrete (PCC) assumed.',
                    style: SbTextStyles.caption(context).copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const Divider(height: AppLayout.lg),

              // Mix Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mix Grade:', style: SbTextStyles.caption(context)),
                  Text(result.concreteGrade, style: SbTextStyles.bodySecondary(context)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class _IsCodeNote extends StatelessWidget {
  const _IsCodeNote();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Text(
      'Calculations per IS 456:2000 (nominal volume proportioning).\n'
      'Dry volume factor: 1.54 for concrete · 1.30 for mortar (IS 2212:1991).\n'
      'Steel density: 7850 kg/m³ (IS 1786).',
      style: SbTextStyles.caption(context).copyWith(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.center,
    );
  }
}