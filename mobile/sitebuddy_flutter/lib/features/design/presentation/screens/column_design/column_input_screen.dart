import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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
    final theme = Theme.of(context);
    final state = ref.watch(columnDesignControllerProvider);
    final notifier = ref.read(columnDesignControllerProvider.notifier);

    return SbPage.detail(
      title: 'Column Input',

      appBarActions: [
        SbButton.icon(
          icon: SbIcons.history,
          onPressed: () => context.push('/design/column/input/history'),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 1 of 6: Geometry & Materials',
            style: SbTextStyles.caption(context).copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppLayout.vGap24,

          // Geometry Card
          SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Geometry', style: SbTextStyles.title(context)),
                  AppLayout.vGap16,
                  Text('Column Type', style: SbTextStyles.body(context)),
                  AppLayout.vGap8,
                  SbDropdown<ColumnType>(
                    value: state.type,
                    items: ColumnType.values,
                    itemLabelBuilder: (t) => t.label,
                    onChanged: (v) =>
                        v != null ? notifier.updateInput(type: v) : null,
                  ),
                  AppLayout.vGap16,
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
                        AppLayout.hGap16,
                        Expanded(
                          child: AppNumberField(
                            label: 'Depth (D) (mm)',
                            controller: _depthController,
                          ),
                        ),
                      ],
                    ],
                  ),
                  AppLayout.vGap16,
                  AppNumberField(
                    label: 'Unsupported Length (L) (mm)',
                    controller: _lengthController,
                  ),
                  AppLayout.vGap16,
                  Text('End Condition', style: SbTextStyles.body(context)),
                  AppLayout.vGap8,
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
          AppLayout.vGap24,

          // Materials Card
          SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Materials', style: SbTextStyles.title(context)),
                  AppLayout.vGap16,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Concrete Grade',
                              style: SbTextStyles.body(context),
                            ),
                            AppLayout.vGap8,
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
                      AppLayout.hGap16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Steel Grade',
                              style: SbTextStyles.body(context),
                            ),
                            AppLayout.vGap8,
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
                  AppLayout.vGap16,
                  AppNumberField(
                    label: 'Clear Cover (mm)',
                    controller: _coverController,
                  ),
                ],
              ),
            ),
          AppLayout.vGap24,

          SbButton.primary(label: 'Next: Load Definition', onPressed: _onNext),
          AppLayout.vGap24,
        ],
      ),
    );
  }
}
