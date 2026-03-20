import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';

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

    return AppScreenWrapper(
      title: 'Soil & Load',
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => debugPrint('Help: Footing Soil & Load'),
        ),
        const SizedBox(width: SbSpacing.sm),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 2 of 6: Parameters',
            style: Theme.of(context).textTheme.labelMedium!,
          ),
          const SizedBox(height: SbSpacing.xxl),
          // Column Load Card
          SbSectionHeader(
            title: state.type == FootingType.combined ||
                    state.type == FootingType.strap
                ? 'Column 1 Loadings'
                : 'Column Loadings',
          ),
          SbCard(
            padding: const EdgeInsets.all(SbSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppNumberField(
                  label: 'Axial Load (P1) (kN)',
                  controller: _loadController,
                  suffixIcon: SbIcons.arrowDown,
                ),
                const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.md)
                Row(
                  children: [
                    Expanded(
                      child: AppNumberField(
                        label: 'Mx1 (kNm)',
                        controller: _mxController,
                      ),
                    ),
                    const SizedBox(width: SbSpacing.sm), // Replaced const SizedBox(width: SbSpacing.md)
                    Expanded(
                      child: AppNumberField(
                        label: 'My1 (kNm)',
                        controller: _myController,
                      ),
                    ),
                  ],
                ),

                if (state.type == FootingType.combined ||
                    state.type == FootingType.strap) ...[
                  const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24
                  Divider(color: colorScheme.outlineVariant),
                  const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24
                  Text(
                    'Column 2 Loadings',
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)
                  AppNumberField(
                    label: 'Axial Load (P2) (kN)',
                    controller: _load2Controller,
                  ),
                  const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24
                  Row(
                    children: [
                      Expanded(
                        child: AppNumberField(
                          label: 'Mx2 (kNm)',
                          controller: _mx2Controller,
                        ),
                      ),
                      const SizedBox(width: SbSpacing.sm), // Replaced const SizedBox(width: SbSpacing.md)
                      Expanded(
                        child: AppNumberField(
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
          const SizedBox(height: SbSpacing.sm),
          // Soil Parameters Card
          const SbSectionHeader(title: 'Soil Properties'),
          SbCard(
            padding: const EdgeInsets.all(SbSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppNumberField(
                  label: 'Safe Bearing Capacity (SBC) (kN/m²)',
                  controller: _sbcController,
                  suffixIcon: SbIcons.terrain,
                ),
                const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.md)
                AppNumberField(
                  label: 'Foundation Depth (m)',
                  controller: _depthController,
                  suffixIcon: SbIcons.arrowDown,
                ),
              ],
            ),
          ),

          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap32 (closest standard)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Geometry Design',
                icon: Icons.square_foot,
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
          const SizedBox(height: SbSpacing.xxl), // Added for bottom padding consistency
        ],
      ),
    );
  }
}










