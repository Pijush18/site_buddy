/// FILE HEADER
/// ----------------------------------------------
/// File: active_project_provider.dart
/// Feature: project
/// Layer: application/providers
///
/// PURPOSE:
/// DEPRECATED - This provider is kept for backward compatibility only.
/// All new code should use ProjectSessionService directly.
///
/// The Problem: This provider returns null when no project is active,
/// creating a dual system that bypasses the fail-fast behavior of ProjectSessionService.
///
/// Solution: All code should use projectSessionServiceProvider which throws
/// StateError when no project is selected.
/// ----------------------------------------------
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';

/// DEPRECATED: This class is kept only for backward compatibility.
/// DO NOT USE in new code - use ProjectSessionService instead.
///
/// This creates a nullable system that bypasses fail-fast behavior.
/// Will be removed in future version.
class ActiveProject {
  final String id;
  final String name;

  const ActiveProject({required this.id, required this.name});
}

/// DEPRECATED: Delegate to ProjectSessionService for backward compatibility.
/// Returns null if no active project (silent failure).
/// New code should use projectSessionServiceProvider.getActiveProjectId() which throws.
class ActiveProjectNotifier extends Notifier<ActiveProject?> {
  @override
  ActiveProject? build() {
    // Delegate to ProjectSessionService
    final session = ref.watch(projectSessionServiceProvider);
    final project = session.getActiveProject();
    if (project == null) return null;
    return ActiveProject(id: project.id, name: project.name);
  }

  void setActiveProject(String id, String name) {
    // Delegate to ProjectSessionService - but this is a no-op now
    // since we're just reading from session
    // This method exists for backward compatibility
  }

  void clearActiveProject() {
    // Delegate to ProjectSessionService
    ref.read(projectSessionServiceProvider).clearActiveProject();
  }
}

// DEPRECATED: Use projectSessionServiceProvider instead
// This provider exists only for backward compatibility
final activeProjectProvider =
    NotifierProvider<ActiveProjectNotifier, ActiveProject?>(() {
      return ActiveProjectNotifier();
    });
