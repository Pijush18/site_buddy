import 'package:flutter/material.dart';


/// WIDGET: SbModuleHero
/// PURPOSE: Professional, neutral-toned header for major modules.
/// REFACTOR: Professional Color System (Simplified, soft gradients).
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
    final isDark = theme.brightness == Brightness.dark;

    // 🔬 Neutral Tinted Strategy: Soft container surface with a hint of branding.
    final List<Color> colors = gradientColors ?? (isDark 
        ? [colorScheme.surfaceContainerHighest.withValues(alpha: 0.8), colorScheme.surface] 
        : [colorScheme.surfaceContainerHighest.withValues(alpha: 0.3), colorScheme.surface]);

    return Container(
      width: double.infinity,
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: colorScheme.surface, // Base fallback
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline, // 👈 Standardized theme outline
          width: 1.0,
        ),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(
              alpha: isDark ? 0.2 : 0.08,
            ), // 👈 Stronger lift for Hero
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Texture Overlay - Desaturated for focus
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroPatternPainter(
                  color: colorScheme.primary.withValues(alpha: 0.02),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: colorScheme.primary, // 👈 Pure primary branding
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface, // 👈 Soft, high-readability title
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (child != null) ...[
                    const SizedBox(height: 12),
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

    const spacing = 48.0;
    
    // Draw diagonal grid
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
