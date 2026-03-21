import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/features/home/application/controllers/home_controller.dart';
import 'package:site_buddy/features/home/domain/models/activity_type.dart';

/// SCREEN: HomeScreen
/// PURPOSE: Root dashboard with refined visual rhythm
/// RULE: SbPage → SbSectionList → SbSection
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(homeProvider).recentActivities;

    return SbPage.scaffold(
      title: AppStrings.appName,
      appBarActions: [
        IconButton(
          icon: const Icon(SbIcons.settings),
          onPressed: () => context.push('/settings'),
          tooltip: 'Settings',
        ),

      ],

      /// ── LAYOUT SYSTEM ──
      body: SbSectionList(
        sections: [
          // ── SECTION 1: HERO (ENHANCED DOMINANCE) ──
          const SbSection(
            padding: EdgeInsets.zero,
            child: SbSmartAssistantCard(),
          ),



          // ── SECTION 2: FIELD TOOLS ──
          SbSection(
            title: AppStrings.fieldTools,
            subtitle: 'Essential calculators and survey tools for on-site use.',
            child: SbGrid(
              children: [
                SBGridActionCard(
                  icon: SbIcons.calculator,
                  label: AppStrings.levelCalculator,
                  onTap: () => context.push('/tools/calculator'),
                ),
                SBGridActionCard(
                  icon: SbIcons.trendingUp,
                  label: AppStrings.gradientTool,
                  onTap: () => context.push('/tools/gradient'),
                ),
                SBGridActionCard(
                  icon: SbIcons.sync,
                  label: AppStrings.unitConverter,
                  onTap: () => context.push('/tools/converter'),
                ),
                SBGridActionCard(
                  icon: SbIcons.currencyExchange,
                  label: AppStrings.currencyConverter,
                  onTap: () => context.push('/tools/currency'),
                ),
              ],
            ),
          ),


          // ── SECTION 3: QUICK ACTIONS (HIGHLIGHTED) ──
          SbSection(
            title: AppStrings.quickActions,
            subtitle: 'Common site management workflows.',
            child: SbGrid(
              children: [
                SBGridActionCard(
                  icon: SbIcons.addCircle,
                  label: AppStrings.newProject,
                  onTap: () => context.push('/projects/create'),
                  isHighlighted: true,
                ),
                SBGridActionCard(
                  icon: SbIcons.iosShare,
                  label: AppStrings.shareReport,
                  onTap: () => context.push('/reports'),
                  isHighlighted: true,
                ),
              ],
            ),
          ),


          // ── SECTION 4: RECENT ACTIVITY (SUBTLE) ──
          SbSection(
            title: AppStrings.recentActivity,
            subtitle: 'Your most recent project updates and calculations.',
            onTap: () => context.push('/projects'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: SbSpacing.sm),
                SbListGroup(
                  isSubtle: true,
                  children: activities.map((activity) {
                    return SbListItemTile(
                      title: activity.title,
                      subtitle: activity.subtitle,
                      icon: _getActivityIcon(activity.type),
                      trailing: _formatTimestamp(activity.timestamp),
                      onTap: () => context.push('/projects/${activity.title}'),
                      isSubtle: true,
                    );
                  }).toList(),
                ),
              ],
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

  /// HELPER: Date Formatting
  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM dd').format(timestamp);
  }
}
