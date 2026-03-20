import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: PrivacyPolicyScreen
/// PURPOSE: Standard privacy disclosures for Play Store / App Store compliance.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScreenWrapper(
      title: 'Privacy Policy',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          _Section(
            title: 'Introduction',
            content:
                'Welcome to Site Buddy. Your privacy is critically important to us. '
                'This policy explains how we handle your data when you use our '
                'structural engineering and site tools.',
          ),
          _Section(
            title: 'Data Collection',
            content:
                'Site Buddy is designed as a utility tool. Most calculations and '
                'data processing occur locally on your device. We do not sell your '
                'personal information to third parties.',
          ),
          _Section(
            title: 'AI Services',
            content:
                'Our AI Assistant uses third-party Large Language Model providers. '
                'Any queries you send to the AI are processed by these providers. '
                'We recommend not sharing sensitive personal or proprietary project '
                'secrets via the AI chat.',
          ),
          _Section(
            title: 'Device Permissions',
            content:
                'The app may request access to storage (to save project reports) '
                'and camera (for site documentation). These are used strictly for '
                'app functionality.',
          ),
          _Section(
            title: 'Contact Information',
            content:
                'If you have questions about this policy, please contact us at: '
                'support@sitebuddy.app',
          ),
          SizedBox(height: AppSpacing.lg * 2), // Replaced AppLayout.sectionGap * 1.5
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SbSectionHeader(title: title), // Standardized header
          Text(
            content,
            style: AppTextStyles.body(context),
          ),
        ],
      ),
    );
  }
}
