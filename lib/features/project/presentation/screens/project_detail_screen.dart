import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:site_buddy/features/project/application/controllers/project_controller.dart';
import 'package:site_buddy/features/project/presentation/controllers/project_detail_controller.dart';


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
      return const SbPage.detail(
        title: 'Project Not Found',
        body: Center(child: Text('The requested project could not be found.')),
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



    return SbPage.detail(
      title: proj.name,
      body: Column(
        children: [
          // Status Header
          SbCard(
            padding: AppLayout.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STATUS',
                      style: SbTextStyles.caption(context).copyWith(
                        color: colorScheme.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppLayout.md, // 16
                        vertical: AppLayout.xs,   // 4
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(AppLayout.sm),
                      ),
                      child: Text(
                        proj.status.label.toUpperCase(),
                        style: SbTextStyles.caption(context).copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppLayout.md),
                Text(proj.name, style: SbTextStyles.title(context)),
                const SizedBox(height: AppLayout.md),
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
                const SizedBox(height: AppLayout.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CREATED',
                          style: SbTextStyles.caption(context).copyWith(
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(formattedDate, style: SbTextStyles.body(context)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'LOCATION',
                          style: SbTextStyles.caption(context).copyWith(
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
                            const SizedBox(width: AppLayout.sm),
                            Text(
                              proj.location,
                              style: SbTextStyles.body(context),
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
          const SizedBox(height: AppLayout.lg),

          // Description block if available
          if (proj.description != null && proj.description!.isNotEmpty) ...[
            SbSection(
              title: 'Description',
              child: SbCard(
                child: Text(
                  proj.description!,
                  style: SbTextStyles.body(context).copyWith(height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: AppLayout.lg),
          ],

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: SbIcons.description,
                  label: 'LOGS',
                  value: proj.logsCount.toString(),
                  subtext: 'Total Entries',
                ),
              ),
              const SizedBox(width: AppLayout.md),
              Expanded(
                child: _StatCard(
                  icon: SbIcons.calculator,
                  label: 'CALCS',
                  value: proj.calculationsCount.toString(),
                  subtext: 'Saved Runs',
                ),
              ),
            ],
          ),

          const SizedBox(height: AppLayout.lg),

          SbSection(
            title: 'Structural Calculations',
            child: calcItems.isEmpty
                ? const SbCard(
                    child: Text('No entries found for this project.'),
                  )
                : SbCard(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: calcItems.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: AppLayout.xs),
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
          ),
          const SizedBox(height: AppLayout.lg),

          // Level Log History
          SbSection(
            title: 'Level Log Sessions',
            child: logItems.isEmpty
                ? const SbCard(
                    child: Text('No entries found for this project.'),
                  )
                : SbCard(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logItems.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: AppLayout.xs),
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
          ),
          const SizedBox(height: AppLayout.lg),

          SbSection(
            title: 'Action Zone',
            child: Column(
              children: [
                SbButton(
                  label: 'New Inspection Entry',
                  icon: SbIcons.addCircle,
                  onPressed: () {
                    context.push('/projects/$projectId/level-log');
                  },
                ),
                const SizedBox(height: AppLayout.md),
                SbButton(
                  label: 'Edit Project',
                  icon: SbIcons.editSquare,
                  variant: SbButtonVariant.outline,
                  onPressed: () {
                    context.push('/projects/$projectId/edit');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppLayout.lg),
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
      padding: AppLayout.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: colorScheme.primary, size: 20),
              Text(
                label,
                style: SbTextStyles.caption(context).copyWith(
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppLayout.md),
          Text(
            value,
            style: SbTextStyles.headline(context).copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: AppLayout.sm),
          Text(
            subtext,
            style: SbTextStyles.caption(context).copyWith(
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
