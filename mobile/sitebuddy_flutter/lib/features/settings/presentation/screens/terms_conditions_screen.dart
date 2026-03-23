
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: TermsConditionsScreen
/// PURPOSE: Standard legal terms and engineering disclaimers.
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SbPage.detail(
      title: 'Terms & Conditions',
      body: SbSectionList(
        sections: [
          SbSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Section(
                  title: 'Acceptance of Terms',
                  content:
                      'By using Site Buddy, you agree to these terms and conditions. '
                      'If you do not agree, please discontinue use of the application.',
                ),
                SizedBox(height: SbSpacing.xxl * 1.5),
                _Section(
                  title: 'Engineering Disclaimer',
                  content:
                      'IMPORTANT: Site Buddy is a reference and calculation aid only. '
                      'All results must be verified by a qualified Structural Engineer '
                      'before implementation. We are not responsible for structural failures '
                      'resulting from use of this software.',
                ),
                SizedBox(height: SbSpacing.xxl * 1.5),
                _Section(
                  title: 'License',
                  content:
                      'Users are granted a non-exclusive license for personal or '
                      'professional use. Reverse engineering or unauthorized distribution '
                      'is strictly prohibited.',
                ),
                SizedBox(height: SbSpacing.xxl * 1.5),
                _Section(
                  title: 'Limitation of Liability',
                  content:
                      'Site Buddy and its developers are not liable for any direct, indirect, '
                      'incidental, or consequential damages resulting from the use or '
                      'inability to use the software.',
                ),
                SizedBox(height: SbSpacing.xxl * 1.5),
                _Section(
                  title: 'Changes to Terms',
                  content:
                      'We reserve the right to modify these terms at any time. '
                      'Continued use of the app constitutes acceptance of new terms.',
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

  const _Section({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SbSectionHeader(title: title), // Standardized header
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
      ],
    );
  }
}










