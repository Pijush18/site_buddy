import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

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
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
      ),
      confirmLabel: 'Close',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: SbRadius.borderMedium),
      child: Container(
        padding: const EdgeInsets.all(SbSpacing.xxl),
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium!),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            SizedBox(height: SbSpacing.lg),
            Flexible(
              child: SingleChildScrollView(
                child: SelectableText(
                  content,
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
              ),
            ),
            SizedBox(height: SbSpacing.xxl),
            SbButton.primary(label: 'Close', onPressed: () => context.pop()),
          ],
        ),
      ),
    );
  }
}










