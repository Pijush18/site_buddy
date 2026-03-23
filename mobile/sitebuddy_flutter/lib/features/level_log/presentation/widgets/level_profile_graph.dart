import 'package:site_buddy/core/theme/app_spacing.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_entry.dart';

/// WIDGET: LevelProfileGraph
/// PURPOSE: Visualizes the ground profile based on survey Reduced Levels (RL).
class LevelProfileGraph extends StatelessWidget {
  final List<LevelEntry> entries;
  final double height;

  const LevelProfileGraph({
    super.key,
    required this.entries,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    // Filter entries that have a calculated RL
    final validPoints = entries
        .asMap()
        .entries
        .where((e) => e.value.rl != null)
        .map(
          (e) => _ProfilePoint(
            x: e.value.chainage ?? (e.key * 20.0),
            y: e.value.rl!,
            label: e.value.station,
          ),
        )
        .toList();

    if (validPoints.length < 2) {
      return Container(
        height: height,
        alignment: Alignment.center,
        child: Text(
          'Add at least 2 stations with readings to view profile',
          style: Theme.of(context).textTheme.labelMedium!,
        ),
      );
    }

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xxl),
      child: CustomPaint(
        size: Size.infinite,
        painter: _ProfilePainter(
          points: validPoints,
          colorScheme: Theme.of(context).colorScheme,
          labelStyle: Theme.of(context).textTheme.labelMedium!,
        ),
      ),
    );
  }
}

class _ProfilePoint {
  final double x;
  final double y;
  final String label;

  _ProfilePoint({required this.x, required this.y, required this.label});
}

class _ProfilePainter extends CustomPainter {
  final List<_ProfilePoint> points;
  final ColorScheme colorScheme;
  final TextStyle labelStyle;

  _ProfilePainter({
    required this.points,
    required this.colorScheme,
    required this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final axisPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = colorScheme.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.fill;

    // Find bounds for normalization
    double minY = points.map((p) => p.y).reduce(min);
    double maxY = points.map((p) => p.y).reduce(max);
    double rangeY = maxY - minY;

    if (rangeY < 1.0) {
      minY -= 0.5;
      maxY += 0.5;
      rangeY = 1.0;
    } else {
      minY -= rangeY * 0.2;
      maxY += rangeY * 0.2;
      rangeY = maxY - minY;
    }

    final double minX = points.first.x;
    final double maxX = points.last.x;
    final double rangeX = max(1.0, maxX - minX);

    double getX(double x) => (x - minX) / rangeX * size.width;
    double getY(double y) => size.height - ((y - minY) / rangeY * size.height);

    const int horizontalLines = 4;
    for (int i = 0; i <= horizontalLines; i++) {
      double y = size.height * (i / horizontalLines);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), axisPaint);

      final labelValue = maxY - (i / horizontalLines * rangeY);
      final textPainter = TextPainter(
        text: TextSpan(
          text: labelValue.toStringAsFixed(1),
          style: labelStyle.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width - 5, y - textPainter.height / 2),
      );
    }

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final x = getX(p.x);
      final y = getY(p.y);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      if (i == points.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    for (var p in points) {
      final x = getX(p.x);
      final y = getY(p.y);

      canvas.drawCircle(Offset(x, y), 4, dotPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: p.label,
          style: labelStyle.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProfilePainter oldDelegate) => true;
}
