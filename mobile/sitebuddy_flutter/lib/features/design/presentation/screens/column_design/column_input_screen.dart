import 'package:site_buddy/core/constants/engineering_terms.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';

/// SCREEN: ColumnInputScreen
/// PURPOSE: Main input screen for Column Design (Step 1).
class ColumnInputScreen extends ConsumerStatefulWidget {
  const ColumnInputScreen({super.key});

  @override
  ConsumerState<ColumnInputScreen> createState() => _ColumnInputScreenState();
}

class _ColumnInputScreenState extends ConsumerState<ColumnInputScreen> {
  late final TextEditingController _widthController;
  late final TextEditingController _depthController;
  late final TextEditingController _lengthController;
  late final TextEditingController _coverController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(columnDesignControllerProvider);
    _widthController = TextEditingController(text: state.b.toString());
    _depthController = TextEditingController(text: state.d.toString());
    _lengthController = TextEditingController(text: state.length.toString());
    _coverController = TextEditingController(text: state.cover.toString());
  }

  @override
  void dispose() {
    _widthController.dispose();
    _depthController.dispose();
    _lengthController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  void _onNext() {
    final b = double.tryParse(_widthController.text) ?? 300.0;
    final d = double.tryParse(_depthController.text) ?? 300.0;
    final l = double.tryParse(_lengthController.text) ?? 3000.0;
    final cover = double.tryParse(_coverController.text) ?? 40.0;

    ref
        .read(columnDesignControllerProvider.notifier)
        .updateInput(b: b, d: d, length: l, cover: cover);

    context.push('/column/load');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(columnDesignControllerProvider);
    final notifier = ref.read(columnDesignControllerProvider.notifier);

    return AppScreenWrapper(
      title: 'Column Input',
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () => context.push('/design/column/input/history'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 1 of 6: Geometry & Materials',
            style: Theme.of(context).textTheme.labelMedium!,
          ),
          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24

          // Geometry Card
          SbSection(
            title: EngineeringTerms.sectionProperties,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: SbSpacing.lg),
                Text(
                  'Section Type',
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
                const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
                SbDropdown<ColumnType>(
                  value: state.type,
                  items: ColumnType.values,
                  itemLabelBuilder: (t) => t.label,
                  onChanged: (v) =>
                      v != null ? notifier.updateInput(type: v) : null,
                ),
                const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)
                Row(
                  children: [
                    Expanded(
                      child: AppNumberField(
                        label: state.type == ColumnType.circular
                            ? 'Diameter [mm]'
                            : 'Width (b) [mm]',
                        controller: _widthController,
                      ),
                    ),
                    if (state.type == ColumnType.rectangular) ...[
                      const SizedBox(width: SbSpacing.lg), // Replaced const SizedBox(width: SbSpacing.lg)
                      Expanded(
                        child: AppNumberField(
                          label: 'Depth (D) (mm)',
                          controller: _depthController,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)
                AppNumberField(
                  label: 'Unsupported Length (L) (mm)',
                  controller: _lengthController,
                ),
                const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)
                Text(
                  'End Condition',
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
                const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
                SbDropdown<EndCondition>(
                  value: state.endCondition,
                  items: EndCondition.values,
                  itemLabelBuilder: (e) => e.label,
                  onChanged: (v) => v != null
                      ? notifier.updateInput(endCondition: v)
                      : null,
                ),
              ],
            ),
          ),

          // Materials Card
          SbSection(
            title: EngineeringTerms.materials,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: SbSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Concrete Grade',
                            style: Theme.of(context).textTheme.labelLarge!,
                          ),
                          const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
                          SbDropdown<String>(
                            value: state.concreteGrade,
                            items: const ['M20', 'M25', 'M30', 'M35', 'M40'],
                            itemLabelBuilder: (s) => s,
                            onChanged: (v) => v != null
                                ? notifier.updateInput(concreteGrade: v)
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: SbSpacing.lg), // Replaced const SizedBox(width: SbSpacing.lg)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Steel Grade',
                            style: Theme.of(context).textTheme.labelLarge!,
                          ),
                          const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
                          SbDropdown<String>(
                            value: state.steelGrade,
                            items: const ['Fe415', 'Fe500', 'Fe550'],
                            itemLabelBuilder: (s) => s,
                            onChanged: (v) => v != null
                                ? notifier.updateInput(steelGrade: v)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)
                AppNumberField(
                  label: 'Clear Cover (mm)',
                  controller: _coverController,
                ),
              ],
            ),
          ),
          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Load Definition',
                onPressed: _onNext,
                width: double.infinity,
              ),
              const SizedBox(height: SbSpacing.sm),
              SbButton.secondary(
                label: 'Back',
                onPressed: () => context.pop(),
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24
        ],
      ),
    );
  }
}










