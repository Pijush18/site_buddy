import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// WIDGET: GhostButton
/// PURPOSE: Standardized text-only button.
class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final bool isLoading;

  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.width,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 44,
      child: TextButton(
        onPressed: (isLoading || onPressed == null)
            ? null 
            : () {
                HapticFeedback.lightImpact();
                onPressed!();
              },
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: SbSpacing.sm),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}
