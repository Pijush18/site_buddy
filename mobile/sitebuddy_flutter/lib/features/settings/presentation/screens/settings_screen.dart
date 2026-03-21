import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/enums/unit_system.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/error_strings.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';
import 'package:site_buddy/features/auth/domain/auth_repository.dart';
import 'package:site_buddy/features/subscription/application/subscription_providers.dart';
import 'package:go_router/go_router.dart';

/// SCREEN: SettingsScreen
/// PURPOSE: Standardized global app settings (Theming, Language, Professional Profile).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SbPage.scaffold(
      title: AppStrings.settings,
      body: SbSectionList(
        sections: [
          // --- SECTION 1: ACCOUNT ---
          SbSection(
            title: AppStrings.account,
            child: _buildAccountSection(context),
          ),

          // --- SECTION: APPEARANCE ---
          SbSection(
            title: AppStrings.appearance,
            child: SbCard(
              padding: SbSpacing.zero,
              child: Column(
                children: [
                  SbSettingsTile(
                    isVertical: true,
                    icon: SbIcons.palette,
                    title: AppStrings.themeMode,
                    subtitle: AppStrings.chooseHowAppAppears,
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
                                return AppStrings.auto;
                              case ThemeMode.light:
                                return AppStrings.light;
                              case ThemeMode.dark:
                                return AppStrings.dark;
                            }
                          },
                          onChanged: (mode) => ref
                              .read(settingsProvider.notifier)
                              .setTheme(mode),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  SbSettingsTile(
                    isVertical: true,
                    icon: SbIcons.refresh,
                    title: AppStrings.language,
                    subtitle: AppStrings.selectPreferredLanguage,
                    trailing: Consumer(
                      builder: (context, ref, _) {
                        final settings = ref.watch(settingsProvider);
                        return SegmentedToggle<String>(
                          value: settings.locale,
                          items: const ['en', 'hi'],
                          labelBuilder: (code) =>
                              code == 'en' ? AppStrings.english : AppStrings.hindi,
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
          ),

          // --- SECTION: ENGINEERING STANDARDS ---
          SbSection(
            title: AppStrings.engineeringStandards,
            child: SbCard(
              padding: SbSpacing.zero,
              child: Column(
                children: [
                  SbSettingsTile(
                    isVertical: true,
                    icon: SbIcons.ruler,
                    title: AppStrings.unitSystem,
                    subtitle: AppStrings.selectMeasurementSystem,
                    trailing: Consumer(
                      builder: (context, ref, _) {
                        final settings = ref.watch(settingsProvider);
                        return SegmentedToggle<UnitSystem>(
                          value: settings.unitSystem,
                          items: UnitSystem.values,
                          labelBuilder: (unit) => unit == UnitSystem.metric
                              ? AppStrings.metric
                              : AppStrings.imperial,
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
          ),

          // --- SECTION: APP BEHAVIOR ---
          SbSection(
            title: AppStrings.appBehavior,
            child: SbCard(
              padding: SbSpacing.zero,
              child: Consumer(
                builder: (context, ref, _) {
                  final settings = ref.watch(settingsProvider);
                  return Column(
                    children: [
                      SbSettingsTile(
                        isVertical: true,
                        icon: SbIcons.refresh,
                        title: AppStrings.restoreLastScreen,
                        subtitle: AppStrings.continueWhereLeftOff,
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
                        title: AppStrings.resetToDefault,
                        subtitle: AppStrings.revertSettingsState,
                        onTap: () => _showResetDialog(context, ref),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // --- SECTION: LEGAL ---
          SbSection(
            title: AppStrings.legal,
            child: SbCard(
              padding: SbSpacing.zero,
              child: Column(
                children: [
                  SbSettingsTile(
                    icon: SbIcons.shield,
                    title: AppStrings.privacyPolicy,
                    onTap: () async {
                      final url = Uri.parse("https://pijush.com/privacy-policy/");
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  SbSettingsTile(
                    icon: SbIcons.description,
                    title: AppStrings.termsOfService,
                    onTap: () async {
                      final url = Uri.parse("https://pijush.com/terms-of-service/");
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                  ),
                ],
              ),
            ),
          ),

          // --- SECTION: ABOUT ---
          SbSection(
            title: AppStrings.about,
            child: SbCard(
              padding: SbSpacing.zero,
              child: Column(
                children: [
                  const SbSettingsTile(
                    icon: SbIcons.info,
                    title: AppStrings.appVersion,
                    subtitle: AppStrings.appVersionValue,
                  ),
                  const Divider(height: 1, indent: 56),
                  const SbSettingsTile(
                    icon: SbIcons.profile,
                    title: AppStrings.developer,
                    subtitle: AppStrings.developerName,
                  ),
                  const Divider(height: 1, indent: 56),
                  SbSettingsTile(
                    icon: SbIcons.link,
                    title: AppStrings.website,
                    subtitle: AppStrings.developerWebsite,
                    onTap: () async {
                      final url = Uri.parse("https://www.pijush.com");
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final authAsync = ref.watch(authStateProvider);
        final subscriptionAsync = ref.watch(subscriptionStatusProvider);

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
              ),
              loading: () => _buildSmallLoadingState(),
              error: (e, _) => _buildSmallErrorState(context, ErrorStrings.syncError),
            );
          },
          loading: () => _buildSmallLoadingState(),
          error: (e, _) => _buildSmallErrorState(context, "Sync error"),
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
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SbSection(
      child: Column(
        children: [
          SbCard(
            padding: SbSpacing.paddingLG,
            child: Row(
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(SbIcons.account, size: 30, color: Colors.grey),
                ),
                const SizedBox(width: SbSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.developerName,
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        user.email.isEmpty
                            ? AppStrings.noEmailRegistered
                            : user.email,
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: SbSpacing.sm),
                      Container(
                        padding: SbSpacing.horizontalSM.add(SbSpacing.verticalXS),
                        child: Text(
                          (isPremium ? AppStrings.premiumPlan : AppStrings.freePlan)
                              .toUpperCase(),
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SbSpacing.md),
          SbCard(
            padding: SbSpacing.zero,
            child: Column(
              children: [
                SbSettingsTile(
                  icon: SbIcons.profile,
                  title: AppStrings.editProfile,
                  onTap: () => debugPrint("Profile"),
                ),
                const Divider(height: 1, indent: 56),
                SbSettingsTile(
                  icon: SbIcons.payments,
                  title: AppStrings.subscriptionBilling,
                  onTap: () => context.push('/subscription'),
                ),
                const Divider(height: 1, indent: 56),
                SbSettingsTile(
                  icon: SbIcons.logout,
                  title: AppStrings.logout,
                  onTap: () async {
                    await ref.read(authRepositoryProvider).logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallLoadingState() {
    return Container(
      padding: SbSpacing.paddingMD,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSmallErrorState(BuildContext context, String message) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: SbSpacing.paddingMD,
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: SbSpacing.sm),
          Text(message, style: textTheme.bodyMedium),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.resetSettingsQuestion, style: textTheme.titleLarge),
        content: Text(
          AppStrings.resetSettingsDisclaimer,
          style: textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel, style: textTheme.labelLarge),
          ),
          TextButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).setTheme(ThemeMode.system);
              ref
                  .read(settingsProvider.notifier)
                  .setUnitSystem(UnitSystem.metric);
              ref.read(settingsProvider.notifier).setLocale('en');
              ref.read(settingsProvider.notifier).setRestoreLastScreen(false);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppStrings.settingsResetToDefaults,
                    style: textTheme.bodyMedium,
                  ),
                ),
              );
            },
            child: Text(AppStrings.reset, style: textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}



