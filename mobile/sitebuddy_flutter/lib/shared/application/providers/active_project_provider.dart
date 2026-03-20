/// FILE HEADER
/// ----------------------------------------------
/// File: active_project_provider.dart
/// Feature: project
/// Layer: application/providers
///
/// PURPOSE:
/// Maintains the globally accessible state of the currently active project.
///
/// RESPONSIBILITIES:
/// - Provides `ActiveProject` state for contextual features (like AI reports).
/// - Allows setting/clearing the active project context.
/// ----------------------------------------------
library;


import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveProject {
  final String id;
  final String name;

  const ActiveProject({required this.id, required this.name});
}

class ActiveProjectNotifier extends Notifier<ActiveProject?> {
  @override
  ActiveProject? build() {
    return null; // Null means no active project ("General" context)
  }

  void setActiveProject(String id, String name) {
    state = ActiveProject(id: id, name: name);
  }

  void clearActiveProject() {
    state = null;
  }
}

// Global provider to access the active project context
final activeProjectProvider =
    NotifierProvider<ActiveProjectNotifier, ActiveProject?>(() {
      return ActiveProjectNotifier();
    });



