import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';

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
    final l10n = context.l10n;
    final state = ref.watch(columnDesignControllerProvider);
    final notifier = ref.read(columnDesignControllerProvider.notifier);

    return SbPage.form(
      title: l10n.titleColumn,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionNext,
            onPressed: _onNext,
            icon: Icons.analytics_outlined,
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
              l10n.labelStep2Loads,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── LOADING SECTION ──
          SbSection(
            title: l10n.labelVerticalLoads,
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SbInput(
                    label: l10n.labelAxialLoadPuUnit,
                    controller: _loadController,
                    onChanged: (v) {
                      final val = double.tryParse(v);
                      if (val != null) notifier.updateLoads(pu: val);
                    },
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  Text(
                    l10n.labelEndSupportCondition,
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








