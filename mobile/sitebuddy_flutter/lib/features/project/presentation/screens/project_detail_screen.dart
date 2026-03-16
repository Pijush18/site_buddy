import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/components/sb_button.dart';
import 'package:site_buddy/core/widgets/components/sb_card.dart';
import 'package:site_buddy/core/widgets/components/sb_section_header.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';
import 'package:site_buddy/features/project/presentation/controllers/project_detail_controller.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';

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
        title: 'Project Not Found',
        child: Center(child: Text('The requested project could not be found.')),
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
          SBCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STATUS',
                      style: TextStyle(
                        fontSize: AppFontSizes.tab,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, // 16
                        vertical: AppSpacing.sm / 2, // Replaced AppLayout.xs (4)
                      ),
                      child: Text(
                        proj.status.label.toUpperCase(),
                        style: TextStyle(
                          fontSize: AppFontSizes.tab,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
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
                          'CREATED',
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
                          'LOCATION',
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
            const SBSectionHeader(title: 'Description'),
            SBCard(
              child: Text(
                proj.description!,
                style: const TextStyle(
                  fontSize: AppFontSizes.subtitle,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.description,
                  label: 'LOGS',
                  value: proj.logsCount.toString(),
                  subtext: 'Total Entries',
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

          const SBSectionHeader(title: 'Structural Calculations'),
          calcItems.isEmpty
              ? const SBCard(
                  child: Text('No entries found for this project.'),
                )
              : SBCard(
                  padding: EdgeInsets.zero,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: calcItems.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = calcItems[index];
                      return SbListItem(
                        leading: Icon(
                          _getTypeIcon(item['type'] as String),
                          color: colorScheme.primary,
                        ),
                        title: item['name'] as String,
                        subtitle: DateFormat(
                          'dd MMM, hh:mm a',
                        ).format(item['date'] as DateTime),
                        onTap: () {
                          context.push('/projects/$projectId/history');
                        },
                      );
                    },
                  ),
                ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          const SBSectionHeader(title: 'Level Log Sessions'),
          logItems.isEmpty
              ? const SBCard(
                  child: Text('No entries found for this project.'),
                )
              : SBCard(
                  padding: EdgeInsets.zero,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logItems.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = logItems[index];
                      return SbListItem(
                        leading: Icon(
                          SbIcons.layers,
                          color: colorScheme.secondary,
                        ),
                        title: item.name,
                        subtitle:
                            '${item.method.name} • ${DateFormat('dd MMM, hh:mm a').format(item.date)}',
                        onTap: () {
                          context.push('/projects/$projectId/level-log');
                        },
                      );
                    },
                  ),
                ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          const SBSectionHeader(title: 'Action Zone'),
          Column(
            children: [
              SBButton.primary(
                label: 'New Inspection Entry',
                icon: Icons.add_circle_outline,
                onPressed: () {
                  context.push('/projects/$projectId/level-log');
                },
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.md),
              SBButton.secondary(
                label: 'Edit Project',
                icon: Icons.edit_outlined,
                onPressed: () {
                  context.push('/projects/$projectId/edit');
                },
                fullWidth: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg), // Added for consistency
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

    return SBCard(
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
