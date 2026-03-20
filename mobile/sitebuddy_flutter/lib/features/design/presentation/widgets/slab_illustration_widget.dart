import 'package:site_buddy/core/theme/app_layout.dart';


import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// FILE HEADER
/// ----------------------------------------------
/// File: slab_illustration_widget.dart
/// Feature: design
/// Layer: presentation/widgets
///
/// PURPOSE:
/// Visually represents different slab reinforcement patterns dynamically.
/// ----------------------------------------------

import 'package:flutter/material.dart';
import 'package:site_buddy/shared/domain/models/design/slab_type.dart';

/// CLASS: SlabIllustrationWidget
/// Switches between illustrations based on [SlabType].
class SlabIllustrationWidget extends StatelessWidget {
  final SlabType type;

  const SlabIllustrationWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 180,

      child: ClipRRect(
        borderRadius: AppLayout.borderRadiusCard,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Pattern
            Opacity(
              opacity: 0.05,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                ),
                itemBuilder: (context, index) =>
                    const SbCard(child: SizedBox.shrink()),
              ),
            ),

            // Dynamic Illustration based on SlabType
            _buildIllustration(type, colorScheme),

            // Label Overlay
            Positioned(
              bottom: AppLayout.spaceM,
              right: AppLayout.spaceM,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SbSpacing.sm,
                  vertical: AppLayout.spaceXS,
                ),

                child: Text(
                  type.label.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(SlabType type, ColorScheme colorScheme) {
    switch (type) {
      case SlabType.oneWay:
        return _OneWaySlabDiagram(color: colorScheme.primary);
      case SlabType.twoWay:
        return _TwoWaySlabDiagram(color: colorScheme.primary);
      case SlabType.continuous:
        return _ContinuousSlabDiagram(color: colorScheme.primary);
    }
  }
}

class _OneWaySlabDiagram extends StatelessWidget {
  final Color color;
  const _OneWaySlabDiagram({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(120, 80),
      painter: _OneWayPainter(color),
    );
  }
}

class _TwoWaySlabDiagram extends StatelessWidget {
  final Color color;
  const _TwoWaySlabDiagram({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: _TwoWayPainter(color),
    );
  }
}

class _ContinuousSlabDiagram extends StatelessWidget {
  final Color color;
  const _ContinuousSlabDiagram({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(160, 60),
      painter: _ContinuousPainter(color),
    );
  }
}

// Custom Painters for fallback illustrations
class _OneWayPainter extends CustomPainter {
  final Color color;
  _OneWayPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Slab Outline
    final outlinePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(4),
      ),
      outlinePaint,
    );

    // Main Reinforcement (One direction)
    for (double i = 10; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 5), Offset(i, size.height - 5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TwoWayPainter extends CustomPainter {
  final Color color;
  _TwoWayPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Slab Outline
    final outlinePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(4),
      ),
      outlinePaint,
    );

    // Main Reinforcement (Both directions)
    for (double i = 15; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 5), Offset(i, size.height - 5), paint);
    }
    for (double i = 15; i < size.height; i += 20) {
      canvas.drawLine(Offset(5, i), Offset(size.width - 5, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ContinuousPainter extends CustomPainter {
  final Color color;
  _ContinuousPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Multi-span line
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      linePaint,
    );

    // Continuous top/bottom bars
    final path = Path();
    path.moveTo(0, size.height / 2 + 10);
    path.lineTo(size.width / 3, size.height / 2 + 10);
    path.lineTo(size.width / 2, size.height / 2 - 10);
    path.lineTo(2 * size.width / 3, size.height / 2 - 10);
    path.lineTo(size.width, size.height / 2 + 10);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}








