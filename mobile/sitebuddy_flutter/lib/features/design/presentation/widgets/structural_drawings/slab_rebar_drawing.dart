import 'package:flutter/material.dart';


/// WIDGET: SlabRebarDrawing
/// PURPOSE: Plan view visualization for Slab Reinforcement grids.
class SlabRebarDrawing extends StatelessWidget {
  final double lx; // m
  final double ly; // m
  final double depth; // mm
  final String mainSteel;
  final String distributionSteel;

  const SlabRebarDrawing({
    super.key,
    required this.lx,
    required this.ly,
    required this.depth,
    required this.mainSteel,
    required this.distributionSteel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final textColor = colorScheme.onSurface;

    return AspectRatio(
      aspectRatio: lx / ly > 1.5 ? 1.5 : (lx / ly < 0.6 ? 0.6 : lx / ly),
      child: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: CustomPaint(
                size: Size.infinite,
                painter: _SlabPainter(
                  lx: lx,
                  ly: ly,
                  primaryColor: primaryColor,
                  textColor: textColor,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Slab Plan: ${lx.toStringAsFixed(2)}m x ${ly.toStringAsFixed(2)}m',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlabPainter extends CustomPainter {
  final double lx;
  final double ly;
  final Color primaryColor;
  final Color textColor;

  _SlabPainter({
    required this.lx,
    required this.ly,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = textColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final mainBarPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final distBarPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cx = size.width / 2;
    final cy = size.height / 2;
    const padding = 20.0;

    double aspect = lx / ly;
    double w = size.width - 2 * padding;
    double h = w / aspect;
    if (h > size.height - 2 * padding) {
      h = size.height - 2 * padding;
      w = h * aspect;
    }

    final rect = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);
    canvas.drawRect(rect, paint);

    // Main Reinforcement (Along Lx - shorter span usually)
    int numMain = 10;
    for (int i = 0; i <= numMain; i++) {
      double xPos = rect.left + (rect.width / numMain) * i;
      canvas.drawLine(
        Offset(xPos, rect.top + 5),
        Offset(xPos, rect.bottom - 5),
        mainBarPaint,
      );
    }

    // Distribution Steel (Along Ly)
    int numDist = 6;
    for (int i = 0; i <= numDist; i++) {
      double yPos = rect.top + (rect.height / numDist) * i;
      canvas.drawLine(
        Offset(rect.left + 5, yPos),
        Offset(rect.right - 5, yPos),
        distBarPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}








