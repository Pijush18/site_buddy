import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// A reusable widget that provides the interior content for an action button.
/// Contains an icon and a label styled according to the design system.
class SbActionButtonContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const SbActionButtonContent({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: AppSpacing.xs), // Reduced spacing
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14, // Standardized 14px
            fontWeight: FontWeight.w600, // Standardized w600
            color: color,
          ),
        ),
      ],
    );
  }
}
