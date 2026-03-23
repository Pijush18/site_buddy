import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';

import 'package:site_buddy/features/structural/column/application/column_design_controller.dart';
import 'package:site_buddy/features/structural/column/domain/column_enums.dart';

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

    ref.read(columnDesignControllerProvider.notifier).updateInput(
          b: b,
          d: d,
          length: l,
          cover: cover,
        );

    context.push('/column/load');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(columnDesignControllerProvider);
    final notifier = ref.read(columnDesignControllerProvider.notifier);

    return SbPage.form(
      title: l10n.titleColumn,
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () => context.push('/design/column/input/history'),
        ),
      ],
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionNext,
            onPressed: _onNext,
            icon: Icons.navigate_next,
          ),
          const SizedBox(height: AppSpacing.sm),
          GhostButton(
            label: l10n.actionBack,
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SbSectionList(
        sections: [
          // ── STEP HEADER ──
          SbSection(
            child: Text(
              l10n.labelStep1Geometry,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── SECTION PROPERTIES ──
          SbSection(
            title: l10n.labelSectionProperties,
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.labelType,
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SbDropdown<ColumnType>(
                    value: state.type,
                    items: ColumnType.values,
                    itemLabelBuilder: (v) => v.label,
                    onChanged: (v) {
                      if (v != null) {
                        notifier.updateInput(type: v);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (state.type == ColumnType.circular)
                    SbInput(
                      label: l10n.labelDiaUnit,
                      controller: _widthController,
                    )
                  else ...[
                    SbInput(
                      label: l10n.labelWidthBUnit,
                      controller: _widthController,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SbInput(
                      label: l10n.labelDepthDUnit,
                      controller: _depthController,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  SbInput(
                    label: l10n.labelLengthLUnit,
                    controller: _lengthController,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.labelEndCondition,
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SbDropdown<EndCondition>(
                    value: state.endCondition,
                    items: EndCondition.values,
                    itemLabelBuilder: (v) => v.label,
                    onChanged: (v) {
                      if (v != null) {
                        notifier.updateInput(endCondition: v);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── MATERIALS ──
          SbSection(
            title: l10n.labelMaterials,
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.labelConcrete,
                              style: Theme.of(context).textTheme.labelLarge!,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            SbDropdown<String>(
                              value: state.concreteGrade,
                              items: const ['M20', 'M25', 'M30', 'M35', 'M40'],
                              itemLabelBuilder: (v) => v,
                              onChanged: (v) {
                                if (v != null) {
                                  notifier.updateInput(concreteGrade: v);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.labelSteel,
                              style: Theme.of(context).textTheme.labelLarge!,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            SbDropdown<String>(
                              value: state.steelGrade,
                              items: const ['Fe415', 'Fe500', 'Fe550'],
                              itemLabelBuilder: (v) => v,
                              onChanged: (v) {
                                if (v != null) {
                                  notifier.updateInput(steelGrade: v);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SbInput(
                    label: l10n.labelCoverUnit,
                    controller: _coverController,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


