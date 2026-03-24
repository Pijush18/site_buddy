import 'package:site_buddy/visualization/config/diagram_config.dart';

/// Viewport configuration
class ViewportConfig {
  final String id;
  final String name;
  final DiagramConfig config;
  final List<String> visibleLayers;

  const ViewportConfig({
    required this.id,
    required this.name,
    required this.config,
    this.visibleLayers = const [],
  });
}

/// View relationship type
enum ViewRelation {
  none,
  synchronized,
  linked,
  master,
}

/// Multi-view layout type
enum MultiViewLayout {
  single,
  splitHorizontal,
  splitVertical,
  grid,
  tabbed,
}

/// Multi-view manager interface
abstract class MultiViewManager {
  /// Create a new view
  void createView(ViewportConfig config);

  /// Remove a view
  void removeView(String viewId);

  /// Update view config
  void updateView(String viewId, ViewportConfig config);

  /// Get view by id
  ViewportConfig? getView(String viewId);

  /// Get all views
  List<ViewportConfig> getAllViews();

  /// Set view relationship
  void setRelation(String viewId1, String viewId2, ViewRelation relation);

  /// Synchronize views
  void synchronizeViews(String viewId1, String viewId2);
}
