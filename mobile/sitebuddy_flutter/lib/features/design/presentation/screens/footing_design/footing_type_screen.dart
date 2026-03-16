import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/components/sb_button.dart';

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
    return AppScreenWrapper(
      title: 'Footing Design',
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () => debugPrint('ACTION: share footing design'),
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 1 of 6: Foundation Type',
            style: TextStyle(
              fontSize: AppFontSizes.tab, // Replaced SbTextStyles.caption
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md), // Replaced AppLayout.pMedium
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md, // Replaced AppLayout.pMedium
              mainAxisSpacing: AppSpacing.md, // Replaced AppLayout.pMedium
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
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          SBButton.secondary(
            label: 'Back',
            onPressed: () => context.pop(),
            fullWidth: true,
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
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