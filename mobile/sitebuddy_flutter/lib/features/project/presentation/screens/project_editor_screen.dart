import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/features/project/application/controllers/project_controller.dart';
import 'package:site_buddy/shared/domain/models/project_status.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

/// CLASS: ProjectEditorScreen
/// PURPOSE: Multi-use form screen resolving context automatically by checking if `projectId` is passed.
class ProjectEditorScreen extends ConsumerStatefulWidget {
  final String? projectId;

  const ProjectEditorScreen({super.key, this.projectId});

  @override
  ConsumerState<ProjectEditorScreen> createState() =>
      _ProjectEditorScreenState();
}

class _ProjectEditorScreenState extends ConsumerState<ProjectEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _locController;
  late TextEditingController _clientController;
  late TextEditingController _descController;
  ProjectStatus _selectedStatus = ProjectStatus.active;

  bool get isEditMode => widget.projectId != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _locController = TextEditingController();
    _clientController = TextEditingController();
    _descController = TextEditingController();

    if (isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final projects = ref.read(projectControllerProvider).projects;
        final target = projects.cast<dynamic>().firstWhere(
          (p) => p.id == widget.projectId,
          orElse: () => null,
        );

        if (target != null) {
          setState(() {
            _nameController.text = target.name;
            _locController.text = target.location;
            _clientController.text = target.clientName ?? '';
            _descController.text = target.description ?? '';
            _selectedStatus = target.status;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locController.dispose();
    _clientController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      if (isEditMode) {
        final state = ref.read(projectControllerProvider);
        final existingProj = state.projects.firstWhere(
          (p) => p.id == widget.projectId,
        );

        ref
            .read(projectControllerProvider.notifier)
            .updateProject(
              existingProj.copyWith(
                name: _nameController.text.trim(),
                location: _locController.text.trim(),
                clientName: _clientController.text.trim(),
                description: _descController.text.trim(),
                status: _selectedStatus,
              ),
            );
      } else {
        ref
            .read(projectControllerProvider.notifier)
            .createProject(
              name: _nameController.text.trim(),
              location: _locController.text.trim(),
              clientName: _clientController.text.trim(),
              description: _descController.text.trim(),
              status: _selectedStatus,
            );
      }

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SbPage.form(
      title: isEditMode ? 'Edit Project' : 'New Project',
      primaryAction: ActionButtonsGroup(
        children: [
          SbButton(
            label: 'Cancel',
            variant: SbButtonVariant.outline,
            onPressed: () => context.pop(),
          ),
          SbButton(
            label: isEditMode ? 'Update' : 'Save',
            icon: isEditMode ? SbIcons.checkFilled : SbIcons.save,
            variant: SbButtonVariant.primary,
            onPressed: _onSave,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SbSection(
              title: 'Project Details',
              child: Column(
                children: [
                  SbInput(
                    controller: _nameController,
                    hint: 'Project Name (e.g. Bridge Rehab)',
                    label: 'NAME',
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Name is required'
                        : null,
                    textInputAction: TextInputAction.next,
                  ),
                  AppLayout.vGap16,
                  SbInput(
                    controller: _locController,
                    hint: 'Location / Site Address',
                    label: 'LOCATION',
                    prefixIcon: const Icon(SbIcons.location),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Location is required'
                        : null,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
            ),
            AppLayout.vGap24,
            SbSection(
              title: 'Client Information',
              child: SbInput(
                controller: _clientController,
                hint: 'Contracting Authority / Client',
                label: 'CLIENT',
                textInputAction: TextInputAction.next,
              ),
            ),
            AppLayout.vGap24,
            SbSection(
              title: 'Project Status',
              child: SbDropdown<ProjectStatus>(
                value: _selectedStatus,
                items: ProjectStatus.values,
                itemLabelBuilder: (status) => status.label,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedStatus = val);
                  }
                },
              ),
            ),
            AppLayout.vGap24,
            SbSection(
              title: 'Scope & Description',
              child: SbInput(
                controller: _descController,
                maxLines: 5,
                hint: 'Enter detailed project scope...',
                label: 'DESCRIPTION',
              ),
            ),
            AppLayout.vGap24,
          ],
        ),
      ),
    );
  }
}
