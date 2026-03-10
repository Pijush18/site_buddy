import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: TermsConditionsScreen
/// PURPOSE: Standard legal terms and engineering disclaimers.
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The body is now a const widget, improving performance by using compliant
    // spacing tokens.
    return const SbPage.detail(
      title: 'Terms & Conditions',
      body: SingleChildScrollView(
        padding: AppLayout.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppLayout.lg),
            _Section(
              title: 'Acceptance of Terms',
              content:
                  'By using Site Buddy, you agree to these terms and conditions. '
                  'If you do not agree, please discontinue use of the application.',
            ),
            SizedBox(height: AppLayout.xl),
            _Section(
              title: 'Engineering Disclaimer',
              content:
                  'IMPORTANT: Site Buddy is a reference and calculation aid only. '
                  'All results must be verified by a qualified Structural Engineer '
                  'before implementation. We are not responsible for structural failures '
                  'resulting from use of this software.',
            ),
            SizedBox(height: AppLayout.xl),
            _Section(
              title: 'License',
              content:
                  'Users are granted a non-exclusive license for personal or '
                  'professional use. Reverse engineering or unauthorized distribution '
                  'is strictly prohibited.',
            ),
            SizedBox(height: AppLayout.xl),
            _Section(
              title: 'Limitation of Liability',
              content:
                  'Site Buddy and its developers are not liable for any direct, indirect, '
                  'incidental, or consequential damages resulting from the use or '
                  'inability to use the software.',
            ),
            SizedBox(height: AppLayout.xl),
            _Section(
              title: 'Changes to Terms',
              content:
                  'We reserve the right to modify these terms at any time. '
                  'Continued use of the app constitutes acceptance of new terms.',
            ),
            // Replaced non-compliant multiplied value with a compliant token combination.
            SizedBox(height: AppLayout.xl),
            SizedBox(height: AppLayout.md),
          ],
        ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Removed Padding wrapper to delegate sibling spacing to the parent widget,
    // adhering to layout rules.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: SbTextStyles.title(context).copyWith(
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppLayout.sm),
        Text(
          content,
          style: SbTextStyles.body(context).copyWith(
            color: colorScheme.onSurface,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
