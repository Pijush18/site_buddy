import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/segmented_toggle.dart';
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
    return AppScreenWrapper(
      title: AppStrings.settings,
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
              padding: EdgeInsets.zero,
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
              padding: EdgeInsets.zero,
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
              padding: EdgeInsets.zero,
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
                        iconColor: Colors.orange,
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
              padding: EdgeInsets.zero,
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
                      final url = Uri.parse(
                        "https://pijush.com/terms-of-service/",
                      );
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
              padding: EdgeInsets.zero,
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
          // Bottom padding structurally absorbed by AppScreenWrapper/SbSection natively
      ],
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
    final colorScheme = Theme.of(context).colorScheme;
    return SbSection(
      child: Column(
        children: [
          SbCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(SbIcons.account, size: 30, color: Colors.grey),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.developerName,
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      Text(
                        user.email.isEmpty
                            ? AppStrings.noEmailRegistered
                            : user.email,
                        style: AppTextStyles.body(context, secondary: true),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        child: Text(
                          (isPremium ? AppStrings.premiumPlan : AppStrings.freePlan)
                              .toUpperCase(),
                          style: AppTextStyles.caption(context).copyWith(
                            color: isPremium
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
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
          const SizedBox(height: AppSpacing.md),
          SbCard(
            padding: EdgeInsets.zero,
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
      ),
    );
  }

  // Removed _buildSectionHeader as it is replaced by SBSectionHeader

  Widget _buildSmallLoadingState() {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.md), // Replaced AppLayout.pMedium
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSmallErrorState(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md), // Replaced AppLayout.pMedium
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: AppSpacing.sm), // Replaced AppLayout.hGap12
          Text(message, style: AppTextStyles.body(context).copyWith(color: Colors.red)),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.resetSettingsQuestion),
        content: const Text(
          AppStrings.resetSettingsDisclaimer,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
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
                  const SnackBar(content: Text(AppStrings.settingsResetToDefaults)),
                );
              },
              child: Text(AppStrings.reset, style: AppTextStyles.body(context).copyWith(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}
