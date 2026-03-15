import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

class LayoutLabSection extends StatelessWidget {
  const LayoutLabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layout & Grid System',
          style: SbTextStyles.title(context),
        ),
        AppLayout.vGap16,
        const Text(
          'The SiteBuddy grid system enforces a maximum content width of 800px on all primary screens to ensure readability and professional presentation.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        AppLayout.vGap24,

        // Visualizer
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppLayout.cardRadius),
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
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '800.0',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Positioned(
                top: 8,
                left: 8,
                child: Text(
                  'Screen Edge',
                  style: TextStyle(fontSize: 8, color: Colors.grey),
                ),
              ),
              const Positioned(
                bottom: 8,
                right: 8,
                child: Text(
                  'Responsive Gutter',
                  style: TextStyle(fontSize: 8, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        AppLayout.vGap16,
        Text('Layout Rules:', style: SbTextStyles.body(context)),
        const Padding(
          padding: EdgeInsets.only(
            left: AppLayout.pSmall,
            top: AppLayout.pSmall,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• All feature screen content must be centered.',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                '• Sidebar navigation must remain fixed (not part of content width).',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                '• Use ConstrainedBox with AppLayout.maxContentWidth.',
                style: TextStyle(fontSize: 12),
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
