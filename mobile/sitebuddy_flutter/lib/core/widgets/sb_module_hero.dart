import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
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
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        border: Border.all(
          color: AppColors.skyBlue.withValues(alpha: 0.7),
          width: 1.0,
        ),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
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
              padding: const EdgeInsets.all(AppSpacing.sm),
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
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.body(context, secondary: true).copyWith(
                            color: colorScheme.onSurface, // 👈 Soft, high-readability title
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.xs),
                    child: Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (child != null) ...[
                    const SizedBox(height: AppSpacing.sm),
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
