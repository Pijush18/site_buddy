import 'package:flutter/widgets.dart';

/// Viewport controller for managing zoom and pan state
/// 
/// Handles user interaction state independently from the coordinate
/// transformation system. This allows smooth zoom/pan without
/// modifying the underlying diagram space.
/// 
/// Architecture:
/// ```text
/// User Gesture → ViewportController → DiagramSpace → Canvas
/// ```
/// 
/// Example:
/// ```dart
/// final viewport = DiagramViewport();
/// 
/// // Zoom in at focal point
/// viewport.zoomAt(1.5, focalPoint);
/// 
/// // Pan by delta
/// viewport.pan(delta);
/// 
/// // Get combined transform for space
/// final effectiveScale = viewport.effectiveScale;
/// final effectiveOffset = viewport.effectiveOffset;
/// ```
class DiagramViewport {
  /// Current zoom level (1.0 = 100%)
  double scale;

  /// Pan offset in canvas pixels
  Offset panOffset;

  /// Minimum allowed zoom level
  final double minScale;

  /// Maximum allowed zoom level
  final double maxScale;

  /// Whether zoom is enabled
  final bool zoomEnabled;

  /// Whether pan is enabled
  final bool panEnabled;

  /// Callback fired when viewport changes
  final VoidCallback? onChanged;

  DiagramViewport({
    this.scale = 1.0,
    this.panOffset = Offset.zero,
    this.minScale = 0.1,
    this.maxScale = 10.0,
    this.zoomEnabled = true,
    this.panEnabled = true,
    this.onChanged,
  });

  /// Create a copy with modifications
  DiagramViewport copyWith({
    double? scale,
    Offset? panOffset,
    double? minScale,
    double? maxScale,
    bool? zoomEnabled,
    bool? panEnabled,
  }) {
    return DiagramViewport(
      scale: scale ?? this.scale,
      panOffset: panOffset ?? this.panOffset,
      minScale: minScale ?? this.minScale,
      maxScale: maxScale ?? this.maxScale,
      zoomEnabled: zoomEnabled ?? this.zoomEnabled,
      panEnabled: panEnabled ?? this.panEnabled,
      onChanged: onChanged,
    );
  }

  /// Zoom by a factor centered on a focal point
  /// 
  /// The focal point remains stationary while zooming.
  /// 
  /// [factor] - zoom multiplier (e.g., 1.5 = zoom in 50%)
  /// [focalPoint] - point in canvas coordinates to keep fixed
  void zoomAt(double factor, Offset focalPoint) {
    if (!zoomEnabled || factor == 1.0) return;

    final newScale = (scale * factor).clamp(minScale, maxScale);
    
    // Adjust pan to keep focal point fixed
    // New pan offset ensures: focalPoint = (focalPoint - oldOffset) * factor + newOffset
    // Solving: newOffset = focalPoint - (focalPoint - oldOffset) * factor
    panOffset = focalPoint - (focalPoint - panOffset) * factor;
    scale = newScale;

    onChanged?.call();
  }

  /// Zoom by a factor centered on the viewport center
  void zoomCentered(double factor, Size viewportSize) {
    final center = Offset(viewportSize.width / 2, viewportSize.height / 2);
    zoomAt(factor, center);
  }

  /// Zoom to a specific scale level
  /// 
  /// [targetScale] - desired zoom level
  /// [viewportSize] - viewport dimensions for centering
  void zoomTo(double targetScale, Size viewportSize) {
    final factor = targetScale / scale;
    zoomCentered(factor, viewportSize);
  }

  /// Pan by a delta in canvas coordinates
  void pan(Offset delta) {
    if (!panEnabled || delta == Offset.zero) return;
    panOffset += delta;
    onChanged?.call();
  }

  /// Pan to a specific offset
  void panTo(Offset newOffset) {
    if (!panEnabled || newOffset == panOffset) return;
    panOffset = newOffset;
    onChanged?.call();
  }

  /// Reset to initial state
  void reset() {
    if (scale != 1.0 || panOffset != Offset.zero) {
      scale = 1.0;
      panOffset = Offset.zero;
      onChanged?.call();
    }
  }

  /// Animate to a specific scale and position
  /// 
  /// Returns a function that can be used with AnimationController
  /// to smoothly transition to the target state.
  void animateTo({
    required double targetScale,
    required Offset targetOffset,
    required Duration duration,
    void Function()? onComplete,
  }) {
    // This would typically be implemented with an AnimationController
    // in the widget layer. Here we just set the target values.
    scale = targetScale.clamp(minScale, maxScale);
    panOffset = targetOffset;
    onChanged?.call();
    onComplete?.call();
  }

  /// Get the effective scale factor for coordinate transformation
  double get effectiveScale => scale;

  /// Get the effective pan offset for coordinate transformation
  Offset get effectiveOffset => panOffset;

