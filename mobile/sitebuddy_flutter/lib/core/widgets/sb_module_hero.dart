import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';


/// WIDGET: SbModuleHero
/// PURPOSE: Professional, high-contrast header for major modules.
/// REFINEMENT: Premium vertical breathing room and stronger visual hierarchy.
class SbModuleHero extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? child;
  final List<Color>? gradientColors;
  const SbModuleHero({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.child,
    this.gradientColors,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Premium Contrast: Highlighting surface containers more confidently
    final List<Color> colors = gradientColors ??
        (isDark
            ? [
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
                colorScheme.surface
              ]
            : [
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                colorScheme.surface
              ]);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Micro-pattern Texture Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _HeroPatternPainter(
                color: colorScheme.primary.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Content with Premium Vertical Flow
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg, // Capped from xl (16px)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (child != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  child!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _HeroPatternPainter extends CustomPainter {
  final Color color;
  _HeroPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const spacing = 54.0;
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
