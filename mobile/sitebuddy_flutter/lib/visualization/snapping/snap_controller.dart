import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../primitives/primitives.dart';
import 'snap_engine.dart';
import 'snap_result.dart';
import 'snap_target.dart';

/// Provider for the snap engine
final snapEngineProvider = StateNotifierProvider<SnapController, SnapState>((ref) {
  return SnapController();
});

/// State for snap controller
class SnapState {
  final SnapConfig config;
  final SnapResult? lastSnap;
  final List<SnapTarget> nearbyTargets;
  final bool isEnabled;

  const SnapState({
    this.config = const SnapConfig(),
    this.lastSnap,
    this.nearbyTargets = const [],
    this.isEnabled = true,
  });

  SnapState copyWith({
    SnapConfig? config,
    SnapResult? lastSnap,
    List<SnapTarget>? nearbyTargets,
    bool? isEnabled,
  }) {
    return SnapState(
      config: config ?? this.config,
      lastSnap: lastSnap ?? this.lastSnap,
      nearbyTargets: nearbyTargets ?? this.nearbyTargets,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

/// Controller for managing snap behavior
class SnapController extends StateNotifier<SnapState> {
  final SnapEngine _engine = SnapEngine();

  SnapController() : super(const SnapState());

  /// Current snap configuration
  SnapConfig get config => state.config;

  /// Whether snapping is enabled
  bool get isEnabled => state.isEnabled;

  /// Update the primitives that can be snapped to
  void updatePrimitives(List<DiagramPrimitive> primitives) {
    _engine.updateTargets(primitives);
  }

  /// Update snap configuration
  void updateConfig(SnapConfig config) {
    _engine.config = config;
    state = state.copyWith(config: config);
  }

  /// Enable or disable snapping
  void setEnabled(bool enabled) {
    _engine.enabled = enabled;
    state = state.copyWith(isEnabled: enabled);
  }

  /// Toggle snapping on/off
  void toggleSnap() {
    setEnabled(!state.isEnabled);
  }

  /// Snap a point and return the result
  /// 
  /// [point] - Point in world coordinates
  /// [scale] - Current zoom scale
  /// [excludePrimitiveId] - Primitive to exclude from snapping
  SnapResult snap(
    Offset point, {
    double scale = 1.0,
    String? excludePrimitiveId,
  }) {
    if (!state.isEnabled) {
      return SnapResult.none(point);
    }

    final result = _engine.snap(
      point,
      scale: scale,
      excludePrimitiveId: excludePrimitiveId,
    );

    // Update nearby targets for visual feedback
    final nearby = _engine.getTargetsNear(point, state.config.snapRadius / scale);

    state = state.copyWith(
      lastSnap: result,
      nearbyTargets: nearby,
    );

    return result;
  }

  /// Get all snap targets near a point (for visual feedback)
  List<SnapTarget> getTargetsNear(Offset point, double scale) {
    return _engine.getTargetsNear(point, state.config.snapRadius / scale);
  }

  /// Get the current snap result
  SnapResult? get currentSnap => state.lastSnap;

  /// Clear the current snap state
  void clearSnap() {
    state = state.copyWith(lastSnap: null, nearbyTargets: []);
  }

  /// Get statistics about the snap engine
  int get targetCount => _engine.targetCount;
}

/// Extension for quick snap configuration changes
extension SnapConfigExtension on SnapController {
  /// Set grid snapping
  void setGridSnapping(bool enabled, {double? gridSize}) {
    updateConfig(config.copyWith(
      gridEnabled: enabled,
      gridSize: gridSize,
    ));
  }

  /// Set vertex snapping
  void setVertexSnapping(bool enabled) {
    updateConfig(config.copyWith(vertexEnabled: enabled));
  }

  /// Set edge snapping
  void setEdgeSnapping(bool enabled) {
    updateConfig(config.copyWith(edgeEnabled: enabled));
  }

  /// Set midpoint snapping
  void setMidpointSnapping(bool enabled) {
    updateConfig(config.copyWith(midpointEnabled: enabled));
  }

  /// Set alignment snapping
  void setAlignmentSnapping(bool enabled) {
    updateConfig(config.copyWith(alignmentEnabled: enabled));
  }

  /// Use CAD-style precision snapping
  void useCadStyle() {
    updateConfig(SnapConfig.cad);
  }

  /// Use loose/pixel-style snapping
  void useLooseStyle() {
    updateConfig(SnapConfig.loose);
  }

  /// Disable all snapping
  void disableAll() {
    updateConfig(SnapConfig.disabled);
  }
}
