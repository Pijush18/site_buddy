import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';

import 'package:site_buddy/shared/domain/models/design/footing_type.dart';

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

    return AppScreenWrapper(
      title: 'Geometry & Sizing',
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => debugPrint('Help: Footing Geometry'),
        ),
        const SizedBox(width: SbSpacing.sm),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 3 of 6: Dimensioning (${state.type.label})',
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24

          // Column Geometry Card
          const SbSectionHeader(title: 'Column Dimensions'),
          SbCard(
            padding: const EdgeInsets.all(SbSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppNumberField(
                        label: 'Column A (mm)',
                        controller: _colAController,
                      ),
                    ),
                    const SizedBox(width: SbSpacing.lg), // Replaced const SizedBox(width: SbSpacing.lg)
                    Expanded(
                      child: AppNumberField(
                        label: 'Column B (mm)',
                        controller: _colBController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
                Text(
                  'Critical for shear and bending calculations at face.',
                  style: Theme.of(context).textTheme.labelMedium!,
                ),
              ],
            ),
          ),
          const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)

          // Main Geometry Card
          const SbSectionHeader(title: 'Footing Dimensions'),
          SbCard(
            padding: const EdgeInsets.all(SbSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppNumberField(
                        label: 'Length (L) (mm)',
                        controller: _lengthController,
                      ),
                    ),
                    const SizedBox(width: SbSpacing.lg), // Replaced const SizedBox(width: SbSpacing.lg)
                    Expanded(
                      child: AppNumberField(
                        label: 'Width (B) (mm)',
                        controller: _widthController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)
                AppNumberField(
                  label: 'Overall Thickness (D) (mm)',
                  controller: _thicknessController,
                  suffixIcon: SbIcons.layers,
                ),
                if (state.type == FootingType.combined ||
                    state.type == FootingType.strap) ...[
                  const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)
                  AppNumberField(
                    label: 'Column C/C Spacing (mm)',
                    controller: _spacingController,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)

          // Information Card
          SbCard(
            color: colorScheme.primary.withValues(alpha: 0.05),
            padding: const EdgeInsets.all(SbSpacing.lg),
            child: Row(
              children: [
                Icon(SbIcons.info, color: colorScheme.primary, size: 20),
                const SizedBox(width: SbSpacing.lg), // Replaced const SizedBox(width: SbSpacing.lg)
                Expanded(
                  child: Text(
                    'For ${state.type.label}, ensure dimensions capture the full required bearing area of ${(state.requiredArea).toStringAsFixed(2)} m².',
                      style: Theme.of(context).textTheme.labelMedium!,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap32 (closest standard)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Soil Analysis',
                icon: Icons.analytics_outlined,
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











