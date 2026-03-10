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

  const SbGridCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
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

    final borderColor = colorScheme.outline;
    final normalShadow = isDark ? _kNormalShadowDark : _kNormalShadowLight;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppLayout.borderRadiusCard,
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: _pressed ? _kPressedShadow : normalShadow,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppLayout.pMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: 0.12),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 26),
                ),
                const SizedBox(height: AppLayout.pSmall),
                Text(
                  widget.label,
                  style: SbTextStyles.title(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}