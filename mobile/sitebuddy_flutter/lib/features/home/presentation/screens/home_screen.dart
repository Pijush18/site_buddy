import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/home/application/controllers/home_controller.dart';
import 'package:site_buddy/features/home/domain/models/activity_type.dart';

/// SCREEN: HomeScreen
/// PURPOSE: Root dashboard implementation following the Predefined Layout System.
/// RULE: AppScreenWrapper → SbSectionList → SbSection.
/// RULE: No direct Columns, no manual SizedBox heights between sections.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(homeProvider).recentActivities;

    return AppScreenWrapper(
      title: AppStrings.appName,
      actions: [
        SbButton.icon(
          icon: SbIcons.settings,
          onPressed: () => context.push('/settings'),
          tooltip: 'Settings',
        ),
      ],
      // ── PREDEFINED LAYOUT SYSTEM ──
      // SbSectionList centralizes the 24px gap between children.
      child: SbSectionList(
        sections: [
          // ── SECTION 1: SMART ASSISTANT HERO ──
          const SbSection(
            title: null,
            child: SbSmartAssistantCard(),
          ),

          // ── SECTION 2: FIELD TOOLS ──
          SbSection(
            title: AppStrings.fieldTools,
            child: SbGrid(
              children: [
                SbActionTile(
                  icon: SbIcons.calculator,
                  label: AppStrings.levelCalculator,
                  onTap: () => context.push('/tools/calculator'),
                ),
                SbActionTile(
                  icon: SbIcons.trendingUp,
                  label: AppStrings.gradientTool,
                  onTap: () => context.push('/tools/gradient'),
                ),
                SbActionTile(
                  icon: SbIcons.sync,
                  label: AppStrings.unitConverter,
                  onTap: () => context.push('/tools/converter'),
                ),
                SbActionTile(
                  icon: SbIcons.currencyExchange,
                  label: AppStrings.currencyConverter,
                  onTap: () => context.push('/tools/currency'),
                ),
              ],
            ),
          ),

          // ── SECTION 3: QUICK ACTIONS ──
          SbSection(
            title: AppStrings.quickActions,
            child: SbGrid(
              children: [
                SbActionTile(
                  icon: SbIcons.addCircle,
                  label: AppStrings.newProject,
                  onTap: () => context.push('/projects/create'),
                ),
                SbActionTile(
                  icon: SbIcons.iosShare,
                  label: AppStrings.shareReport,
                  onTap: () => context.push('/reports'),
                ),
              ],
            ),
          ),

          // ── SECTION 4: RECENT ACTIVITY ──
          SbSection(
            title: AppStrings.recentActivity,
            onTap: () => context.push('/projects'),
            child: SbListGroup(
              children: activities.map((activity) {
                return SbListItemTile(
                  title: activity.title,
                  subtitle: activity.subtitle,
                  icon: _getActivityIcon(activity.type),
                  trailing: _formatTimestamp(activity.timestamp),
                  onTap: () => context.push('/projects/${activity.title}'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// HELPER: Activity Icon Mapping
  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.calculator:
        return SbIcons.calculator;
      case ActivityType.leveling:
        return SbIcons.ruler;
      case ActivityType.project:
        return SbIcons.project;
    }
  }

  /// HELPER: DateTime Formatting
  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM dd').format(timestamp);
  }
}



