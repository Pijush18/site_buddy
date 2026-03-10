import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

/// FILE HEADER
/// ----------------------------------------------
/// File: info_card.dart
/// Feature: core
/// Layer: presentation
///
/// PURPOSE:
/// Displays generic actionable or info cards, highly used in Recent Activity.
///
/// RESPONSIBILITIES:
/// - Renders a stylized horizontal card with an icon, title, subtitle, and dynamic status/time labels.
///
/// DEPENDENCIES:
/// - Core design constants (AppColors, AppSizes).
///
/// FUTURE IMPROVEMENTS:
/// - Provide different icon background colors depending on the Card's semantic meaning.
///
/// ----------------------------------------------

import 'package:flutter/material.dart';

/// CLASS: InfoCard
/// PURPOSE: Standard reusable component for displaying a summary of an entity (like a past log).
/// WHY: Consistency and easy maintenance of list-based reading experiences.
/// LOGIC: Uses AppTextStyles for global typography. Icon is centered in a primary-colored circle.
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? timeAgo;
  final String? statusText;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.timeAgo,
    this.statusText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppLayout.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppLayout.md),
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: AppLayout.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: SbTextStyles.title(context).copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (timeAgo != null)
                          Text(
                            timeAgo!,
                            style: SbTextStyles.bodySecondary(context).copyWith(fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppLayout.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subtitle,
                          style: SbTextStyles.body(context).copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        if (statusText != null)
                          Text(
                            statusText!,
                            style: SbTextStyles.bodySecondary(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}