import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/theme/app_colors.dart';

/// WIDGET: SecondaryButton
/// PURPOSE: Standardized secondary or outlined button.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = isOutlined 
        ? OutlinedButton.styleFrom() 
        : OutlinedButton.styleFrom(
            backgroundColor: context.colors.surface,
            foregroundColor: context.colors.onSurface,
          );

    return SizedBox(
      width: width,
      height: 40,
      child: OutlinedButton(
        style: style,
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
