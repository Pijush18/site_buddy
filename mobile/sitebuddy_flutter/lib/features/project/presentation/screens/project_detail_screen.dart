import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/presentation/controllers/project_detail_controller.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';

/// CLASS: ProjectDetailScreen
/// FIX: projectId comes from session only - no route parameter
class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    /// FIX: Get project from session - watch for reactivity
    final proj = ref.watch(projectSessionServiceProvider).getActiveProject();

    if (proj == null) {
      return SbPage.detail(
        title: context.l10n.labelFail,
        body: Center(child: Text(context.l10n.msgProjectNotFound)),
      );
    }

    final projectId = proj.id;
    final detailState = ref.watch(projectDetailControllerProvider);
    final calculations = detailState.calculations;
    final columns = calculations['columns'] as List;
    final beams = calculations['beams'] as List;
    final slabs = calculations['slabs'] as List;
    final footings = calculations['footings'] as List;

    final calcItems = [
      ...columns.map(
        (c) => {
          'type': 'column',
          'name': 'Column',
          'date': DateTime.now(),
        },
      ),
      ...beams.map(
        (b) => {'type': 'beam', 'name': 'Beam', 'date': DateTime.now()},
      ),
      ...slabs.map(
        (s) => {'type': 'slab', 'name': 'Slab', 'date': DateTime.now()},
      ),
      ...footings.map(
        (f) => {'type': 'footing', 'name': 'Footing', 'date': DateTime.now()},
      ),
    ];

    final logItems = detailState.logs;
    final formattedDate = DateFormat('dd MMM yyyy').format(proj.createdAt);

    return SbPage.detail(
      title: proj.name,
      appBarActions: [
        Consumer(
          builder: (context, ref, _) {
            final isOnline = ref.watch(connectivityProvider).value ?? true;
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SbSpacing.lg,
              ).copyWith(left: 0),
              child: Icon(
                isOnline ? SbIcons.checkFilled : SbIcons.warning,
                size: 16,
                color: isOnline ? Colors.green : Colors.orange,
              ),
            );
          },
        ),
      ],
      body: SbSectionList(
        sections: [
          // ── Status Header ──
          SbSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.labelStatus,
                      style: Theme.of(context).textTheme.labelMedium!,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SbSpacing.lg,
                      ),
                      child: Text(
                        proj.status.label,
                        style: Theme.of(context).textTheme.labelMedium!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SbSpacing.lg),
                Text(
                  proj.name,
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                const SizedBox(height: SbSpacing.lg),
                // Cover Image Mock
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Center(
                    child: Icon(
                      SbIcons.terrain,
                      size: 48,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                const SizedBox(height: SbSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.titleLevellingLog, // Or "Created"? I'll use "Created" if I have it.
                          style: Theme.of(context).textTheme.labelMedium!,
                        ),
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          context.l10n.labelLocation,
                          style: Theme.of(context).textTheme.labelMedium!,
                        ),
                        Row(
                          children: [
                            Icon(
                              SbIcons.location,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: SbSpacing.sm),
                            Text(
                              proj.location,
                              style: Theme.of(context).textTheme.bodyLarge!,
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

          // Description block if available
          if (proj.description != null && proj.description!.isNotEmpty)
            SbSection(
              title: context.l10n.labelDescription,
              child: Text(
                proj.description!,
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),

          // Stats grid section (Sole source of inter-section truth)
          SbSection(
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.description,
                      label: 'LOGS',
                      value: proj.logsCount.toString(),
                      subtext: 'Entries',
                    ),
                  ),
                  VerticalDivider(
                    width: SbSpacing.xl,
                    thickness: 1,
                    color: context.colors.outline,
                  ),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.calculate,
                      label: 'CALCS',
                      value: proj.calculationsCount.toString(),
                      subtext: 'Saved Runs',
                    ),
                  ),
                ],
              ),
            ),
          ),

          SbSection(
            title: context.l10n.navDesign,
            padding: EdgeInsets.zero,
            child: calcItems.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(SbSpacing.md),
                    child: Text(context.l10n.msgNoRecordsFound),
                  )
                : SbListGroup(
                    children: calcItems.map((item) {
                      return SbListItemTile(
                        icon: _getTypeIcon(item['type'] as String),
                        title: item['name'] as String,
                        subtitle: DateFormat(
                          'dd MMM, hh:mm a',
                        ).format(item['date'] as DateTime),
                        onTap: () {
                          context.push(AppRoutes.projectHistory(projectId));
                        },
                      );
                    }).toList(),
                  ),
          ),

          SbSection(
            title: context.l10n.labelFieldSurveying,
            padding: EdgeInsets.zero,
            child: logItems.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(SbSpacing.md),
                    child: Text(context.l10n.msgNoRecordsFound),
                  )
                : SbListGroup(
                    children: logItems.map((item) {
                      return SbListItemTile(
                        icon: SbIcons.layers,
                        title: item.name,

                        subtitle:
                            '${item.method.name} • ${DateFormat('dd MMM, hh:mm a').format(item.date)}',
                        onTap: () {
                          context.push(AppRoutes.projectLevelLog(projectId));
                        },
                      );
                    }).toList(),
                  ),
          ),

          SbSection(
            title: context.l10n.labelStatus, // Or general "Management"? I'll use "Management" if I have it.
            child: Column(
              children: [
                PrimaryCTA(
                  label: context.l10n.actionNewEntry,
                  icon: Icons.add_circle_outline,
                  onPressed: () {
                    context.push(AppRoutes.projectLevelLog(projectId));
                  },
                  width: double.infinity,
                ),
                const SizedBox(height: SbSpacing.lg),
                SecondaryButton(
                  label: context.l10n.actionEdit,
                  icon: Icons.edit_outlined,
                  onPressed: () {
                    context.push(AppRoutes.projectEdit());
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

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtext;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    return SbSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              Text(label, style: Theme.of(context).textTheme.labelMedium!),
            ],
          ),
          const SizedBox(height: SbSpacing.lg),
          Text(value, style: Theme.of(context).textTheme.titleLarge!),
          const SizedBox(height: SbSpacing.sm),
          Text(subtext, style: Theme.of(context).textTheme.labelMedium!),
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
