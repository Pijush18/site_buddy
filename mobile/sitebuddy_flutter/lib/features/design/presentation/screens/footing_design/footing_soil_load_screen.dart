import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';

import 'package:site_buddy/shared/domain/models/design/footing_type.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

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

    return SbPage.detail(
      title: 'Soil & Load',
      appBarActions: [
        SbButton.icon(
          icon: SbIcons.help,
          onPressed: () => debugPrint('Help: Footing Soil & Load'),
        ),
        AppLayout.hGap8,
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 2 of 6: Parameters',
            style: SbTextStyles.caption(context).copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          AppLayout.vGap24,
          // Column Load Card
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  state.type == FootingType.combined ||
                          state.type == FootingType.strap
                      ? 'Column 1 Loadings'
                      : 'Column Loadings',
                  style: SbTextStyles.body(context),
                ),
                AppLayout.vGap16,
                AppNumberField(
                  label: 'Axial Load (P1) (kN)',
                  controller: _loadController,
                  suffixIcon: SbIcons.arrowDown,
                ),
                AppLayout.vGap12,
                Row(
                  children: [
                    Expanded(
                      child: AppNumberField(
                        label: 'Mx1 (kNm)',
                        controller: _mxController,
                      ),
                    ),
                    AppLayout.hGap12,
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
                  AppLayout.vGap24,
                  Divider(color: Theme.of(context).colorScheme.outlineVariant),
                  AppLayout.vGap24,
                  Text(
                    'Column 2 Loadings',
                    style: SbTextStyles.body(context),
                  ),
                  AppLayout.vGap16,
                  AppNumberField(
                    label: 'Axial Load (P2) (kN)',
                    controller: _load2Controller,
                  ),
                  AppLayout.vGap24,
                  Row(
                    children: [
                      Expanded(
                        child: AppNumberField(
                          label: 'Mx2 (kNm)',
                          controller: _mx2Controller,
                        ),
                      ),
                      AppLayout.hGap12,
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
          AppLayout.vGap12,
          // Soil Parameters Card
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Soil Properties',
                  style: SbTextStyles.body(context),
                ),
                AppLayout.vGap16,
                AppNumberField(
                  label: 'Safe Bearing Capacity (SBC) (kN/m²)',
                  controller: _sbcController,
                  suffixIcon: SbIcons.terrain,
                ),
                AppLayout.vGap12,
                AppNumberField(
                  label: 'Foundation Depth (m)',
                  controller: _depthController,
                  suffixIcon: SbIcons.arrowDown,
                ),
              ],
            ),
          ),

          AppLayout.vGap32,
          ActionButtonsGroup(
            children: [
              SbButton.primary(
                label: 'Next: Geometry Design',
                icon: SbIcons.area,
                onPressed: _onNext,
              ),
              SbButton.primary(
                label: 'Back',
                onPressed: () => context.pop(),
              ),
            ],
          ),
          AppLayout.vGap24,
        ],
      ),
    );
  }
}
