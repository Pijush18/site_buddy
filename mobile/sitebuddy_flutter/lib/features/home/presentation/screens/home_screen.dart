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
/// PURPOSE: Pure content composition for the dashboard.
/// Rule: Order-locked sections using only authorized widgets.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(homeProvider).recentActivities;

    return SbPage.detail(
      title: AppStrings.appName,
      appBarActions: [
        IconButton(
          icon: const Icon(SbIcons.settings),
          onPressed: () => context.push('/settings'),
        ),
      ],
      body: Column(
        children: [
          // ── SECTION 1: SMART ASSISTANT HERO ──
          const SbSection(
            title: '',
            child: SbSmartAssistantCard(),
          ),

          // ── SECTION 2: FIELD TOOLS ──
          SbSection(
            title: AppStrings.fieldTools,
            child: SbGrid(
              children: [
                SbActionTile(
                  icon: SbIcons.ruler,
                  label: 'Level Calculator',
                  onTap: () => debugPrint('Level Calculator tapped'),
                  isVibrant: true,
                ),
                SbActionTile(
                  icon: SbIcons.trendingUp,
                  label: 'Gradient Tool',
                  onTap: () => debugPrint('Gradient Tool tapped'),
                  isVibrant: true,
                ),
                SbActionTile(
                  icon: SbIcons.sync,
                  label: AppStrings.unitConverter,
                  onTap: () => debugPrint('Unit Converter tapped'),
                  isVibrant: true,
                ),
                SbActionTile(
                  icon: SbIcons.currencyExchange,
                  label: AppStrings.currencyConverter,
                  onTap: () => debugPrint('Currency Converter tapped'),
                  isVibrant: true,
                ),
              ],
            ),
          ),

          // ── SECTION 3: QUICK ACTIONS ──
          SbSection(
            title: AppStrings.quickActions,
            child: SbGrid(
              childAspectRatio: 2.5,
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
            trailing: IconButton(
              icon: const Icon(SbIcons.chevronRight),
              onPressed: () => context.push('/projects'),
            ),
            child: Column(
              children: activities.map((activity) {
                return SbListItemTile(
                  title: activity.title,
                  subtitle: activity.subtitle,
                  icon: _getActivityIcon(activity.type),
                  trailing: _formatTimestamp(activity.timestamp),
                  onTap: () => debugPrint('Tapped activity: ${activity.title}'),
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

  /// HELPER: Timestamp Formatting
  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM dd').format(timestamp);
  }
}
