import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:site_buddy/core/theme/app_spacing.dart';
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
    
    // Professional Grade Gradient
    final colors = gradientColors ?? [
      colorScheme.primary,
      colorScheme.primary.withValues(alpha: 0.8), // Tonal shift
    ];

    return Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: AppLayout.borderRadiusCard,
        border: Border.all(
          color: colorScheme.onPrimary.withValues(alpha: 0.15),
          width: 1.2,
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
            // Texture Overlay (Blueprint Effect)
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroPatternPainter(
                  color: colorScheme.onPrimary.withValues(alpha: 0.05),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(AppLayout.pLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Clean Sharp Icon (no background shading)
                      Icon(
                        icon,
                        color: colorScheme.onPrimary,
                        size: 32,
                      ),
                      AppLayout.hGap16,
                      Expanded(
                        child: Text(
                          title,
                        style: TextStyle(
                            fontSize: 18, // Global Standard: Hero Title
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppLayout.vGap8,
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      subtitle,
                      style: SbTextStyles.body(context).copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                    ),
                  ),
                  if (child != null) ...[
                    AppLayout.vGap16,
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
