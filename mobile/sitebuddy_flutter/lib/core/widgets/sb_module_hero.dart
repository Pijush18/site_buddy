import 'package:flutter/material.dart';

import 'package:site_buddy/core/theme/app_border.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

/// WIDGET: SbModuleHero
/// PURPOSE: Premium hero card used as the primary header for major modules.
/// DESIGN: 
/// - Professional gradient from Primary to PrimaryDark.
/// - Subtle blueprint/geometric pattern overlay for "Engineering" feel.
/// - Integrated icon, title, and subtitle structure.
class SbModuleHero extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? child;
  final List<Color>? gradientColors;
  final EdgeInsets? margin;

  const SbModuleHero({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.child,
    this.gradientColors,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Professional Grade Gradient - Softened for Optical Balance
    final colors = gradientColors ?? [
      colorScheme.primary.withValues(alpha: 0.9), // Muted start
      Color.lerp(colorScheme.primary, colorScheme.surfaceContainerHighest, 0.3)!, // Desaturated end
    ];

    return Container(
      width: double.infinity,
      margin: margin ?? EdgeInsets.zero, // Default to zero for layout-managed edges
      decoration: BoxDecoration(
        borderRadius: AppLayout.borderRadiusCard,
        border: Border.all(
          color: AppColors.outlineStrong(context).withValues(alpha: 0.5), // Subtle border
          width: AppBorder.width,
        ),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: AppLayout.borderRadiusCard,
        child: Stack(
          children: [
            // Texture Overlay (Blueprint Effect) - Lightened
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroPatternPainter(
                  color: colorScheme.onPrimary.withValues(alpha: 0.03),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12.0), // Tightened for reduced visual mass
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Clean Sharp Icon (no background shading)
                      Icon(
                        icon,
                        color: colorScheme.onPrimary,
                        size: 28, // Slightly smaller icon
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                        style: TextStyle(
                            fontSize: 17, // Slightly normalized title
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4), // Tightened gap
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      subtitle,
                      style: SbTextStyles.body(context).copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (child != null) ...[
                    const SizedBox(height: 12), // Balanced gap to child
                    child!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Subtle geometric pattern painter
class _HeroPatternPainter extends CustomPainter {
  final Color color;
  _HeroPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    
    // Draw diagonal grid
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
    
    for (double i = 0; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
