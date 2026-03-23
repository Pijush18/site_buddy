import 'package:flutter/material.dart';
import '../primitives/primitives.dart' show CoordinateMapper;
import 'snap_engine.dart';
import 'snap_result.dart';
import 'snap_target.dart';

/// Visual overlay for snap indicators
/// Shows snap points and guides during interactions
class SnapOverlay extends StatelessWidget {
  /// Current snap result to display
  final SnapResult? currentSnap;

  /// All nearby snap targets for visual feedback
  final List<SnapTarget> nearbyTargets;

  /// Coordinate mapper for world-to-canvas conversion
  final CoordinateMapper mapper;

  /// Current scale for proper rendering
  final double scale;

  const SnapOverlay({
    super.key,
    this.currentSnap,
    this.nearbyTargets = const [],
    required this.mapper,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SnapOverlayPainter(
        currentSnap: currentSnap,
        nearbyTargets: nearbyTargets,
        mapper: mapper,
        scale: scale,
      ),
      size: Size.infinite,
    );
  }
}

class _SnapOverlayPainter extends CustomPainter {
  final SnapResult? currentSnap;
  final List<SnapTarget> nearbyTargets;
  final CoordinateMapper mapper;
  final double scale;

  _SnapOverlayPainter({
    this.currentSnap,
    required this.nearbyTargets,
    required this.mapper,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw nearby snap targets (faded)
    _drawNearbyTargets(canvas);

    // Draw current snap indicator
    if (currentSnap != null && currentSnap!.hasSnapped) {
      _drawCurrentSnap(canvas);
    }
  }

  void _drawNearbyTargets(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    for (final target in nearbyTargets) {
      final canvasPos = mapper.worldToCanvas(target.position);

      // Color based on type
      switch (target.type) {
        case SnapType.vertex:
          paint.color = const Color(0xFF4CAF50).withOpacity(0.6);
          break;
        case SnapType.midpoint:
          paint.color = const Color(0xFF2196F3).withOpacity(0.6);
          break;
        case SnapType.center:
          paint.color = const Color(0xFFFF9800).withOpacity(0.6);
          break;
        default:
          paint.color = Colors.grey.withOpacity(0.4);
      }

      // Draw crosshair
      final crossSize = 4.0 / scale;
      canvas.drawLine(
        Offset(canvasPos.dx - crossSize, canvasPos.dy),
        Offset(canvasPos.dx + crossSize, canvasPos.dy),
        paint..style = PaintingStyle.stroke..strokeWidth = 1,
      );
      canvas.drawLine(
        Offset(canvasPos.dx, canvasPos.dy - crossSize),
        Offset(canvasPos.dx, canvasPos.dy + crossSize),
        paint..style = PaintingStyle.stroke..strokeWidth = 1,
      );
    }
  }

  void _drawCurrentSnap(Canvas canvas) {
    final snap = currentSnap!;
    final canvasPos = mapper.worldToCanvas(snap.snappedPoint);

    // Draw snap point highlight
    final pointPaint = Paint()
      ..color = _getSnapColor(snap.type)
      ..style = PaintingStyle.fill;

    final ringPaint = Paint()
      ..color = _getSnapColor(snap.type).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Outer ring
    canvas.drawCircle(canvasPos, 8 / scale, ringPaint);
    // Inner point
    canvas.drawCircle(canvasPos, 3 / scale, pointPaint);

    // Draw guide lines for alignment snaps
    if (snap.type == SnapType.alignment) {
      _drawAlignmentGuides(canvas, canvasPos, snap.snappedPoint);
    }
  }

  void _drawAlignmentGuides(Canvas canvas, Offset canvasPos, Offset worldPos) {
    final guidePaint = Paint()
      ..color = const Color(0xFF00BCD4).withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Get canvas size
    final size = canvas.getLocalClipBounds().size;

    // Determine if snapped horizontally or vertically
    // This is a simplified implementation
    canvas.drawLine(
      Offset(0, canvasPos.dy),
      Offset(size.width, canvasPos.dy),
      guidePaint,
    );
    canvas.drawLine(
      Offset(canvasPos.dx, 0),
      Offset(canvasPos.dx, size.height),
      guidePaint,
    );
  }

  Color _getSnapColor(SnapType type) {
    switch (type) {
      case SnapType.vertex:
        return const Color(0xFF4CAF50); // Green
      case SnapType.midpoint:
        return const Color(0xFF2196F3); // Blue
      case SnapType.edge:
        return const Color(0xFF9C27B0); // Purple
      case SnapType.alignment:
        return const Color(0xFF00BCD4); // Cyan
      case SnapType.grid:
        return const Color(0xFF607D8B); // Blue Grey
      case SnapType.center:
        return const Color(0xFFFF9800); // Orange
      default:
        return Colors.grey;
    }
  }

  @override
  bool shouldRepaint(covariant _SnapOverlayPainter oldDelegate) {
    return currentSnap != oldDelegate.currentSnap ||
        nearbyTargets.length != oldDelegate.nearbyTargets.length;
  }
}
