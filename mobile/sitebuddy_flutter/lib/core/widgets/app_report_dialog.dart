import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

class AppReportDialog extends StatelessWidget {
  final String title;
  final String content;

  const AppReportDialog({
    super.key,
    required this.title,
    required this.content,
  });

  static void show(BuildContext context, String title, String content) {
    SbFeedback.showDialog(
      context: context,
      title: title,
      content: SingleChildScrollView(
        child: SelectableText(
          content,
          style: const TextStyle(fontFamily: 'monospace'),
        ),
      ),
      confirmLabel: 'Close',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: AppLayout.borderRadiusCard),
      child: Container(
        padding: const EdgeInsets.all(AppLayout.pLarge),
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: SbTextStyles.title(context)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: SingleChildScrollView(
                child: SelectableText(
                  content,
                  style: SbTextStyles.body(context).copyWith(fontFamily: 'monospace'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SbButton.primary(label: 'Close', onPressed: () => context.pop()),
          ],
        ),
      ),
    );
  }
}