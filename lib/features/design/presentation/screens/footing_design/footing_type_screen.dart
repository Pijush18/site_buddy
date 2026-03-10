import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/design/footing_type.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/footing_card.dart';

/// SCREEN: FootingTypeScreen
/// PURPOSE: Grid selection for Footing variety (Step 1).
class FootingTypeScreen extends ConsumerWidget {
  const FootingTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SbPage.list(
      title: 'Footing Design',

      appBarActions: [
        SbButton.icon(
          icon: SbIcons.share,
          onPressed: () => debugPrint('ACTION: share footing design'),
        ),
        AppLayout.hGap8,
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 1 of 6: Foundation Type',
            style: SbTextStyles.caption(context).copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          AppLayout.vGap24,
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppLayout.pMedium),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppLayout.pMedium,
                mainAxisSpacing: AppLayout.pMedium,
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
          AppLayout.vGap24,
        ],
      ),
    );
  }

  IconData _getIcon(FootingType type) {
    switch (type) {
      case FootingType.isolated:
        return SbIcons.isolatedFooting;
      case FootingType.combined:
        return SbIcons.combinedFooting;
      case FootingType.strap:
        return SbIcons.link;
      case FootingType.strip:
        return SbIcons.level;
      case FootingType.raft:
        return SbIcons.raftFooting;
      case FootingType.pile:
        return SbIcons.pileFooting;
    }
  }
}