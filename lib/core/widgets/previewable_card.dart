import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

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

import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.symmetric(vertical: AppLayout.pLarge),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppLayout.pTiny + 2,
              ), // 6px
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
      padding: const EdgeInsets.all(AppLayout.pLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
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
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayout.pLarge,
            vertical: AppLayout.pMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppLayout.borderRadiusCard,
          ),
        ),
        icon: Icon(action.icon, color: Colors.white),
        label: Text(
          action.label,
          style: SbTextStyles.caption(context).copyWith(color: Colors.white),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: action.onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppLayout.pMedium,
          vertical: AppLayout.pMedium,
        ),
        side: BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        ),
      ),
      icon: Icon(action.icon, color: primaryColor, size: 20),
      label: Text(
        action.label,
        style: SbTextStyles.caption(context).copyWith(color: primaryColor),
      ),
    );
  }
}