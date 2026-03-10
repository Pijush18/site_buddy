import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/features/home/presentation/widgets/ai_assistant_widget.dart';
import 'package:site_buddy/features/home/presentation/widgets/recent_activity_section.dart';

import 'package:site_buddy/core/localization/generated/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SbPage.scaffold(
      title: l10n.appName,
      appBarActions: [
        SbButton.icon(
          icon: SbIcons.settings,
          onPressed: () => context.push('/settings'),
        ),
        AppLayout.hGap8,
      ],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Hero ──
                const AiAssistantWidget(),
                AppLayout.vGap24,

                // ── 2. Field Tools ──
                const _FieldToolsSection(),
                AppLayout.vGap24,

                // ── 3. Quick Actions ──
                const _QuickActionsSection(),
                AppLayout.vGap24,

                // ── 4. Recent Activity ──
                SbSection(
                  title: l10n.recentActivity,
                  trailing: SbButton.ghost(
                    label: l10n.viewAll,
                    icon: SbIcons.chevronRight,
                    onPressed: () => context.push('/projects'),
                  ),
                  child: const RecentActivitySection(),
                ),
                AppLayout.vGap24,
              ],
            ),
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SbSection(
      title: l10n.fieldTools,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        mainAxisSpacing: AppLayout.pLarge,
        crossAxisSpacing: AppLayout.pLarge,
        childAspectRatio: 1.0,
        children: [
          SbGridCard(
            icon: SbIcons.ruler,
            label: l10n.levelCalc,
            color: colorScheme.primary,
            onTap: () => context.push('/level'),
          ),
          SbGridCard(
            icon: SbIcons.architecture,
            label: l10n.gradient,
            color: colorScheme.primary,
            onTap: () => context.push('/calculator/gradient'),
          ),
          SbGridCard(
            icon: SbIcons.swap,
            label: l10n.converter,
            color: colorScheme.primary,
            onTap: () => context.push('/converter'),
          ),
          SbGridCard(
            icon: SbIcons.sync,
            label: l10n.currency,
            color: colorScheme.primary,
            onTap: () {
              debugPrint("TODO: implement Currency Converter navigation");
            },
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbSection(
      title: l10n.quickActions,
      child: Row(
        children: [
          // New Project — primary
          Expanded(
            child: Material(
              color: colorScheme.primary,
              borderRadius: AppLayout.borderRadiusCard,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push('/projects/create'),
                child: Padding(
                  padding: AppLayout.paddingMedium,
                  child: Column(
                    children: [
                      Icon(
                        SbIcons.addCircle,
                        color: colorScheme.onPrimary,
                        size: 24,
                      ),
                      AppLayout.vGap8,
                      Text(
                        l10n.newProject,
                        style: SbTextStyles.title(context).copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AppLayout.hGap16,
          // Share Report — secondary
          Expanded(
            child: Material(
              color: colorScheme.secondary,
              borderRadius: AppLayout.borderRadiusCard,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push('/reports'),
                child: Padding(
                  padding: AppLayout.paddingMedium,
                  child: Column(
                    children: [
                      Icon(
                        SbIcons.iosShare,
                        color: colorScheme.onSecondary,
                        size: 24,
                      ),
                      AppLayout.vGap8,
                      Text(
                        l10n.shareReport,
                        style: SbTextStyles.title(context).copyWith(
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
