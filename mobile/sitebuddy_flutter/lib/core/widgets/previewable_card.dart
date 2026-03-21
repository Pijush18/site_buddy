import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

/// FILE HEADER
/// ----------------------------------------------
/// File: previewable_card.dart
/// Feature: core/widgets
/// Layer: presentation/widgets
///
/// PURPOSE:
/// Shared component for previewing and sharing report-like content.
/// Consolidates RepaintBoundary and ActionRow logic.
/// ----------------------------------------------

class PreviewableCard extends StatelessWidget {
  final Widget child;
  final GlobalKey previewKey;
  final String title;
  final List<PreviewAction> actions;

  const PreviewableCard({
    super.key,
    required this.child,
    required this.previewKey,
    required this.title,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: SbSpacing.xxl),
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 6), // 6px
              child: RepaintBoundary(key: previewKey, child: child),
            ),
          ),
        ),
        _buildActionRow(context),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SbSpacing.xxl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions
            .map((action) => _ActionButton(action: action))
            .toList(),
      ),
    );
  }
}

class PreviewAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const PreviewAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });
}

class _ActionButton extends StatelessWidget {
  final PreviewAction action;

  static const double _iconSize = 20.0;
  
  const _ActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    if (action.isPrimary) {
      return ElevatedButton.icon(
        onPressed: action.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: SbSpacing.xxl, vertical: SbSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: SbRadius.borderMedium,
          ),
        ),
        icon: Icon(
          action.icon,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        label: Text(
          action.label,
          style: theme.textTheme.labelMedium!,
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: action.onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(SbSpacing.lg),
        side: BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: SbRadius.borderMd,
        ),
      ),
      icon: Icon(action.icon, color: primaryColor, size: _iconSize),
      label: Text(
        action.label,
        style: theme.textTheme.labelMedium!,
      ),
    );
  }
}


