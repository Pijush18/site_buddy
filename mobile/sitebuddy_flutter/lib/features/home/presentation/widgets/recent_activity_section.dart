
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/home/application/controllers/home_controller.dart';
import 'package:site_buddy/features/home/presentation/widgets/activity_tile.dart';

/// WIDGET: RecentActivitySection
/// PURPOSE: Renders the list of recent history items on the home screen.
class RecentActivitySection extends ConsumerWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    if (state.recentActivities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (int i = 0; i < state.recentActivities.length; i++) ...[
          ActivityTile(activity: state.recentActivities[i]),
          if (i < state.recentActivities.length - 1)
            const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
