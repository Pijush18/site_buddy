/// Performance metrics
class PerformanceMetrics {
  final int primitiveCount;
  final int visiblePrimitiveCount;
  final double renderTimeMs;
  final double frameTimeMs;
  final int drawCalls;
  final int memoryUsageBytes;

  const PerformanceMetrics({
    required this.primitiveCount,
    required this.visiblePrimitiveCount,
    required this.renderTimeMs,
    required this.frameTimeMs,
    required this.drawCalls,
    required this.memoryUsageBytes,
  });
}

/// Performance profiling interface
abstract class PerformanceProfiler {
  /// Start profiling frame
  void beginFrame();

  /// End profiling frame
  void endFrame();

  /// Get current metrics
  PerformanceMetrics getMetrics();

  /// Get frame history
  List<PerformanceMetrics> getFrameHistory(int count);

  /// Reset counters
  void reset();

  /// Enable/disable profiling
  void setEnabled(bool enabled);
}

/// Culling strategy
enum CullingStrategy {
  none,
  boundingBox,
  occlusion,
  frustum,
}

/// Rendering optimization interface
abstract class RenderOptimizer {
  /// Set culling strategy
  void setCullingStrategy(CullingStrategy strategy);

  /// Enable/disable level of detail
  void setLodEnabled(bool enabled);

  /// Set LOD thresholds
  void setLodThresholds(double near, double mid, double far);

  /// Get optimized primitive list
  List<T> cullPrimitives<T>(List<T> primitives);
}
