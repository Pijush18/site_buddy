import 'package:site_buddy/core/theme/app_text_styles.dart';
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption(context).copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
