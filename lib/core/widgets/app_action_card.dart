import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:flutter/material.dart';

import 'package:site_buddy/core/constants/ui_duration.dart';

/// CLASS: AppActionCard
/// PURPOSE: Standard interactive grid tile for root workflow executions.
/// REFINED: Fully theme-aware using ColorScheme to ensure contrast and readability.
class AppActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AppActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<AppActionCard> createState() => _AppActionCardState();
}

class _AppActionCardState extends State<AppActionCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: UiDuration.fast,
      decoration:
          BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: AppLayout.borderRadiusCard,
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.30
                      : 0.12,
                ),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ).copyWith(
            border: Border.all(
              color: _isHovering ? colorScheme.primary : colorScheme.outline,
              width: _isHovering ? 1.5 : 1.0,
            ),
          ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: widget.onTap,
          onHover: (hovering) {
            setState(() {
              _isHovering = hovering;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(AppLayout.pMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedContainer(
                      duration: UiDuration.fast,
                      padding: const EdgeInsets.all(AppLayout.pSmall),
                      decoration: BoxDecoration(
                        color: _isHovering
                            ? colorScheme.primary.withValues(alpha: 0.15)
                            : colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon,
                        size: 24,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppLayout.pSmall),
                Flexible(
                  child: Text(
                    widget.label,
                    style: SbTextStyles.title(context).copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}