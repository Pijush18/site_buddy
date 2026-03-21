import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

const double _maxContentWidth = 800.0;

class LayoutLabSection extends StatelessWidget {
  const LayoutLabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layout & Grid System',
          style: Theme.of(context).textTheme.titleMedium!,
        ),
        const SizedBox(height: SbSpacing.lg),
        Text(
          'The SiteBuddy grid system enforces a maximum content width of 800px on all primary screens to ensure readability and professional presentation.',
          style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: SbSpacing.lg),

        // Visualizer
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: SbRadius.borderMd,
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Grid lines mock
              _GridLines(),

              // Max content width guide
              Container(
                width: 250, // Scaled down for preview
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    vertical: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.05),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'maxContentWidth',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '800.0',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 8,
                left: 8,
                child: Text(
                  'Screen Edge',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 8, color: Colors.grey),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Text(
                  'Responsive Gutter',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 8, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: SbSpacing.lg),
        Text('Layout Rules:', style: Theme.of(context).textTheme.bodyLarge!),
        Padding(
          padding: const EdgeInsets.all(SbSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• All feature screen content must be centered.',
                style: Theme.of(context).textTheme.bodySmall!,
              ),
              const Text(
                '• Sidebar navigation must remain fixed (not part of content width).',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                '• Use ConstrainedBox with $_maxContentWidth.',
                style: Theme.of(context).textTheme.bodySmall!,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GridLines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(
        Theme.of(context).dividerColor.withValues(alpha: 0.1),
      ),
      child: Container(),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}









