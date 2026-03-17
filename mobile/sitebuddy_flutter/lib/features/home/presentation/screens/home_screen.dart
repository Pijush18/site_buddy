import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/features/home/presentation/widgets/ai_assistant_widget.dart';
import 'package:site_buddy/features/home/presentation/widgets/recent_activity_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenWrapper(
      title: AppStrings.appName,
      actions: [
        IconButton(
          icon: const Icon(SbIcons.settings),
          onPressed: () => context.push('/settings'),
        ),
        const SizedBox(width: AppSpacing.sm), // Replaced AppLayout.hGap8
      ],
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800, // Replaced maxContentWidth
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Hero ──
              const AiAssistantWidget(),
              const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

              // ── 2. Field Tools ──
              const _FieldToolsSection(),
              const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

              // ── 3. Quick Actions ──
              const _QuickActionsSection(),
              const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

              // ── 4. Recent Activity ──
              SbSection(
                title: AppStrings.recentActivity,
                trailing: SbButton.ghost(
                  label: AppStrings.viewAll,
                  icon: SbIcons.chevronRight,
                  onPressed: () => context.push('/projects'),
                ),
                child: const RecentActivitySection(),
              ),
              const SizedBox(height: AppSpacing.lg), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section 1: Field Tools Grid ─────────────────────────────────────────────
class _FieldToolsSection extends StatelessWidget {
  const _FieldToolsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SbSection(
      title: AppStrings.fieldTools,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        mainAxisSpacing: AppSpacing.md, // Replaced AppLayout.vGap16
        crossAxisSpacing: AppSpacing.md, // Replaced AppLayout.hGap16
        childAspectRatio: 1.0,
        children: [
          SbGridCard(
            icon: SbIcons.ruler,
            label: EngineeringTerms.levelCalculator,
            color: colorScheme.primary,
            isVibrant: true,
            onTap: () => context.push('/level'),
          ),
          SbGridCard(
            icon: SbIcons.architecture,
            label: EngineeringTerms.gradientTool,
            color: colorScheme.primary,
            isVibrant: true,
            onTap: () => context.push('/calculator/gradient'),
          ),
          SbGridCard(
            icon: SbIcons.swap,
            label: AppStrings.unitConverter,
            color: colorScheme.primary,
            isVibrant: true,
            onTap: () => context.push('/converter'),
          ),
          SbGridCard(
            icon: SbIcons.sync,
            label: AppStrings.currencyConverter,
            color: colorScheme.primary,
            isVibrant: true,
            onTap: () => context.push('/currency'),
          ),
        ],
      ),
    );
  }
}

// ─── Section 2: Quick Actions Bar ────────────────────────────────────────────
class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbSection(
      title: AppStrings.quickActions,
      child: Row(
        children: [
          // New Project — primary
          Expanded(
            child: Material(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12), // Replaced AppLayout.borderRadiusCard
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push('/projects/create'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: AppSpacing.md, // Replaced AppLayout.pMedium
                  ),
                  child: Column(
                    children: [
                      Icon(
                        SbIcons.addCircle,
                        color: colorScheme.onPrimary,
                        size: 24,
                      ),
                      const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
                      Text(
                        AppStrings.newProject,
                        style: TextStyle(
                          fontSize: AppFontSizes.title,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
          // Share Report — secondary
          Expanded(
            child: Material(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(12), // Replaced AppLayout.borderRadiusCard
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push('/reports'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: AppSpacing.md, // Replaced AppLayout.pMedium
                  ),
                  child: Column(
                    children: [
                      Icon(
                        SbIcons.iosShare,
                        color: colorScheme.onSecondary,
                        size: 24,
                      ),
                      const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
                      Text(
                        AppStrings.shareReport,
                        style: TextStyle(
                          fontSize: AppFontSizes.title,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
