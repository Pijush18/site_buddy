import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_section_header.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SbRadius.standard),
        border: Border.all(
          color: colorScheme.outline,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(SbSpacing.md),
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
                  const SizedBox(height: SbSpacing.sm),
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


