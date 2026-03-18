import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

class SbHomeQuickActions extends StatelessWidget {
  const SbHomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return SbSection(
      title: AppStrings.quickActions,
      child: Row(
        children: [
          Expanded(
            child: SbActionTile(
              icon: SbIcons.addCircle,
              label: AppStrings.newProject,
              onTap: () => context.push('/projects/create'),
              isVibrant: true,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SbActionTile(
              icon: SbIcons.iosShare,
              label: AppStrings.shareReport,
              onTap: () => context.push('/reports'),
              color: Theme.of(context).colorScheme.secondary,
              isVibrant: true,
            ),
          ),
        ],
      ),
    );
  }
}
