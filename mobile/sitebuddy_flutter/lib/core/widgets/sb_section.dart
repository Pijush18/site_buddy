import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_section_header.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_colors.dart';


/// CLASS: SbSection
/// PURPOSE: Standardized section wrapper with header + content.
/// REFINEMENT: Tightening the internal rhythm between header and content for a premium "one-piece" unit feel.
class SbSection extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const SbSection({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.trailing,
    this.onTap,
    this.padding,
  });


  @override
  Widget build(BuildContext context) {
    final bool hasHeader = title != null || trailing != null || onTap != null;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.colors.outline,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasHeader) ...[
                  SbSectionHeader(
                    title: title ?? '',
                    subtitle: subtitle,
                    trailing: trailing,
                    onTap: null, // Header onTap is removed as whole section is clickable
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}


