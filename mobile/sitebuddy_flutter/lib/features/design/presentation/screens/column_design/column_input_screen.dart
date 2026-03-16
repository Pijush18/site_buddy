import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/components/sb_button.dart';
import 'package:site_buddy/core/widgets/components/sb_card.dart';
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
    final theme = Theme.of(context);
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
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          // Geometry Card
          SBCard(
            title: 'Geometry',
            showDivider: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'Section Type',
                  style: TextStyle(
                    fontSize: AppFontSizes.subtitle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
                SbDropdown<ColumnType>(
                  value: state.type,
                  items: ColumnType.values,
                  itemLabelBuilder: (t) => t.label,
                  onChanged: (v) =>
                      v != null ? notifier.updateInput(type: v) : null,
                ),
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
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
                      const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
                      Expanded(
                        child: AppNumberField(
                          label: 'Depth (D) (mm)',
                          controller: _depthController,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                AppNumberField(
                  label: 'Unsupported Length (L) (mm)',
                  controller: _lengthController,
                ),
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                const Text(
                  'End Condition',
                  style: TextStyle(
                    fontSize: AppFontSizes.subtitle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
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
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          // Materials Card
          SBCard(
            title: 'Materials',
            showDivider: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Concrete Grade',
                            style: TextStyle(
                              fontSize: AppFontSizes.subtitle,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
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
                    const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Steel Grade',
                            style: TextStyle(
                              fontSize: AppFontSizes.subtitle,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
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
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                AppNumberField(
                  label: 'Clear Cover (mm)',
                  controller: _coverController,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SBButton.primary(
                label: 'Next: Load Definition',
                onPressed: _onNext,
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              SBButton.secondary(
                label: 'Back',
                onPressed: () => context.pop(),
                fullWidth: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
        ],
      ),
    );
  }
}
