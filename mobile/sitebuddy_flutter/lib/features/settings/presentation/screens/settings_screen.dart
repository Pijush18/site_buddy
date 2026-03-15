import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/segmented_toggle.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/enums/unit_system.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';
import 'package:site_buddy/features/auth/domain/auth_repository.dart';
import 'package:site_buddy/features/subscription/application/subscription_providers.dart';
import 'package:go_router/go_router.dart';

/// SCREEN: SettingsScreen
/// PURPOSE: Standardized global app settings (Theming, Language, Professional Profile).
/// V10: StatelessWidget + Clean Rule 6 structure (now possible due to shell constraint fixes).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // RULE 1: Root must be SbPage.scaffold
    return SbPage.detail(
      title: l10n.settings,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SECTION 1: ACCOUNT ---
          _buildSectionHeader(context, "Account"),
          _buildAccountSection(context),
          AppLayout.vGap32,

          // --- SECTION: APPEARANCE ---
          _buildSectionHeader(context, l10n.appearance),
          SbCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SbSettingsTile(
                  isVertical: true,
                  icon: SbIcons.palette,
                  title: l10n.themeMode,
                  subtitle: "Choose how SiteBuddy appears",
                  trailing: Consumer(
                    builder: (context, ref, _) {
                      final settings = ref.watch(settingsProvider);
                      return SegmentedToggle<ThemeMode>(
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
                      );
                    },
                  ),
                ),
                const Divider(height: 1, indent: 56),
                SbSettingsTile(
                  isVertical: true,
                  icon: SbIcons.refresh,
                  title: l10n.language,
                  subtitle: "Select your preferred language",
                  trailing: Consumer(
                    builder: (context, ref, _) {
                      final settings = ref.watch(settingsProvider);
                      return SegmentedToggle<String>(
                        value: settings.locale,
                        items: const ['en', 'hi'],
                        labelBuilder: (code) =>
                            code == 'en' ? l10n.english : l10n.hindi,
                        onChanged: (code) {
                          ref.read(settingsProvider.notifier).setLocale(code);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          AppLayout.vGap32,

          // --- SECTION: ENGINEERING STANDARDS ---
          _buildSectionHeader(context, l10n.engineeringStandards),
          SbCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SbSettingsTile(
                  isVertical: true,
                  icon: SbIcons.ruler,
                  title: l10n.unitSystem,
                  subtitle: "Select measurement system",
                  trailing: Consumer(
                    builder: (context, ref, _) {
                      final settings = ref.watch(settingsProvider);
                      return SegmentedToggle<UnitSystem>(
                        value: settings.unitSystem,
                        items: UnitSystem.values,
                        labelBuilder: (unit) => unit == UnitSystem.metric
                            ? l10n.metric
                            : l10n.imperial,
                        onChanged: (unit) => ref
                            .read(settingsProvider.notifier)
                            .setUnitSystem(unit),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          AppLayout.vGap32,

          // --- SECTION: APP BEHAVIOR ---
          _buildSectionHeader(context, "App Behavior"),
          SbCard(
            padding: EdgeInsets.zero,
            child: Consumer(
              builder: (context, ref, _) {
                final settings = ref.watch(settingsProvider);
                return Column(
                  children: [
                    SbSettingsTile(
                      isVertical: true,
                      icon: SbIcons.refresh,
                      title: "Restore Last Screen on Launch",
                      subtitle: "Continue where you left off when reopening the app.",
                      onTap: () => ref
                          .read(settingsProvider.notifier)
                          .setRestoreLastScreen(!settings.restoreLastScreen),
                      trailing: Align(
                        alignment: Alignment.centerLeft,
                        child: Switch(
                          value: settings.restoreLastScreen,
                          onChanged: (value) => ref
                              .read(settingsProvider.notifier)
                              .setRestoreLastScreen(value),
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 56),
                    SbSettingsTile(
                      icon: SbIcons.history,
                      iconColor: Colors.orange,
                      title: "Reset to Default Settings",
                      subtitle: "Revert all settings to their original state",
                      onTap: () => _showResetDialog(context, ref),
                    ),
                  ],
                );
              },
            ),
          ),
          AppLayout.vGap32,

          // --- SECTION: LEGAL ---
          _buildSectionHeader(context, "Legal"),
          SbCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SbSettingsTile(
                  icon: SbIcons.shield,
                  title: "Privacy Policy",
                  onTap: () async {
                    final url = Uri.parse("https://pijush.com/privacy-policy/");
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),
                const Divider(height: 1, indent: 56),
                SbSettingsTile(
                  icon: SbIcons.description,
                  title: "Terms of Service",
                  onTap: () async {
                    final url = Uri.parse("https://pijush.com/terms-of-service/");
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),
              ],
            ),
          ),
          AppLayout.vGap32,

          // --- SECTION: ABOUT ---
          _buildSectionHeader(context, "About"),
          SbCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const SbSettingsTile(
                  icon: SbIcons.info,
                  title: "App Version",
                  subtitle: "SiteBuddy v1.0.0",
                ),
                const Divider(height: 1, indent: 56),
                const SbSettingsTile(
                  icon: SbIcons.profile,
                  title: "Developer",
                  subtitle: "Er. Pijush Debbarma",
                ),
                const Divider(height: 1, indent: 56),
                SbSettingsTile(
                  icon: SbIcons.link,
                  title: "Website",
                  subtitle: "www.pijush.com",
                  onTap: () async {
                    final url = Uri.parse("https://www.pijush.com");
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),
              ],
            ),
          ),
          AppLayout.vGap48,
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final authAsync = ref.watch(authStateProvider);
        final subscriptionAsync = ref.watch(subscriptionStatusProvider);
        final colorScheme = Theme.of(context).colorScheme;

        return authAsync.when(
          data: (user) {
            if (user == null) return const SizedBox.shrink();
            return subscriptionAsync.when(
              data: (subscription) => _buildProfileCard(
                context,
                ref,
                user,
                subscription.plan,
                subscription.isPremium,
                colorScheme,
              ),
              loading: () => _buildSmallLoadingState(),
              error: (e, _) => _buildSmallErrorState("Sync error"),
            );
          },
          loading: () => _buildSmallLoadingState(),
          error: (e, _) => _buildSmallErrorState("Sync error"),
        );
      },
    );
  }

  Widget _buildProfileCard(
    BuildContext context, 
    WidgetRef ref,
    SiteUser user, 
    String plan,
    bool isPremium, 
    ColorScheme colorScheme
  ) {
    return Column(
      children: [
        SbCard(
          padding: AppLayout.paddingLg,
          child: Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: const Icon(
                  SbIcons.account,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              AppLayout.hGap16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Er. Pijush Debbarma",
                      style: SbTextStyles.title(context).copyWith(
                        
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      user.email.isEmpty ? "No Email Registered" : user.email,
                      style: SbTextStyles.caption(context).copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppLayout.vGap8,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      
                      child: Text(
                        (isPremium ? "Premium Plan" : "Free Plan").toUpperCase(),
                        style: SbTextStyles.caption(context).copyWith(
                          color: isPremium 
                              ? colorScheme.onPrimary 
                              : colorScheme.onSurfaceVariant,
                          
                          
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppLayout.vGap16,
        SbCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SbSettingsTile(
                icon: SbIcons.profile,
                title: "Edit Profile",
                onTap: () => debugPrint("Profile"),
              ),
              const Divider(height: 1, indent: 56),
              SbSettingsTile(
                icon: SbIcons.payments,
                title: "Subscription & Billing",
                onTap: () => context.push('/subscription'),
              ),
              const Divider(height: 1, indent: 56),
              SbSettingsTile(
                icon: SbIcons.logout,
                title: "Logout",
                iconColor: colorScheme.error,
                onTap: () async {
                  await ref.read(authRepositoryProvider).logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
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

  Widget _buildSmallLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppLayout.pMedium),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildSmallErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(AppLayout.pMedium),
      
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          AppLayout.hGap12,
          Text(message, style: const TextStyle(color: Colors.red, )),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Settings?"),
        content: const Text(
          "This will revert all your preferences (Theme, Units, Language) to default. This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).setTheme(ThemeMode.system);
              ref.read(settingsProvider.notifier).setUnitSystem(UnitSystem.metric);
              ref.read(settingsProvider.notifier).setLocale('en');
              ref.read(settingsProvider.notifier).setRestoreLastScreen(false);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Settings reset to defaults")),
              );
            },
            child: const Text("Reset", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