  /// Check if currently zoomed in (scale > 1)
  bool get isZoomedIn => scale > 1.0;

  /// Check if currently zoomed out (scale < 1)
  bool get isZoomedOut => scale < 1.0;

  /// Check if at default zoom (scale == 1)
  bool get isDefaultZoom => scale == 1.0;

  /// Check if panned from origin
  bool get isPanned => panOffset != Offset.zero;

  /// Get zoom percentage as integer
  int get zoomPercentage => (scale * 100).round();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DiagramViewport &&
        other.scale == scale &&
        other.panOffset == panOffset &&
        other.minScale == minScale &&
        other.maxScale == maxScale;
  }

  @override
  int get hashCode => Object.hash(scale, panOffset, minScale, maxScale);

  @override
  String toString() => 'DiagramViewport(scale: $scale, panOffset: $panOffset)';
}

/// State notifier for viewport changes
/// 
/// Provides ChangeNotifier interface for viewport state
/// that can be used with ListenableBuilder or ChangeNotifierProvider.
/// 
/// Lifecycle Safety:
/// - Implements WidgetsBindingObserver for app lifecycle events
/// - Properly detaches from binding on dispose
class DiagramViewportNotifier extends ChangeNotifier with WidgetsBindingObserver {
  double _scale;
  Offset _panOffset;
  final double _minScale;
  final double _maxScale;
  final bool _zoomEnabled;
  final bool _panEnabled;

  DiagramViewportNotifier({
    double scale = 1.0,
    Offset panOffset = Offset.zero,
    double minScale = 0.1,
    double maxScale = 10.0,
    bool zoomEnabled = true,
    bool panEnabled = true,
  })  : _scale = scale,
        _panOffset = panOffset,
        _minScale = minScale,
        _maxScale = maxScale,
        _zoomEnabled = zoomEnabled,
        _panEnabled = panEnabled {
    // Register for lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }

  /// Current scale (zoom level)
  double get scale => _scale;
  set scale(double value) {
    if (_scale != value) {
      _scale = value.clamp(_minScale, _maxScale);
      notifyListeners();
    }
  }

  /// Current pan offset in canvas coordinates
  Offset get panOffset => _panOffset;
  set panOffset(Offset value) {
    if (_panOffset != value) {
      _panOffset = value;
      notifyListeners();
    }
  }

  /// Minimum allowed scale
  double get minScale => _minScale;

  /// Maximum allowed scale
  double get maxScale => _maxScale;

  /// Whether zoom is enabled
  bool get zoomEnabled => _zoomEnabled;

  /// Whether pan is enabled
  bool get panEnabled => _panEnabled;

  /// Effective scale (same as scale for this implementation)
  double get effectiveScale => _scale;

  /// Effective offset (same as panOffset for this implementation)
  Offset get effectiveOffset => _panOffset;

  /// Zoom by a factor centered on a focal point
  void zoomAt(double factor, Offset focalPoint) {
    if (!_zoomEnabled || factor == 1.0) return;

    final newScale = (_scale * factor).clamp(_minScale, _maxScale);
    _panOffset = focalPoint - (focalPoint - _panOffset) * factor;
    _scale = newScale;
    notifyListeners();
  }

  /// Zoom by a factor centered on viewport center
  void zoomCentered(double factor, Size viewportSize) {
    final center = Offset(viewportSize.width / 2, viewportSize.height / 2);
    zoomAt(factor, center);
  }

  /// Zoom to a specific scale level
  void zoomTo(double targetScale, Size viewportSize) {
    final factor = targetScale / _scale;
    zoomCentered(factor, viewportSize);
  }

  /// Pan by a delta in canvas coordinates
  void pan(Offset delta) {
    if (!_panEnabled || delta == Offset.zero) return;
    _panOffset += delta;
    notifyListeners();
  }

  /// Pan to a specific offset
  void panTo(Offset newOffset) {
    if (!_panEnabled || newOffset == _panOffset) return;
    _panOffset = newOffset;
    notifyListeners();
  }

  /// Reset to initial state
  void reset() {
    if (_scale != 1.0 || _panOffset != Offset.zero) {
      _scale = 1.0;
      _panOffset = Offset.zero;
      notifyListeners();
    }
  }

  /// Check if currently zoomed in
  bool get isZoomedIn => _scale > 1.0;

  /// Check if currently zoomed out
  bool get isZoomedOut => _scale < 1.0;

  /// Check if at default zoom
  bool get isDefaultZoom => _scale == 1.0;

  /// Check if panned from origin
  bool get isPanned => _panOffset != Offset.zero;

  /// Get zoom percentage as integer
  int get zoomPercentage => (_scale * 100).round();
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Lifecycle awareness for viewport state
    // Subclasses can override to handle pause/resume
  }
  
  @override
  void dispose() {
    // CRITICAL: Remove observer on dispose to prevent memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
