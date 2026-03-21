import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';

/// CLASS: ProjectShareScreen
/// PURPOSE: Display a list of export mechanisms for the target project.
class ProjectShareScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectShareScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectShareScreen> createState() => _ProjectShareScreenState();
}

class _ProjectShareScreenState extends ConsumerState<ProjectShareScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(projectControllerProvider.notifier)
          .getProjectById(widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectControllerProvider);
    final proj = state.selectedProject;

    if (state.isLoading || proj == null) {
      return const SbPage.list(
        title: 'Share Project',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SbPage.list(
      title: 'Share: ${proj.name}',
      body: SbSectionList(
        sections: [
          SbSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildShareOption(
                  context,
                  icon: SbIcons.pdf,
                  title: 'Export as PDF',
                  subtitle: 'Generate a formatted daily report',
                  onTap: () => debugPrint('Sharing PDF for ${proj.name}'),
                ),
                const SizedBox(height: SbSpacing.lg),
                _buildShareOption(
                  context,
                  icon: SbIcons.message,
                  title: 'Share via Text',
                  subtitle: 'Send a quick text summary link',
                  onTap: () => debugPrint('Sharing Text for ${proj.name}'),
                ),
                const SizedBox(height: SbSpacing.lg),
                _buildShareOption(
                  context,
                  icon: SbIcons.copy,
                  title: 'Copy Summary',
                  subtitle: 'Copy project stats to clipboard',
                  onTap: () => debugPrint('Copying data for ${proj.name}'),
                ),
                const SizedBox(height: SbSpacing.lg),
                _buildShareOption(
                  context,
                  icon: SbIcons.table,
                  title: 'Export Data (CSV)',
                  subtitle: 'Download raw calculations and logs',
                  onTap: () => debugPrint('Exporting CSV for ${proj.name}'),
                ),
                const SizedBox(height: SbSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbCard(
      onTap: onTap,
          padding: const EdgeInsets.all(SbSpacing.xxl),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(SbSpacing.sm),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(width: SbSpacing.lg), // Replaced const SizedBox(width: SbSpacing.lg)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
                const SizedBox(height: SbSpacing.xs),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelMedium!,
                ),
              ],
            ),
          ),
          Icon(SbIcons.chevronRight, color: colorScheme.outlineVariant),
        ],
      ),
    );
  }
}









