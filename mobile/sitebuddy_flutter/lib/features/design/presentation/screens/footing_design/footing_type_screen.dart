
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/shared/domain/models/design/footing_type.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/footing_card.dart';

/// SCREEN: FootingTypeScreen
/// PURPOSE: Grid selection for Footing variety (Step 1).
class FootingTypeScreen extends ConsumerWidget {
  const FootingTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SbPage.form(
      title: 'Footing Design',
      primaryAction: GhostButton(
        label: 'Back',
        onPressed: () => context.pop(),
        width: double.infinity,
      ),
      body: SbSectionList(
        sections: [
          // ── STEP HEADER ──
          SbSection(
            child: Text(
              'Step 1 of 6: Foundation Type',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── SELECTION GRID ──
          SbSection(
            title: 'Select Foundation Type',
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
                  title: type.label,
                  description: type.description,
                  icon: _getIcon(type),
                  onTap: () {
                    ref
                        .read(footingDesignControllerProvider.notifier)
                        .updateType(type);
                    context.push('/footing/soil-load');
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









