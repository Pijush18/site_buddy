import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_interactive_card.dart';


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
  static const double _iconSize = 22.0; 
  static const double _labelHeight = 40.0; // Compacted from 48

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = widget.isVibrant ? widget.color : colorScheme.surfaceContainerHighest;

    return SbInteractiveCard(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(SbRadius.standard),
      child: AnimatedContainer(
        margin: widget.margin ?? EdgeInsets.zero,
        padding: const EdgeInsets.all(SbSpacing.md),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(SbRadius.standard),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1.0,
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
            Icon(
              widget.icon,
              color: widget.isVibrant ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
              size: _iconSize, 
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
    );
  }
}
