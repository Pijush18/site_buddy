import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/project_status.dart';

/// SCREEN: ProjectEditorScreen
class ProjectEditorScreen extends StatefulWidget {
  final String? projectId;
  const ProjectEditorScreen({super.key, this.projectId});

  @override
  State<ProjectEditorScreen> createState() => _ProjectEditorScreenState();
}

class _ProjectEditorScreenState extends State<ProjectEditorScreen> {
  final _nameController = TextEditingController();
  final _locController = TextEditingController();
  final _clientController = TextEditingController();
  final _descController = TextEditingController();
  ProjectStatus _selectedStatus = ProjectStatus.active;

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
      primaryAction: SbButton.primary(
        label: 'Save Project',
        onPressed: () => Navigator.pop(context),
        width: double.infinity,
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
                SizedBox(height: SbSpacing.lg),
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







