import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/shared/domain/models/design/footing_type.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/footing_card.dart';
import 'package:site_buddy/features/design/presentation/extensions/footing_type_l10n.dart';

/// SCREEN: FootingTypeScreen
/// PURPOSE: Grid selection for Footing variety (Step 1).
class FootingTypeScreen extends ConsumerWidget {
  const FootingTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    
    return SbPage.form(
      title: l10n.titleFootingDesign,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: '${l10n.actionNext}: Soil & Load',
            icon: Icons.navigate_next,
            onPressed: () {
              context.push('/footing/soil-load');
            },
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
              l10n.labelStep1FoundationType,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── SELECTION GRID ──
          SbSection(
            title: l10n.labelSelectFoundationType,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: SbSpacing.lg,
                mainAxisSpacing: SbSpacing.lg,
                childAspectRatio: 0.95,
              ),
              itemCount: FootingType.values.length,
              itemBuilder: (context, index) {
                final type = FootingType.values[index];
                return FootingCard(
                  title: type.getLocalizedLabel(l10n),
                  description: type.getLocalizedDescription(l10n),
                  icon: _getIcon(type),
                  onTap: () {
                    ref
                        .read(footingDesignControllerProvider.notifier)
                        .updateType(type);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(FootingType type) {
    switch (type) {
      case FootingType.isolated:
        return Icons.foundation;
      case FootingType.combined:
        return Icons.grid_view;
      case FootingType.strap:
        return Icons.link;
      case FootingType.strip:
        return Icons.view_headline;
      case FootingType.raft:
        return Icons.layers;
      case FootingType.pile:
        return Icons.vertical_align_bottom;
    }
  }
}









