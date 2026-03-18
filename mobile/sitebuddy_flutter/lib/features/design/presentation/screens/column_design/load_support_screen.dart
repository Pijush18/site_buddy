import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';

/// SCREEN: LoadSupportScreen
/// PURPOSE: Load definition and end conditions (Step 2).
class LoadSupportScreen extends ConsumerStatefulWidget {
  const LoadSupportScreen({super.key});

  @override
  ConsumerState<LoadSupportScreen> createState() => _LoadSupportScreenState();
}

class _LoadSupportScreenState extends ConsumerState<LoadSupportScreen> {
  late final TextEditingController _loadController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(columnDesignControllerProvider);
    _loadController = TextEditingController(text: state.pu.toString());
  }

  @override
  void dispose() {
    _loadController.dispose();
    super.dispose();
  }

  void _onNext() {
    final pu = double.tryParse(_loadController.text) ?? 1000.0;
    ref.read(columnDesignControllerProvider.notifier).updateLoads(pu: pu);
    context.push('/column/slenderness');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(columnDesignControllerProvider);
    final notifier = ref.read(columnDesignControllerProvider.notifier);

    return AppScreenWrapper(
      title: 'Load & Support',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 2 of 6: Loading Conditions',
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SbCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Axial Loading',
                  style: TextStyle(
                    fontSize: AppFontSizes.subtitle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                AppNumberField(
                  label: 'Factored Load Pu (kN)',
                  controller: _loadController,
                  onChanged: (v) {
                    final val = double.tryParse(v);
                    if (val != null) notifier.updateLoads(pu: val);
                  },
                  suffixIcon: Icons.arrow_downward,
                ),
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                const Text(
                  'End Support Condition',
                  style: TextStyle(
                    fontSize: AppFontSizes.tab,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
                SbDropdown<EndCondition>(
                  value: state.endCondition,
                  items: EndCondition.values,
                  itemLabelBuilder: (c) => c.label,
                  onChanged: (v) => v != null
                      ? notifier.updateInput(endCondition: v)
                      : null,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Slenderness Check',
                onPressed: _onNext,
                icon: Icons.analytics_outlined,
                width: double.infinity,
              ),
              const SizedBox(height: AppSpacing.sm),
              SbButton.secondary(
                label: 'Back',
                onPressed: () => context.pop(),
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
