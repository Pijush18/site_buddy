import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_border.dart';


class SbGridCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isVibrant;
  final EdgeInsetsGeometry? margin;

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
  static const double _iconSize = 22.0; // Standard icon size for GridCard
  static const double _labelHeight = 48.0; // Standard label container height
  
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = widget.isVibrant ? widget.color : colorScheme.surfaceContainerHighest;

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Material(
        color: backgroundColor,
        borderRadius: SbRadius.borderMedium,
        elevation: 0,
        child: InkWell(
          borderRadius: SbRadius.borderMedium,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            margin: widget.margin ?? EdgeInsets.zero,
            padding: const EdgeInsets.all(SbSpacing.md),
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: SbRadius.borderMedium,
              border: Border.all(
                color: context.colors.outline,
                width: AppBorder.width,
              ),
              gradient: widget.isVibrant
                  ? LinearGradient(
                      colors: [
                        widget.color,
                        widget.color.withValues(alpha: 0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: SbSpacing.xs),
                  child: Icon(
                    widget.icon,
                    color: widget.isVibrant ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                    size: _iconSize, 
                  ),
                ),
                const SizedBox(height: SbSpacing.sm),
                SizedBox(
                  height: _labelHeight,
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
    );
  }
}
