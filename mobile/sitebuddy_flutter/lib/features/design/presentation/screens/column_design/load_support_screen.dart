
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';

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

    return SbPage.form(
      title: 'Column',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: 'Next',
            onPressed: _onNext,
            icon: Icons.analytics_outlined,
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

          // ── LOADING SECTION ──
          SbSection(
            title: 'Vertical Loads',
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SbInput(
                    label: 'Axial Load (Pu) (kN)',
                    controller: _loadController,
                    onChanged: (v) {
                      final val = double.tryParse(v);
                      if (val != null) notifier.updateLoads(pu: val);
                    },
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  Text(
                    'End Support Condition',
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  const SizedBox(height: SbSpacing.sm),
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
          ),
        ],
      ),
    );
  }
}








