import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:flutter/material.dart';

const _kNormalShadowLight = [
  BoxShadow(
    color: Color(0x1F000000), // black @ 12%
    blurRadius: 8,
    offset: Offset(0, 4),
  ),
];
const _kNormalShadowDark = [
  BoxShadow(
    color: Color(0x4D000000), // black @ 30%
    blurRadius: 8,
    offset: Offset(0, 4),
  ),
];
const _kPressedShadow = [
  BoxShadow(
    color: Color(0x1A000000), // black @ 10%
    blurRadius: 4,
    spreadRadius: 0,
    offset: Offset(0, 2),
  ),
];

class SbGridCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isVibrant;

  const SbGridCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isVibrant = false,
  });

  @override
  State<SbGridCard> createState() => _SbGridCardState();
}

class _SbGridCardState extends State<SbGridCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium Border Logic
    final borderColor = widget.isVibrant 
        ? Colors.white.withValues(alpha: 0.12) // Subtle glass edge
        : colorScheme.outline;
    
    // Sophisticated Soft Shadows
    final normalShadow = widget.isVibrant
        ? [
            BoxShadow(
              color: widget.color.withValues(alpha: isDark ? 0.45 : 0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
              spreadRadius: -2,
            )
          ]
        : (isDark ? _kNormalShadowDark : _kNormalShadowLight);

    final backgroundColor = widget.isVibrant ? widget.color : colorScheme.surface;
    final contentColor = widget.isVibrant ? Colors.white : colorScheme.onSurface;

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
              boxShadow: _pressed ? _kPressedShadow : normalShadow,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppLayout.pMedium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // High-Contrast Clean Icon
                  Icon(
                    widget.icon,
                    color: widget.isVibrant ? Colors.white : widget.color,
                    size: 32, // Slightly larger for "Professional Clean"
                  ),
                  AppLayout.vGap12, // More generous spacing
                  Text(
                    widget.label,
                    style: SbTextStyles.title(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                      fontSize: 15,
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