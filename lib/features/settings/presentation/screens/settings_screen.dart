import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/segmented_toggle.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/enums/unit_system.dart';
import 'package:site_buddy/features/settings/presentation/widgets/setting_tile.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';

/// SCREEN: SettingsScreen
/// PURPOSE: Standardized global app settings (Theming, Language, Professional Profile).
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return SbPage.detail(
      title: l10n.settings,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Theme Section
          _buildSectionHeader(l10n.appearance),
          SbCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SettingTile(
                  icon: SbIcons.palette,
                  title: l10n.themeMode,
                  onTap: () {},
                  trailing: SizedBox(
                    width: 160,
                    child: SegmentedToggle<ThemeMode>(
                      value: settings.themeMode,
                      items: const [
                        ThemeMode.system,
                        ThemeMode.light,
                        ThemeMode.dark,
                      ],
                      labelBuilder: (mode) {
                        switch (mode) {
                          case ThemeMode.system:
                            return 'Auto';
                          case ThemeMode.light:
                            return l10n.light;
                          case ThemeMode.dark:
                            return l10n.dark;
                        }
                      },
                      onChanged: (mode) =>
                          ref.read(settingsProvider.notifier).setTheme(mode),
                    ),
                  ),
                ),
                const Divider(height: AppLayout.pTiny, indent: 56),
                SettingTile(
                  icon: SbIcons.refresh,
                  title: l10n.language,
                  onTap: () {},
                  trailing: SizedBox(
                    width: 120,
                    child: SegmentedToggle<String>(
                      value: settings.locale,
                      items: const ['en', 'hi'],
                      labelBuilder: (code) =>
                          code == 'en' ? l10n.english : l10n.hindi,
                      onChanged: (code) {
                        ref.read(settingsProvider.notifier).setLocale(code);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppLayout.lg),

          // Engineering Units Section
          _buildSectionHeader(l10n.engineeringStandards),
          SbCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SettingTile(
                  icon: SbIcons.ruler,
                  title: l10n.unitSystem,
                  onTap: () {},
                  trailing: SizedBox(
                    width: 140,
                    child: SegmentedToggle<UnitSystem>(
                      value: settings.unitSystem,
                      items: UnitSystem.values,
                      labelBuilder: (unit) => unit == UnitSystem.metric
                          ? l10n.metric
                          : l10n.imperial,
                      onChanged: (unit) => ref
                          .read(settingsProvider.notifier)
                          .setUnitSystem(unit),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppLayout.lg),

          // Utility Section
          _buildSectionHeader(l10n.legalAndAbout),

          SbCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SettingTile(
                  icon: SbIcons.description,
                  title: l10n.termsAndConditions,
                  onTap: () => context.push('/settings/terms'),
                ),
                const Divider(height: 1, indent: 56),
                SettingTile(
                  icon: SbIcons.shield,
                  title: l10n.privacyPolicy,
                  onTap: () => context.push('/settings/privacy'),
                ),
                const Divider(height: 1, indent: 56),
                SettingTile(
                  icon: SbIcons.info,
                  title: l10n.appVersion,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppLayout.sectionGap * 2),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppLayout.pSmall,
        bottom: AppLayout.pSmall,
      ),
      child: Text(
        title.toUpperCase(),
        style: SbTextStyles.caption(context).copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
