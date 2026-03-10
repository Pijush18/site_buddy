/// FILE HEADER
/// ----------------------------------------------
/// File: ai_intent.dart
/// Feature: shared
/// Layer: domain/models
///
/// PURPOSE:
/// Unified enum defining all classification intents for the AI Assistant and Chat modules.
/// ----------------------------------------------
library;

/// Represents the classification of a user's natural language query across all AI services.
enum AiIntent {
  /// Defines civil engineering topics (Knowledge Base).
  knowledge,

  /// Converts units of measurement.
  conversion,

  /// Calculates general material quantities.
  calculation,

  /// Intent: Concrete material formulation operations (e.g. "slab m20").
  calculateConcrete,

  /// Intent: Reduced level operations (e.g. "rl", "backsight", "levels").
  leveling,

  /// Intent: Spawning a new site project entity.
  createProject,

  /// Intent: Adding a calculation payload or note to a project.
  addToProject,

  /// Intent: Queries reading the current project databases.
  fetchProject,

  /// Input was not understood.
  unknown,
}
