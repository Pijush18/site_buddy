import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// WIDGET: PrimaryCTA
/// PURPOSE: Standardized high-dominance button for SiteBuddy.
/// REPLACES: PrimaryCTA
class PrimaryCTA extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const PrimaryCTA({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: (isLoading || onPressed == null) 
            ? null 
            : () {
                HapticFeedback.lightImpact();
                onPressed!();
              },
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary),
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
