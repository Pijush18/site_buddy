import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/application/project_controller.dart';
import 'package:site_buddy/features/project/domain/models/project_model.dart';
import 'package:site_buddy/core/theme/app_colors.dart';

/// SCREEN: ProjectListScreen
/// Displays all projects with search and filtering capabilities.
class ProjectListScreen extends ConsumerStatefulWidget {
  const ProjectListScreen({super.key});

  @override
  ConsumerState<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends ConsumerState<ProjectListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectListControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(SbIcons.filter),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(SbSpacing.md),
            child: SbInput(
              controller: _searchController,
              hint: 'Search projects...',
              prefixIcon: const Icon(SbIcons.search, size: 20),
              onChanged: (value) {
                ref.read(projectListControllerProvider.notifier).setSearchQuery(value);
              },
            ),
          ),

          // Stats row
          if (state.projects.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SbSpacing.md),
              child: _StatsRow(state: state),
            ),

          // Project list
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                            const SizedBox(height: SbSpacing.md),
                            Text(state.error!, style: SbTypography.body.copyWith(color: colorScheme.error)),
                            const SizedBox(height: SbSpacing.md),
                            GhostButton(
                              label: 'Retry',
                              onPressed: () => ref.read(projectListControllerProvider.notifier).refresh(),
                            ),
                          ],
                        ),
                      )
                    : state.filteredProjects.isEmpty
                        ? _EmptyState(
                            hasSearch: state.searchQuery.isNotEmpty,
                            onCreateProject: () => _showCreateProjectDialog(context),
                          )
                        : RefreshIndicator(
                            onRefresh: () => ref.read(projectListControllerProvider.notifier).refresh(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(SbSpacing.md),
                              itemCount: state.filteredProjects.length,
                              itemBuilder: (context, index) {
                                final project = state.filteredProjects[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: SbSpacing.md),
                                  child: _ProjectCard(
                                    project: project,
                                    onTap: () => _openProject(context, project),
                                    onDelete: () => _deleteProject(context, project),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateProjectDialog(context),
        icon: const Icon(SbIcons.add),
        label: const Text('New Project'),
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CreateProjectSheet(),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _FilterSheet(),
    );
  }

  void _openProject(BuildContext context, ProjectModel project) {
    ref.read(activeProjectControllerProvider.notifier).setProject(project);
    context.push('/project/${project.id}');
  }

  void _deleteProject(BuildContext context, ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project?'),
        content: Text('Are you sure you want to delete "${project.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(projectListControllerProvider.notifier).deleteProject(project.id);
            },
            child: Text(
              'Delete',
              style: SbTypography.label.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final ProjectListState state;

  const _StatsRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(
          label: 'Total',
          value: state.totalProjects.toString(),
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: SbSpacing.sm),
        _StatChip(
          label: 'In Progress',
          value: state.inProgressCount.toString(),
          color: AppColors.warning,
        ),
        const SizedBox(width: SbSpacing.sm),
        _StatChip(
          label: 'Completed',
          value: state.completedCount.toString(),
          color: AppColors.success,
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SbSpacing.sm,
        vertical: SbSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: SbTypography.title.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: SbTypography.caption.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.project,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SbCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon, title, and actions
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(SbSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(SbRadius.standard),
                ),
                child: Icon(
                  Icons.folder_outlined,
                  color: colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: SbSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: SbTypography.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      project.type.label,
                      style: SbTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Description
          if (project.description != null && project.description!.isNotEmpty) ...[
            const SizedBox(height: SbSpacing.sm),
            Text(
              project.description!,
              style: SbTypography.body.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // Footer with status and stats
          const SizedBox(height: SbSpacing.md),
          Row(
            children: [
              _StatusBadge(status: project.status),
              const Spacer(),
              Icon(
                Icons.calculate_outlined,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${project.totalCalculations} calculations',
                style: SbTypography.caption.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProjectStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case ProjectStatus.draft:
        color = Theme.of(context).colorScheme.outline;
        break;
      case ProjectStatus.inProgress:
        color = AppColors.warning;
        break;
      case ProjectStatus.completed:
        color = AppColors.success;
        break;
      case ProjectStatus.archived:
        color = Theme.of(context).colorScheme.outlineVariant;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SbSpacing.sm,
        vertical: SbSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.label,
        style: SbTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasSearch;
  final VoidCallback onCreateProject;

  const _EmptyState({
    required this.hasSearch,
    required this.onCreateProject,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SbSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasSearch ? Icons.search_off : Icons.folder_open_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: SbSpacing.md),
            Text(
              hasSearch ? 'No projects found' : 'No projects yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: SbSpacing.sm),
            Text(
              hasSearch 
                  ? 'Try a different search term'
                  : 'Create your first project to get started',
              style: SbTypography.body.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (!hasSearch) ...[
              const SizedBox(height: SbSpacing.lg),
              PrimaryCTA(
                label: 'Create Project',
                onPressed: onCreateProject,
                icon: SbIcons.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CreateProjectSheet extends ConsumerStatefulWidget {
  const _CreateProjectSheet();

  @override
  ConsumerState<_CreateProjectSheet> createState() => _CreateProjectSheetState();
}

class _CreateProjectSheetState extends ConsumerState<_CreateProjectSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _clientController = TextEditingController();
  ProjectType _selectedType = ProjectType.residential;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _clientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(SbSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create New Project',
                style: SbTypography.headline,
              ),
              const SizedBox(height: SbSpacing.lg),
              SbInput(
                controller: _nameController,
                label: 'Project Name',
                hint: 'e.g., Residential Building A',
              ),
              const SizedBox(height: SbSpacing.md),
              SbInput(
                controller: _descriptionController,
                label: 'Description (Optional)',
                hint: 'Brief project description',
                maxLines: 2,
              ),
              const SizedBox(height: SbSpacing.md),
              Text(
                'Project Type',
                style: SbTypography.label,
              ),
              const SizedBox(height: SbSpacing.sm),
              Wrap(
                spacing: SbSpacing.sm,
                children: ProjectType.values.map((type) {
                  final isSelected = type == _selectedType;
                  return ChoiceChip(
                    label: Text(type.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedType = type);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: SbSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: SbInput(
                      controller: _locationController,
                      label: 'Location (Optional)',
                      hint: 'City/Area',
                    ),
                  ),
                  const SizedBox(width: SbSpacing.md),
                  Expanded(
                    child: SbInput(
                      controller: _clientController,
                      label: 'Client (Optional)',
                      hint: 'Client name',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SbSpacing.lg),
              PrimaryCTA(
                label: 'Create Project',
                onPressed: _createProject,
              ),
              const SizedBox(height: SbSpacing.sm),
              GhostButton(
                label: 'Cancel',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createProject() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a project name')),
      );
      return;
    }

    await ref.read(projectListControllerProvider.notifier).createProject(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      type: _selectedType,
      location: _locationController.text.trim().isEmpty 
          ? null 
          : _locationController.text.trim(),
      clientName: _clientController.text.trim().isEmpty 
          ? null 
          : _clientController.text.trim(),
    );

    if (mounted) Navigator.pop(context);
  }
}

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(SbSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Projects',
            style: SbTypography.headline,
          ),
          const SizedBox(height: SbSpacing.lg),
          Text(
            'By Status',
            style: SbTypography.label,
          ),
          const SizedBox(height: SbSpacing.sm),
          Wrap(
            spacing: SbSpacing.sm,
            children: ProjectStatus.values.map((status) {
              return FilterChip(
                label: Text(status.label),
                selected: false,
                onSelected: (selected) {
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: SbSpacing.lg),
          Text(
            'By Type',
            style: SbTypography.label,
          ),
          const SizedBox(height: SbSpacing.sm),
          Wrap(
            spacing: SbSpacing.sm,
            children: ProjectType.values.map((type) {
              return FilterChip(
                label: Text(type.label),
                selected: false,
                onSelected: (selected) {
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: SbSpacing.lg),
        ],
      ),
    );
  }
}
