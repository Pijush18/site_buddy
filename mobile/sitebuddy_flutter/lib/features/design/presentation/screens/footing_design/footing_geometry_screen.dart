import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';

import 'package:site_buddy/shared/domain/models/design/footing_type.dart';
// import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(footingDesignControllerProvider);

    return SbPage.detail(
      title: 'Geometry & Sizing',
      appBarActions: [
        SbButton.icon(
          icon: SbIcons.help,
          onPressed: () => debugPrint('Help: Footing Geometry'),
        ),
        AppLayout.hGap8,
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 3 of 6: Dimensioning (${state.type.label})',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
            ),
          ),
          AppLayout.vGap24,

          // Column Geometry Card
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Column Dimensions', style: SbTextStyles.title(context)),
                AppLayout.vGap16,
                Row(
                  children: [
                    Expanded(
                      child: AppNumberField(
                        label: 'Column A (mm)',
                        controller: _colAController,
                      ),
                    ),
                    AppLayout.hGap16,
                    Expanded(
                      child: AppNumberField(
                        label: 'Column B (mm)',
                        controller: _colBController,
                      ),
                    ),
                  ],
                ),
                AppLayout.vGap8,
                Text(
                  'Critical for shear and bending calculations at face.',
                  style: SbTextStyles.caption(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppLayout.vGap16,

          // Main Geometry Card
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Footing Dimensions', style: SbTextStyles.title(context)),
                AppLayout.vGap16,
                Row(
                  children: [
                    Expanded(
                      child: AppNumberField(
                        label: 'Length (L) (mm)',
                        controller: _lengthController,
                      ),
                    ),
                    AppLayout.hGap16,
                    Expanded(
                      child: AppNumberField(
                        label: 'Width (B) (mm)',
                        controller: _widthController,
                      ),
                    ),
                  ],
                ),
                AppLayout.vGap16,
                AppNumberField(
                  label: 'Overall Thickness (D) (mm)',
                  controller: _thicknessController,
                  suffixIcon: SbIcons.layers,
                ),
                if (state.type == FootingType.combined ||
                    state.type == FootingType.strap) ...[
                  AppLayout.vGap16,
                  AppNumberField(
                    label: 'Column C/C Spacing (mm)',
                    controller: _spacingController,
                  ),
                ],
              ],
            ),
          ),
          AppLayout.vGap16,

          // Information Card
          SbCard(
            color: colorScheme.primary.withValues(alpha: 0.05),
            child: Row(
              children: [
                Icon(SbIcons.info, color: colorScheme.primary, size: 20),
                AppLayout.hGap16,
                Expanded(
                  child: Text(
                    'For ${state.type.label}, ensure dimensions capture the full required bearing area of ${(state.requiredArea).toStringAsFixed(2)} m².',
                    style: SbTextStyles.caption(context).copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppLayout.vGap32,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Soil Analysis',
                icon: SbIcons.analytics,
                onPressed: _onNext,
              ),
              AppLayout.vGap12,
              SbButton.outline(
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
