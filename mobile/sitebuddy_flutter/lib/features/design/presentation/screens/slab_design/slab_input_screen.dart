import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/utils/validation_helper.dart';
import 'package:site_buddy/shared/domain/models/design/slab_type.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';

class SlabInputScreen extends ConsumerStatefulWidget {
  const SlabInputScreen({super.key});

  @override
  ConsumerState<SlabInputScreen> createState() => _SlabInputScreenState();
}

class _SlabInputScreenState extends ConsumerState<SlabInputScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _lxController;
  late final TextEditingController _lyController;
  late final TextEditingController _depthController;
  late final TextEditingController _coverController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(slabDesignControllerProvider);
    _lxController = TextEditingController(text: state.lx > 0 ? state.lx.toString() : '');
    _lyController = TextEditingController(text: state.ly > 0 ? state.ly.toString() : '');
    _depthController = TextEditingController(text: state.d > 0 ? state.d.toString() : '');
    _coverController = TextEditingController(text: state.cover.toString());
  }

  @override
  void dispose() {
    _lxController.dispose();
    _lyController.dispose();
    _depthController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(slabDesignControllerProvider.notifier);
    notifier.updateLx(double.parse(_lxController.text));
    notifier.updateLy(double.parse(_lyController.text));
    notifier.updateDepth(double.parse(_depthController.text));
    notifier.updateCover(double.parse(_coverController.text));

    context.push('/slab/load');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(slabDesignControllerProvider);
    final notifier = ref.read(slabDesignControllerProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    // Prefill logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      final extra = GoRouterState.of(context).extra;
      if (extra is SlabDesignPrefillData) {
        notifier.initializeWithPrefill(extra);
        // Sync controllers with prefilled state if they were empty
        if (_lxController.text.isEmpty && extra.lx != null) {
          _lxController.text = extra.lx.toString();
        }
        if (_lyController.text.isEmpty && extra.ly != null) {
          _lyController.text = extra.ly.toString();
        }
        if (_depthController.text.isEmpty && extra.depth != null) {
          _depthController.text = extra.depth.toString();
        }
      }
    });

    return AppScreenWrapper(
      title: 'Slab Input',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Step 1 of 5: Geometry & Materials',
              style: TextStyle(
                fontSize: AppFontSizes.title,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

            SbSection(
              title: EngineeringTerms.geometry,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Slab Behavior',
                    style: TextStyle(
                      fontSize: AppFontSizes.subtitle,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
                  SbDropdown<SlabType>(
                    value: state.type,
                    items: SlabType.values,
                    itemLabelBuilder: (t) => t.label,
                    onChanged: (v) => v != null ? notifier.updateType(v) : null,
                  ),
                  const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                  Row(
                    children: [
                      Expanded(
                        child: AppNumberField(
                          controller: _lxController,
                          label: 'Short Span (Lx) (m)',
                          validator: (v) => ValidationHelper.validatePositive(v, 'Lx'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
                      Expanded(
                        child: AppNumberField(
                          controller: _lyController,
                          label: 'Long Span (Ly) (m)',
                          validator: (v) => ValidationHelper.validatePositive(v, 'Ly'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                  AppNumberField(
                    controller: _depthController,
                    label: 'Overall Thickness (D) (mm)',
                    validator: (v) => ValidationHelper.validatePositive(v, 'Thickness'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

            SbSection(
              title: EngineeringTerms.materialProperties,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _gradeDropdown(
                          'Concrete Grade',
                          state.concreteGrade,
                          ['M20', 'M25', 'M30', 'M35'],
                          notifier.updateConcreteGrade,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
                      Expanded(
                        child: _gradeDropdown(
                          'Steel Grade',
                          state.steelGrade,
                          ['Fe415', 'Fe500', 'Fe550'],
                          notifier.updateSteelGrade,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                  AppNumberField(
                    controller: _coverController,
                    label: 'Clear Cover (mm)',
                    validator: (v) => ValidationHelper.validatePositive(v, 'Cover'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SbButton.primary(
                  label: 'Next: Load Definition',
                  onPressed: _onNext,
                  icon: Icons.arrow_forward,
                  width: double.infinity,
                ),
                const SizedBox(height: AppSpacing.sm),
                SbButton.secondary(
                  label: 'Back',
                  onPressed: () => context.pop(),
                  width: double.infinity,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg), // Added for bottom padding consistency
          ],
        ),
      ),
    );
  }

  Widget _gradeDropdown(String label, String value, List<String> items, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppFontSizes.subtitle,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
        SbDropdown<String>(
          value: value,
          items: items,
          itemLabelBuilder: (s) => s,
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ],
    );
  }
}
