import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// WIDGET: AppIconButton
/// PURPOSE: Standardized icon-only button.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool compact;
  final bool isLoading;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.compact = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 36.0 : 44.0;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
        icon: isLoading 
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Icon(icon, color: colorScheme.primary),
        onPressed: (isLoading || onPressed == null) 
            ? null 
            : () {
                HapticFeedback.lightImpact();
                onPressed!();
              },
        tooltip: tooltip,
        iconSize: 20,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(minWidth: size, minHeight: size),
      ),
    );
  }
}
