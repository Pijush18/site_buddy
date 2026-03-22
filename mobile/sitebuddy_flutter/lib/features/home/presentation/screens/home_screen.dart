import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';
import 'package:site_buddy/features/home/application/controllers/home_controller.dart';
import 'package:site_buddy/features/home/domain/models/activity_type.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';

/// SCREEN: HomeScreen
/// PURPOSE: Root dashboard with refined visual rhythm
/// RULE: SbPage → SbSectionList → SbSection
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(homeProvider).recentActivities;
    final reportsAsync = ref.watch(recentReportsProvider);

    return SbPage.scaffold(
      title: AppStrings.appName,
      appBarActions: [
        IconButton(
          icon: const Icon(SbIcons.settings),
          onPressed: () => context.push(AppRoutes.settings),
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
                  onTap: () => context.push(AppRoutes.calculator),
                ),
                SBGridActionCard(
                  icon: SbIcons.trendingUp,
                  label: AppStrings.gradientTool,
                  onTap: () => context.push(AppRoutes.gradientCalc),
                ),
                SBGridActionCard(
                  icon: SbIcons.sync,
                  label: AppStrings.unitConverter,
                  onTap: () => context.push(AppRoutes.unitConverter),
                ),
                SBGridActionCard(
                  icon: SbIcons.currencyExchange,
                  label: AppStrings.currencyConverter,
                  onTap: () => context.push(AppRoutes.currencyConverter),
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
                  onTap: () => context.push(AppRoutes.projectCreate),
                  isHighlighted: true,
                ),
                SBGridActionCard(
                  icon: SbIcons.iosShare,
                  label: AppStrings.shareReport,
                  onTap: () => context.push(AppRoutes.reports),
                  isHighlighted: true,
                ),
              ],
            ),
          ),

          // ── SECTION 4: RECENT ACTIVITY (SUBTLE) ──
          SbSection(
            title: AppStrings.recentActivity,
            subtitle: 'Your most recent project updates and calculations.',
            onTap: () => context.push(AppRoutes.projects),
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
                      onTap: () => context.push(AppRoutes.projectDetail()),
                      isSubtle: true,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // ── SECTION 5: CALCULATION HISTORY (NEW) ──
          SbSection(
            title: 'Calculation History',
            subtitle:
                'Standardized engineering reports and calculation outputs.',
            child: reportsAsync.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: SbSpacing.md),
                    child: Text(
                      'No history yet',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withOpacity(0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    const SizedBox(height: SbSpacing.sm),
                    SbListGroup(
                      isSubtle: true,
                      children: reports.map((report) {
                        return SbListItemTile(
                          title: report.typeLabel,
                          subtitle: _formatDetailedTimestamp(report.timestamp),
                          icon: _getReportIcon(report.designType),
                          onTap: () => _navigateToReport(context, report),
                          isSubtle: true,
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(SbSpacing.lg),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  /// HELPER: Navigation to Report Detail
  void _navigateToReport(BuildContext context, DesignReport report) {
    // Audit Fix: Reuse the existing HistoryDetailScreen flow by passing the required entry
    // Note: projectId is now a required field in DesignReport, no fallback needed
    final entry = CalculationHistoryEntry(
      id: report.id,
      projectId: report.projectId,
      calculationType: _mapDesignToCalculationType(report.designType),
      timestamp: report.timestamp,
      inputParameters: report.inputs,
      resultSummary: report.summary,
      resultData: report.results,
    );

    context.push(AppRoutes.historyDetail, extra: entry);
  }

  /// HELPER: Internal Mapper for Navigation Fallback
  CalculationType _mapDesignToCalculationType(DesignType type) {
    switch (type) {
      case DesignType.beam:
        return CalculationType.beam;
      case DesignType.slab:
        return CalculationType.slab;
      case DesignType.column:
        return CalculationType.column;
      case DesignType.footing:
        return CalculationType.footing;
      case DesignType.cement:
        return CalculationType.cement;
      case DesignType.rebar:
        return CalculationType.rebar;
      case DesignType.brick:
        return CalculationType.brick;
      case DesignType.plaster:
        return CalculationType.plaster;
      case DesignType.excavation:
        return CalculationType.excavation;
      case DesignType.shuttering:
        return CalculationType.shuttering;
      case DesignType.sand:
        return CalculationType.sand;
      case DesignType.levelLog:
        return CalculationType.levelLog;
      case DesignType.gradient:
        return CalculationType.gradient;
      case DesignType.unitConverter:
        return CalculationType.unitConverter;
      case DesignType.currencyConverter:
        return CalculationType.currencyConverter;
    }
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

  /// HELPER: Report Icon Mapping
  IconData _getReportIcon(DesignType type) {
    switch (type) {
      case DesignType.beam:
      case DesignType.slab:
      case DesignType.column:
      case DesignType.footing:
        return SbIcons.architecture;
      case DesignType.levelLog:
        return SbIcons.ruler;
      case DesignType.sand:
      case DesignType.gradient:
      case DesignType.unitConverter:
      case DesignType.currencyConverter:
        return SbIcons.calculator;
      default:
        return SbIcons.calculator;
    }
  }

  /// HELPER: Date Formatting
  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM dd').format(timestamp);
  }

  String _formatDetailedTimestamp(DateTime timestamp) {
    return DateFormat('MMM dd, yyyy • HH:mm').format(timestamp);
  }
}
