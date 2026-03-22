import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/shared/domain/models/design/footing_type.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';

/// SCREEN: FootingSoilLoadScreen
/// PURPOSE: Soil parameters and column loads (Step 2).
class FootingSoilLoadScreen extends ConsumerStatefulWidget {
  const FootingSoilLoadScreen({super.key});

  @override
  ConsumerState<FootingSoilLoadScreen> createState() =>
      _FootingSoilLoadScreenState();
}

class _FootingSoilLoadScreenState extends ConsumerState<FootingSoilLoadScreen> {
  late final TextEditingController _loadController;
  late final TextEditingController _load2Controller;
  late final TextEditingController _mxController;
  late final TextEditingController _myController;
  late final TextEditingController _mx2Controller;
  late final TextEditingController _my2Controller;
  late final TextEditingController _sbcController;
  late final TextEditingController _depthController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(footingDesignControllerProvider);
    _loadController = TextEditingController(text: state.columnLoad.toString());
    _load2Controller = TextEditingController(
      text: state.columnLoad2.toString(),
    );
    _mxController = TextEditingController(text: state.momentX.toString());
    _myController = TextEditingController(text: state.momentY.toString());
    _mx2Controller = TextEditingController(text: state.momentX2.toString());
    _my2Controller = TextEditingController(text: state.momentY2.toString());
    _sbcController = TextEditingController(text: state.sbc.toString());
    _depthController = TextEditingController(
      text: state.foundationDepth.toString(),
    );
  }

  @override
  void dispose() {
    _loadController.dispose();
    _load2Controller.dispose();
    _mxController.dispose();
    _myController.dispose();
    _mx2Controller.dispose();
    _my2Controller.dispose();
    _sbcController.dispose();
    _depthController.dispose();
    super.dispose();
  }

  void _onNext() {
    ref
        .read(footingDesignControllerProvider.notifier)
        .updateSoilLoad(
          columnLoad: double.tryParse(_loadController.text),
          columnLoad2: double.tryParse(_load2Controller.text),
          mx: double.tryParse(_mxController.text),
          my: double.tryParse(_myController.text),
          mx2: double.tryParse(_mx2Controller.text),
          my2: double.tryParse(_my2Controller.text),
          sbc: double.tryParse(_sbcController.text),
          foundationDepth: double.tryParse(_depthController.text),
        );
    context.push('/footing/geometry');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(footingDesignControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return SbPage.form(
      title: 'Footing',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: 'Next',
            icon: Icons.square_foot,
            onPressed: _onNext,
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: 'Back',
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SbSectionList(
        sections: [
          // ── STEP HEADER ──
          SbSection(
            child: Text(
              'Step 2: Loads',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── COLUMN LOADS ──
          SbSection(
            title: state.type == FootingType.combined ||
                    state.type == FootingType.strap
                ? 'Column 1 Loadings'
                : 'Column Loading',
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SbInput(
                    label: 'Axial Load (P1) (kN)',
                    controller: _loadController,
                    suffixIcon: const Icon(SbIcons.arrowDown),
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: SbInput(
                          label: 'Mx1 (kNm)',
                          controller: _mxController,
                        ),
                      ),
                      const SizedBox(width: SbSpacing.lg),
                      Expanded(
                        child: SbInput(
                          label: 'My1 (kNm)',
                          controller: _myController,
                        ),
                      ),
                    ],
                  ),
                  if (state.type == FootingType.combined ||
                      state.type == FootingType.strap) ...[
                    const SizedBox(height: SbSpacing.xxl),
                    Divider(color: colorScheme.outlineVariant),
                    const SizedBox(height: SbSpacing.xxl),
                    Text(
                      'Column 2 Loadings',
                      style: Theme.of(context).textTheme.labelLarge!,
                    ),
                    const SizedBox(height: SbSpacing.lg),
                    SbInput(
                      label: 'Axial Load (P2) (kN)',
                      controller: _load2Controller,
                    ),
                    const SizedBox(height: SbSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: SbInput(
                            label: 'Mx2 (kNm)',
                            controller: _mx2Controller,
                          ),
                        ),
                        const SizedBox(width: SbSpacing.lg),
                        Expanded(
                          child: SbInput(
                            label: 'My2 (kNm)',
                            controller: _my2Controller,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── SOIL PARAMETERS ──
          SbSection(
            title: 'Soil Properties',
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SbInput(
                    label: 'Bearing Capacity (kN/m²)',
                    controller: _sbcController,
                    suffixIcon: const Icon(SbIcons.terrain),
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  SbInput(
                    label: 'Depth (m)',
                    controller: _depthController,
                    suffixIcon: const Icon(SbIcons.arrowDown),
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










