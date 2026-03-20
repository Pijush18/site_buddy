import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/theme/app_colors.dart';

class SbGridCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isVibrant;
  final EdgeInsets? margin;

  const SbGridCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isVibrant = false,
    this.margin = EdgeInsets.zero,
  });

  @override
  State<SbGridCard> createState() => _SbGridCardState();
}

class _SbGridCardState extends State<SbGridCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Premium Border Logic
    // Sky Blue Border Hierarchy (High Visibility: 70% Opacity)
    final currentBorderColor = AppColors.skyBlue.withValues(alpha: 0.7);
    
    final backgroundColor = widget.isVibrant ? widget.color : colorScheme.surfaceContainerHighest;

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Material(
        color: backgroundColor,
        borderRadius: AppLayout.borderRadiusCard,
        elevation: 0,
        child: InkWell(
          borderRadius: AppLayout.borderRadiusCard,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            margin: widget.margin ?? EdgeInsets.zero,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: AppLayout.borderRadiusCard,
              border: Border.all(color: currentBorderColor, width: 1.0),
              gradient: widget.isVibrant
                  ? LinearGradient(
                      colors: [
                        widget.color,
                        widget.color.withValues(alpha: 0.9), // Subtle shift
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(SbSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // High-Contrast Clean Icon with Optical Bias
                  Padding(
                    padding: const EdgeInsets.only(top: 2), // Optical bias padding top: 2
                    child: Icon(
                      widget.icon,
                      color: widget.isVibrant ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                      size: 22, 
                    ),
                  ),
                  const SizedBox(height: SbSpacing.sm), // Standardized gap
                  SizedBox(
                    height: 48, // Fixed height constraint to ensure multiline/single line labels don't change card sizes.
                    child: Center(
                      child: Text(
                        widget.label,
                        style: Theme.of(context).textTheme.labelLarge!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


