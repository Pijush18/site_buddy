import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';
import 'package:site_buddy/features/project/presentation/controllers/project_detail_controller.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';

/// CLASS: ProjectDetailScreen
/// PURPOSE: Deep-dive view into a specific project.
class ProjectDetailScreen extends ConsumerWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    /// Fetch project using projectId from route
    final proj = ref
        .read(projectControllerProvider.notifier)
        .getProjectById(projectId);

    if (proj == null) {
      return const AppScreenWrapper(
        title: ScreenTitles.projectNotFound,
        child: Center(child: Text(AppStrings.projectNotFoundDesc)),
      );
    }

    final detailState = ref.watch(projectDetailControllerProvider(projectId));
    final calculations = detailState.calculations;
    final columns = calculations['columns'] as List;
    final beams = calculations['beams'] as List;
    final slabs = calculations['slabs'] as List;
    final footings = calculations['footings'] as List;

    final calcItems = [
      ...columns.map(
        (c) => {
          'type': 'column',
          'name': 'Column Design',
          'date': DateTime.now(),
        },
      ),
      ...beams.map(
        (b) => {'type': 'beam', 'name': 'Beam Design', 'date': DateTime.now()},
      ),
      ...slabs.map(
        (s) => {'type': 'slab', 'name': 'Slab Design', 'date': DateTime.now()},
      ),
      ...footings.map(
        (f) => {
          'type': 'footing',
          'name': 'Footing Design',
          'date': DateTime.now(),
        },
      ),
    ];

    final logItems = detailState.logs;
    final formattedDate = DateFormat('dd MMM yyyy').format(proj.createdAt);

    return AppScreenWrapper(
      title: proj.name,
      actions: [
        Consumer(
          builder: (context, ref, _) {
            final isOnline = ref.watch(connectivityProvider).value ?? true;
            return Container(
              margin: const EdgeInsets.only(right: AppSpacing.md), // Replaced AppLayout.md
              child: Icon(
                isOnline ? SbIcons.checkFilled : SbIcons.warning,
                size: 16,
                color: isOnline ? Colors.green : Colors.orange,
              ),
            );
          },
        ),
      ],
      child: Column(
        children: [
          // Status Header
          SbCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.status,
                      style: TextStyle(
                        fontSize: AppFontSizes.tab,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, // 16
                        vertical: AppSpacing.sm / 2, // Replaced AppLayout.xs (4)
                      ),
                      child: Text(
                        proj.status.label,
                        style: TextStyle(
                          fontSize: AppFontSizes.tab,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                Text(
                  proj.name,
                  style: const TextStyle(
                    fontSize: AppFontSizes.title,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                // Cover Image Mock
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Center(
                    child: Icon(
                      SbIcons.terrain,
                      size: 48,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.created,
                          style: TextStyle(
                            fontSize: AppFontSizes.tab,
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: AppFontSizes.subtitle),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppStrings.location,
                          style: TextStyle(
                            fontSize: AppFontSizes.tab,
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              SbIcons.location,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.sm), // Replaced AppLayout.hGap8
                            Text(
                              proj.location,
                              style: const TextStyle(fontSize: AppFontSizes.subtitle),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          // Description block if available
          if (proj.description != null && proj.description!.isNotEmpty) ...[
            SbSection(
              title: AppStrings.description,
              child: SbCard(
                child: Text(
                  proj.description!,
                  style: const TextStyle(
                    fontSize: AppFontSizes.subtitle,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.description,
                  label: 'LOGS',
                  value: proj.logsCount.toString(),
                  subtext: 'Entries',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  icon: Icons.calculate,
                  label: 'CALCS',
                  value: proj.calculationsCount.toString(),
                  subtext: 'Saved Runs',
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          SbSection(
            title: AppStrings.design,
            child: calcItems.isEmpty
                ? const SbCard(
                    child: Text(AppStrings.noEntriesFound),
                  )
                : Column(
                    children: calcItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SbListItemTile(
                          icon: _getTypeIcon(item['type'] as String),
                          title: item['name'] as String,
                          subtitle: DateFormat(
                            'dd MMM, hh:mm a',
                          ).format(item['date'] as DateTime),
                          onTap: () {
                            context.push('/projects/$projectId/history');
                          },
                        ),
                      );
                    }).toList(),
                  ),
          ),

          const SizedBox(height: AppSpacing.md),
          SbSection(
            title: AppStrings.fieldSurveying,
            child: logItems.isEmpty
                ? const SbCard(
                    child: Text(AppStrings.noEntriesFound),
                  )
                : Column(
                    children: logItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SbListItemTile(
                          icon: SbIcons.layers,
                          iconColor: colorScheme.secondary,
                          title: item.name,
                          subtitle:
                              '${item.method.name} • ${DateFormat('dd MMM, hh:mm a').format(item.date)}',
                          onTap: () {
                            context.push('/projects/$projectId/level-log');
                          },
                        ),
                      );
                    }).toList(),
                  ),
          ),

          SbSection(
            title: AppStrings.actionZone,
            child: Column(
              children: [
                SbButton.primary(
                  label: AppStrings.newInspection,
                  icon: Icons.add_circle_outline,
                  onPressed: () {
                    context.push('/projects/$projectId/level-log');
                  },
                  width: double.infinity,
                ),
                const SizedBox(height: AppSpacing.md),
                SbButton.secondary(
                  label: AppStrings.editProject,
                  icon: Icons.edit_outlined,
                  onPressed: () {
                    context.push('/projects/$projectId/edit');
                  },
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtext;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: colorScheme.primary, size: 20),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSizes.tab,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24, // Preserving headline-like size
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          Text(
            subtext,
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _getTypeIcon(String? type) {
  switch (type) {
    case 'column':
      return SbIcons.viewColumn;
    case 'beam':
      return SbIcons.viewArray;
    case 'slab':
      return SbIcons.layers;
    case 'footing':
      return SbIcons.foundation;
    default:
      return SbIcons.calculator;
  }
}
