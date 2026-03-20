import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';
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
  final EdgeInsets? margin;
  final bool isElevated;

  const SbModuleHero({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.child,
    this.gradientColors,
    this.margin,
    this.isElevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Premium Contrast: Highlighting surface containers more confidently
    final List<Color> colors = gradientColors ?? (isDark 
        ? [colorScheme.surfaceContainerHighest.withValues(alpha: 0.9), colorScheme.surface] 
        : [colorScheme.surfaceContainerHighest.withValues(alpha: 0.45), colorScheme.surface]);

    return SbCard(
      margin: margin ?? EdgeInsets.zero,
      padding: EdgeInsets.zero,
      isElevated: isElevated,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
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
                horizontal: SbSpacing.xl,
                vertical: SbSpacing.huge, // Premium vertical breathing room
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                    padding: const EdgeInsets.all(SbSpacing.lg),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      color: colorScheme.primary,
                      size: 34, // Slightly bolder icon
                    ),
                  ),
                  const SizedBox(height: SbSpacing.xxl),
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800, // Stronger visual confidence
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: SbSpacing.sm),
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
                    const SizedBox(height: SbSpacing.xxl),
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
