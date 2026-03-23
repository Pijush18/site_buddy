import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/widgets/sb_interactive_card.dart';
import 'package:site_buddy/features/design/domain/models/design_tool.dart';

/// WIDGET: DesignCard
/// PURPOSE: Standardized card for structural design tools.
/// HANDLES: Enabled/Disabled states and navigation/feedback.
class DesignCard extends StatelessWidget {
  final DesignTool tool;

  const DesignCard({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SbInteractiveCard(
      onTap: () {
        if (tool.isEnabled) {
          context.push(tool.route);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${tool.title} is Coming Soon!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(SbRadius.standard),
      child: Container(
        padding: const EdgeInsets.all(SbSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(SbRadius.standard),
          border: Border.all(
            color: tool.isEnabled 
                ? colorScheme.outlineVariant 
                : colorScheme.outlineVariant.withAlpha(102), // 0.4 opacity
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: tool.isEnabled ? 1.0 : 0.4,
              child: Icon(
                tool.icon,
                size: 32,
                color: tool.isEnabled ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: SbSpacing.sm),
            Text(
              tool.title,
              textAlign: TextAlign.center,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: tool.isEnabled ? colorScheme.onSurface : colorScheme.onSurfaceVariant.withAlpha(153), // 0.6 opacity
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (!tool.isEnabled) ...[
              const SizedBox(height: 4),
              Text(
                'Coming Soon',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary.withAlpha(179), // 0.7 opacity
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
