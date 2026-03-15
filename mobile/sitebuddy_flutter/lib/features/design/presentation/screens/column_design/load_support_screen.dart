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
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

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

    return SbPage.detail(
      title: 'Load & Support',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 2 of 6: Loading Conditions',
            style: SbTextStyles.caption(context).copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          AppLayout.vGap24,
          SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Axial Loading',
                    style: SbTextStyles.body(context),
                  ),
                  AppLayout.vGap16,
                  AppNumberField(
                    label: 'Factored Load Pu (kN)',
                    controller: _loadController,
                    onChanged: (v) {
                      final val = double.tryParse(v);
                      if (val != null) notifier.updateLoads(pu: val);
                    },
                    suffixIcon: SbIcons.arrowDown,
                  ),
                  AppLayout.vGap16,
                  Text(
                    'End Support Condition',
                    style: SbTextStyles.caption(context),
                  ),
                  AppLayout.vGap8,
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
          AppLayout.vGap32,
          ActionButtonsGroup(
            children: [
              SbButton.primary(
                label: 'Next: Slenderness Check',
                onPressed: _onNext,
                icon: SbIcons.analytics,
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
