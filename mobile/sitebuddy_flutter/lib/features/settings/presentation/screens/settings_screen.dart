import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/enums/unit_system.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';
import 'package:site_buddy/features/auth/application/user_provider.dart';
import 'package:go_router/go_router.dart';

/// SCREEN: SettingsScreen
/// PURPOSE: Standardized global app settings (Theming, Language, Professional Profile).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return SbPage.scaffold(
      title: l10n.settings,
      body: SbSectionList(
        sections: [
          // --- SECTION 1: ACCOUNT ---
          SbSection(
            title: l10n.account,
            child: _buildAccountSection(context),
          ),

          // --- SECTION: APPEARANCE ---
          SbSection(
            title: l10n.appearance,
            child: SbCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SbSettingsTile(
                    isVertical: true,
                    icon: SbIcons.palette,
                    title: l10n.themeMode,
                    subtitle: l10n.chooseHowAppAppears,
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
                                return l10n.auto;
                              case ThemeMode.light:
                                return l10n.light;
                              case ThemeMode.dark:
                                return l10n.dark;
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
                    title: l10n.language,
                    subtitle: l10n.selectPreferredLanguage,
                    trailing: Consumer(
                      builder: (context, ref, _) {
                        final settings = ref.watch(settingsProvider);
                        return SegmentedToggle<String>(
                          value: settings.locale,
                          items: const ['en', 'hi', 'ta'],
                          labelBuilder: (code) {
                            switch (code) {
                              case 'en':
                                return l10n.labelEnglish;
                              case 'hi':
                                return l10n.labelHindi;
                              case 'ta':
                                return l10n.labelTamil;
                              default:
                                return code;
                            }
                          },
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
            title: l10n.labelEngineeringStandards,
            child: SbCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SbSettingsTile(
                    isVertical: true,
                    icon: SbIcons.ruler,
                    title: l10n.unitSystem,
                    subtitle: l10n.selectMeasurementSystem,
                    trailing: Consumer(
                      builder: (context, ref, _) {
                        final settings = ref.watch(settingsProvider);
                        return SegmentedToggle<UnitSystem>(
                          value: settings.unitSystem,
                          items: UnitSystem.values,
                          labelBuilder: (unit) => unit == UnitSystem.metric
                              ? l10n.labelMetric
                              : l10n.labelImperial,
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
            title: l10n.appBehavior,
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
                        title: l10n.restoreLastScreen,
                        subtitle: l10n.continueWhereLeftOff,
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
                        title: l10n.resetToDefault,
                        subtitle: l10n.revertSettingsState,
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
            title: l10n.labelLegalAndAbout,
            child: SbCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SbSettingsTile(
                    icon: SbIcons.shield,
                    title: l10n.privacyPolicy,
                    onTap: () async {
                      final url = Uri.parse("https://pijush.com/privacy-policy/");
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  SbSettingsTile(
                    icon: SbIcons.description,
                    title: l10n.termsOfService,
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
            title: l10n.about,
            child: SbCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SbSettingsTile(
                    icon: SbIcons.info,
                    title: l10n.labelAppVersion,
                    subtitle: "SiteBuddy v1.0.0",
                  ),
                  const Divider(height: 1, indent: 56),
                  SbSettingsTile(
                    icon: SbIcons.profile,
                    title: l10n.labelDeveloper,
                    subtitle: "Er. Pijush Debbarma",
                  ),
                  const Divider(height: 1, indent: 56),
                  SbSettingsTile(
                    icon: SbIcons.link,
                    title: l10n.website,
                    subtitle: "www.pijush.com",
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
        final accountAsync = ref.watch(accountDataProvider);

        return accountAsync.when(
          data: (accountData) {
            if (accountData == null) return const SizedBox.shrink();
            return _buildProfileCard(context, ref, accountData);
          },
          loading: () => const _AccountSkeleton(),
          error: (e, _) => _AccountError(
            message: "Unable to sync account data",
            onRetry: () => ref.invalidate(accountDataProvider),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    WidgetRef ref,
    AccountData data,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final user = data.profile;
    final l10n = context.l10n;

    return Column(
      children: [
        // 1. Primary Account Info Card
        SbCard(
          padding: const EdgeInsets.all(SbSpacing.md),
          child: Row(
            children: [
              GestureDetector(
                onDoubleTap: () =>
                    ref.read(profileControllerProvider.notifier).pickImage(),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  backgroundImage: user.profileImage != null
                      ? FileImage(File(user.profileImage!))
                      : null,
                  child: user.profileImage == null
                      ? Icon(
                          SbIcons.account,
                          size: 30,
                          color: theme.colorScheme.primary.withValues(alpha: 0.5),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: SbSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name.isEmpty ? "Er. Pijush Debbarma" : user.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email.isEmpty
                          ? "No Email Registered"
                          : user.email,
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: SbSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SbSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (data.subscription.isPremium
                                ? l10n.premiumPlan
                                : l10n.freePlan)
                            .toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: SbSpacing.md),

        // 2. Action List Card
        SbCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SbSettingsTile(
                icon: SbIcons.profile,
                title: l10n.editProfile,
                onTap: () => context.push('/settings/branding'),
              ),
              const Divider(height: 1, indent: 56, endIndent: SbSpacing.md),
              SbSettingsTile(
                icon: SbIcons.payments,
                title: l10n.subscriptionBilling,
                onTap: () => context.push('/subscription'),
              ),
              const Divider(height: 1, indent: 56, endIndent: SbSpacing.md),
              SbSettingsTile(
                icon: SbIcons.logout,
                title: l10n.logout,
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

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetSettingsQuestion, style: textTheme.titleLarge),
        content: Text(
          l10n.revertSettingsState,
          style: textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.actionCancel, style: textTheme.labelLarge),
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
                    l10n.settingsResetToDefaults,
                    style: textTheme.bodyMedium,
                  ),
                ),
              );
            },
            child: Text(l10n.actionReset, style: textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}

/// PRIVATE WIDGET: _AccountSkeleton
/// Provides a non-blocking placeholder for account loading.
class _AccountSkeleton extends StatelessWidget {
  const _AccountSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greyColor = theme.colorScheme.surfaceContainerHighest;

    return Column(
      children: [
        SbCard(
          padding: const EdgeInsets.all(SbSpacing.md),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: greyColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: SbSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 120, color: greyColor),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 180, color: greyColor),
                    const SizedBox(height: 8),
                    Container(height: 10, width: 60, color: greyColor),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: SbSpacing.md),
        SbCard(
          padding: const EdgeInsets.symmetric(vertical: SbSpacing.sm),
          child: Column(
            children: List.generate(3, (index) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SbSpacing.md,
                vertical: SbSpacing.sm,
              ),
              child: Row(
                children: [
                  Container(width: 24, height: 24, color: greyColor),
                  const SizedBox(width: 16),
                  Container(height: 12, width: 100, color: greyColor),
                ],
              ),
            )),
          ),
        ),
      ],
    );
  }
}

/// PRIVATE WIDGET: _AccountError
class _AccountError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _AccountError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    
    return SbCard(
      padding: const EdgeInsets.all(SbSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: theme.colorScheme.error, size: 24),
              const SizedBox(width: SbSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.sm),
          TextButton(
            onPressed: onRetry,
            child: Text(l10n.actionReset), 
          ),
        ],
      ),
    );
  }
}
