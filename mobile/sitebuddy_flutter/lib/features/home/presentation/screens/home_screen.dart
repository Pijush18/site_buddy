import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';
import 'package:site_buddy/features/home/application/controllers/home_controller.dart';
import 'package:site_buddy/features/home/domain/models/activity_type.dart';
import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/features/history/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';

/// SCREEN: HomeScreen
/// PURPOSE: Root dashboard with refined visual rhythm
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(homeProvider).recentActivities;
    final reportsAsync = ref.watch(recentReportsProvider);

    return SbPage.scaffold(
      title: 'SiteBuddy',
      appBarActions: [
        IconButton(
          icon: const Icon(SbIcons.settings),
          onPressed: () => context.push(AppRoutes.settings),
          tooltip: 'Settings',
        ),
      ],
      body: SbSectionList(
        sections: [
          const SbSection(
            padding: EdgeInsets.zero,
            child: SbSmartAssistantCard(),
          ),
          SbSection(
            title: 'Tools',
            subtitle: 'Calculators and survey tools.',
            child: SbGrid(
              children: [
                SBGridActionCard(
                  icon: SbIcons.calculator,
                  label: 'Levels',
                  onTap: () => context.push(AppRoutes.calculator),
                ),
                SBGridActionCard(
                  icon: SbIcons.trendingUp,
                  label: 'Gradient',
                  onTap: () => context.push(AppRoutes.gradientCalc),
                ),
                SBGridActionCard(
                  icon: SbIcons.sync,
                  label: 'Units',
                  onTap: () => context.push(AppRoutes.unitConverter),
                ),
                SBGridActionCard(
                  icon: SbIcons.currencyExchange,
                  label: 'Currency',
                  onTap: () => context.push(AppRoutes.currencyConverter),
                ),
              ],
            ),
          ),
          SbSection(
            title: 'Actions',
            subtitle: 'Site workflows.',
            child: SbGrid(
              children: [
                SBGridActionCard(
                  icon: SbIcons.addCircle,
                  label: 'New Project',
                  onTap: () => context.push(AppRoutes.projectCreate),
                  isHighlighted: true,
                ),
                SBGridActionCard(
                  icon: SbIcons.iosShare,
                  label: 'Report',
                  onTap: () => context.push(AppRoutes.reports),
                  isHighlighted: true,
                ),
              ],
            ),
          ),
          SbSection(
            title: 'Activity',
            subtitle: 'Recent updates.',
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
          SbSection(
            title: 'History',
            subtitle: 'Engineering reports.',
            child: reportsAsync.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: SbSpacing.md),
                    child: Text(
                      'No history yet',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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

  void _navigateToReport(BuildContext context, DesignReport report) {
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

  CalculationType _mapDesignToCalculationType(DesignType type) {
    switch (type) {
      case DesignType.beam: return CalculationType.beam;
      case DesignType.slab: return CalculationType.slab;
      case DesignType.column: return CalculationType.column;
      case DesignType.footing: return CalculationType.footing;
      case DesignType.concrete: return CalculationType.cement;
      case DesignType.steel: return CalculationType.rebar;
      case DesignType.brick: return CalculationType.brick;
      case DesignType.plaster: return CalculationType.plaster;
      case DesignType.excavation: return CalculationType.excavation;
      case DesignType.shuttering: return CalculationType.shuttering;
      case DesignType.siteLeveling: return CalculationType.levelLog;
      case DesignType.siteGradient: return CalculationType.gradient;
      case DesignType.currency: return CalculationType.currencyConverter;
      case DesignType.road: return CalculationType.road;
      case DesignType.irrigation: return CalculationType.irrigation;
    }
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.calculator: return SbIcons.calculator;
      case ActivityType.leveling: return SbIcons.ruler;
      case ActivityType.project: return SbIcons.project;
    }
  }

  IconData _getReportIcon(DesignType type) {
    switch (type) {
      case DesignType.beam:
      case DesignType.slab:
      case DesignType.column:
      case DesignType.footing:
      case DesignType.road:
      case DesignType.irrigation:
        return SbIcons.architecture;
      case DesignType.siteLeveling:
        return SbIcons.ruler;
      case DesignType.concrete:
      case DesignType.steel:
      case DesignType.brick:
      case DesignType.plaster:
      case DesignType.excavation:
      case DesignType.shuttering:
      case DesignType.siteGradient:
      case DesignType.currency:
        return SbIcons.calculator;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM dd').format(timestamp);
  }

  String _formatDetailedTimestamp(DateTime timestamp) {
    return DateFormat('MMM dd, yyyy • HH:mm').format(timestamp);
  }
}
