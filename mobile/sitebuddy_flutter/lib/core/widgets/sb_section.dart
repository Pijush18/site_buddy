import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

/// CLASS: SbSection
/// PURPOSE: A standardized section header and content wrapper for SiteBuddy screens.
class SbSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const SbSection({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: SbTextStyles.title(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null) ...[trailing!],
          ],
        ),
        AppLayout.vGap8,
        child,
      ],
    );
  }
}
