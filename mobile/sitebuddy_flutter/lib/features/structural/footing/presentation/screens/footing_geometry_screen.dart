import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/features/structural/footing/application/footing_design_controller.dart';

import 'package:site_buddy/features/structural/footing/domain/footing_type.dart';
import 'package:site_buddy/features/structural/footing/presentation/extensions/footing_type_l10n.dart';

class FootingGeometryScreen extends ConsumerStatefulWidget {
  const FootingGeometryScreen({super.key});

  @override
  ConsumerState<FootingGeometryScreen> createState() =>
      _FootingGeometryScreenState();
}

class _FootingGeometryScreenState extends ConsumerState<FootingGeometryScreen> {
  late final TextEditingController _lengthController;
  late final TextEditingController _widthController;
  late final TextEditingController _thicknessController;
  late final TextEditingController _spacingController;
  late final TextEditingController _colAController;
  late final TextEditingController _colBController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(footingDesignControllerProvider);
    _lengthController = TextEditingController(
      text: state.footingLength.toString(),
    );
    _widthController = TextEditingController(
      text: state.footingWidth.toString(),
    );
    _thicknessController = TextEditingController(
      text: state.footingThickness.toString(),
    );
    _spacingController = TextEditingController(
      text: state.columnSpacing.toString(),
    );
    _colAController = TextEditingController(text: state.colA.toString());
    _colBController = TextEditingController(text: state.colB.toString());
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    _thicknessController.dispose();
    _spacingController.dispose();
    _colAController.dispose();
    _colBController.dispose();
    super.dispose();
  }

  void _onNext() {
    ref
        .read(footingDesignControllerProvider.notifier)
        .updateGeometry(
          length: double.tryParse(_lengthController.text),
          width: double.tryParse(_widthController.text),
          thickness: double.tryParse(_thicknessController.text),
          spacing: double.tryParse(_spacingController.text),
          colA: double.tryParse(_colAController.text),
          colB: double.tryParse(_colBController.text),
        );
    context.push('/footing/analysis');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(footingDesignControllerProvider);

    return SbPage.form(
      title: l10n.titleFootingDesign,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionNext,
            icon: Icons.analytics_outlined,
            onPressed: _onNext,
          ),
          const SizedBox(height: SbSpacing.sm),
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
              '${l10n.labelStep3Geometry} (${state.type.getLocalizedLabel(l10n)})',
              style: theme.textTheme.titleLarge!,
            ),
          ),

          // ── COLUMN DIMENSIONS ──
          SbSection(
            title: l10n.labelColumn,
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SbInput(
                          label: l10n.labelColumnAUnit,
                          controller: _colAController,
                        ),
                      ),
                      const SizedBox(width: SbSpacing.lg),
                      Expanded(
                        child: SbInput(
                          label: l10n.labelColumnBUnit,
                          controller: _colBController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SbSpacing.sm),
                  Text(
                    l10n.msgCriticalShearBending,
                    style: theme.textTheme.labelMedium!,
                  ),
                ],
              ),
            ),
          ),

          // ── FOOTING DIMENSIONS ──
          SbSection(
            title: l10n.labelDimensions,
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SbInput(
                          label: l10n.labelLengthLUnit,
                          controller: _lengthController,
                        ),
                      ),
                      const SizedBox(width: SbSpacing.lg),
                      Expanded(
                        child: SbInput(
                          label: l10n.labelWidthBUnit,
                          controller: _widthController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  SbInput(
                    label: l10n.labelThicknessDUnit,
                    controller: _thicknessController,
                    suffixIcon: const Icon(SbIcons.layers),
                  ),
                  if (state.type == FootingType.combined ||
                      state.type == FootingType.strap) ...[
                    const SizedBox(height: SbSpacing.lg),
                    SbInput(
                      label: l10n.labelColumnSpacingUnit,
                      controller: _spacingController,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── INFORMATION CARD ──
          SbSection(
            child: SbCard(
              color: colorScheme.primary.withValues(alpha: 0.05),
              child: Row(
                children: [
                  Icon(SbIcons.info, color: colorScheme.primary, size: 20),
                  const SizedBox(width: SbSpacing.lg),
                  Expanded(
                    child: Text(
                      l10n.msgFootingAreaCapture(
                        state.type.getLocalizedLabel(l10n),
                        state.requiredArea.toStringAsFixed(2),
                      ),
                      style: theme.textTheme.labelMedium!,
                    ),
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









