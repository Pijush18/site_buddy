import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
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
    final l10n = context.l10n;
    final state = ref.watch(projectListControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
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
            padding: const EdgeInsets.all(AppSpacing.md),
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                            const SizedBox(height: AppSpacing.md),
                            Text(state.error!, style: TextStyle(color: colorScheme.error)),
                            const SizedBox(height: AppSpacing.md),
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
                              padding: const EdgeInsets.all(AppSpacing.md),
                              itemCount: state.filteredProjects.length,
                              itemBuilder: (context, index) {
                                final project = state.filteredProjects[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
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
              style: TextStyle(color: Theme.of(context).colorScheme.error),
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
        const SizedBox(width: AppSpacing.sm),
        _StatChip(
          label: 'In Progress',
          value: state.inProgressCount.toString(),
          color: AppColors.warning(context),
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatChip(
          label: 'Completed',
          value: state.completedCount.toString(),
          color: Colors.green,
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
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.folder_outlined,
                  color: colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      project.type.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
            const SizedBox(height: AppSpacing.sm),
            Text(
              project.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // Footer with status and stats
          const SizedBox(height: AppSpacing.md),
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
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
        color = Colors.grey;
        break;
      case ProjectStatus.inProgress:
        color = AppColors.warning(context);
        break;
      case ProjectStatus.completed:
        color = Colors.green;
        break;
      case ProjectStatus.archived:
        color = Colors.brown;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasSearch ? Icons.search_off : Icons.folder_open_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              hasSearch ? 'No projects found' : 'No projects yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasSearch 
                  ? 'Try a different search term'
                  : 'Create your first project to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (!hasSearch) ...[
              const SizedBox(height: AppSpacing.lg),
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
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create New Project',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              SbInput(
                controller: _nameController,
                label: 'Project Name',
                hint: 'e.g., Residential Building A',
              ),
              const SizedBox(height: AppSpacing.md),
              SbInput(
                controller: _descriptionController,
                label: 'Description (Optional)',
                hint: 'Brief project description',
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Project Type',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
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
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: SbInput(
                      controller: _locationController,
                      label: 'Location (Optional)',
                      hint: 'City/Area',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SbInput(
                      controller: _clientController,
                      label: 'Client (Optional)',
                      hint: 'Client name',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryCTA(
                label: 'Create Project',
                onPressed: _createProject,
              ),
              const SizedBox(height: AppSpacing.sm),
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Projects',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'By Status',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
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
          const SizedBox(height: AppSpacing.lg),
          Text(
            'By Type',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
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
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
