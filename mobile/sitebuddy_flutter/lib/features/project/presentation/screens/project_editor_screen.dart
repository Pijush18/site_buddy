import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/project_status.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';

/// SCREEN: ProjectEditorScreen
class ProjectEditorScreen extends ConsumerStatefulWidget {
  final String? projectId;
  const ProjectEditorScreen({super.key, this.projectId});

  @override
  ConsumerState<ProjectEditorScreen> createState() => _ProjectEditorScreenState();
}

class _ProjectEditorScreenState extends ConsumerState<ProjectEditorScreen> {
  final _nameController = TextEditingController();
  final _locController = TextEditingController();
  final _clientController = TextEditingController();
  final _descController = TextEditingController();
  ProjectStatus _selectedStatus = ProjectStatus.active;
  bool _isSaving = false;

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty &&
      _locController.text.trim().isNotEmpty;

  Future<void> _saveProject() async {
    if (!_isFormValid || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      await ref.read(projectControllerProvider.notifier).createProject(
            name: _nameController.text.trim(),
            location: _locController.text.trim(),
            clientName: _clientController.text.trim().isNotEmpty
                ? _clientController.text.trim()
                : null,
            description: _descController.text.trim().isNotEmpty
                ? _descController.text.trim()
                : null,
            status: _selectedStatus,
          );

      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save project: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
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

  @override
  Widget build(BuildContext context) {
    return SbPage.form(
      title: 'Project Info',
      primaryAction: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isSaving ? null : _saveProject,
          child: _isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save Project'),
        ),
      ),

      body: SbSectionList(
        sections: [
          SbSection(
            title: 'Primary Details',
            child: Column(
              children: [
                SbInput(
                  controller: _nameController,
                  hint: 'e.g. Skyline Apartments',
                  label: 'PROJECT NAME',
                  textInputAction: TextInputAction.next,
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.lg),
                SbInput(
                  controller: _locController,
                  hint: 'City, Region or Site ID',
                  label: 'LOCATION',
                  textInputAction: TextInputAction.next,
                  onChanged: (v) {},
                ),
              ],
            ),
          ),
          SbSection(
            title: 'Stakeholders',
            child: SbInput(
              controller: _clientController,
              hint: 'Contracting Authority / Client',
              label: 'CLIENT',
              textInputAction: TextInputAction.next,
              onChanged: (v) {},
            ),
          ),
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
          SbSection(
            title: 'Scope & Description',
            child: SbInput(
              controller: _descController,
              maxLines: 5,
              hint: 'Enter detailed project scope...',
              label: 'DESCRIPTION',
              onChanged: (v) {},
            ),
          ),
        ],
      ),
    );
  }
}







