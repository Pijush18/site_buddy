
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: PrivacyPolicyScreen
/// PURPOSE: Standard privacy disclosures for Play Store / App Store compliance.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SbPage.detail(
      title: 'Privacy Policy',
      body: SbSectionList(
        sections: [
          SbSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
              ],
            ),
          ),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: SbSpacing.xxl)
.copyWith(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SbSectionHeader(title: title), // Standardized header
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
        ],
      ),
    );
  }
}










