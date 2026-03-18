import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:site_buddy/core/theme/app_spacing.dart';

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
    this.margin,
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
    final borderColor = widget.isVibrant 
        ? colorScheme.onPrimary.withValues(alpha: 0.12) // Subtle glass edge
        : colorScheme.outline;
    
    final backgroundColor = widget.isVibrant ? widget.color : colorScheme.surface;
    final contentColor = widget.isVibrant ? colorScheme.onPrimary : colorScheme.onSurface;

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
            margin: widget.margin ?? const EdgeInsets.all(AppSpacing.sm),
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: AppLayout.borderRadiusCard,
              border: Border.all(color: borderColor, width: 1.2),
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
              padding: const EdgeInsets.all(AppLayout.pMedium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // High-Contrast Clean Icon
                  Icon(
                    widget.icon,
                    color: widget.isVibrant ? colorScheme.onPrimary : widget.color,
                    size: 24, // Standardized 24px (matches SbActionButtonContent)
                  ),
                  const SizedBox(height: 4), // Standardized 4px gap
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 14, // Standardized 14px
                      fontWeight: FontWeight.w600, // Standardized w600
                      color: contentColor,
                    ),
                    textAlign: TextAlign.center,
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