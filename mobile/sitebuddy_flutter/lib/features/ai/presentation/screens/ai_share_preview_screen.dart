import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:site_buddy/core/widgets/previewable_card.dart';
import 'package:site_buddy/core/utils/share_formatter.dart';
import 'package:site_buddy/core/utils/share_image_generator.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/ai_share_report_card.dart';

class AiSharePreviewScreen extends StatefulWidget {
  const AiSharePreviewScreen({super.key});

  @override
  State<AiSharePreviewScreen> createState() => _AiSharePreviewScreenState();
}

class _AiSharePreviewScreenState extends State<AiSharePreviewScreen> {
  final GlobalKey _previewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Extract map data from GoRouter extra
    final data = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final String question = data?['question'] ?? 'Unknown Question';
    final String answer = data?['answer'] ?? 'Unknown Answer';
    final String projectName = data?['projectName'] ?? 'General';

    final textToShare = ShareFormatter.format(
      question: question,
      answer: answer,
      projectName: projectName,
    );

    return SbPage.detail(
      title: 'Share Preview',
      body: SbSectionList(
        sections: [
          SbSection(
            child: PreviewableCard(
              previewKey: _previewKey,
              title: 'AI Share Card',
              actions: [
                PreviewAction(
                  icon: SbIcons.image,
                  label: 'Share Image',
                  onPressed: () {
                    ShareImageGenerator.generateAndShareImage(
                      _previewKey,
                      "site_buddy_ai_card",
                    );
                  },
                ),
                PreviewAction(
                  icon: SbIcons.share,
                  label: 'Share Text',
                  onPressed: () {
                    // ignore: deprecated_member_use
                    Share.share(textToShare);
                  },
                ),
              ],
              child: AiShareReportCard(
                question: question,
                answer: answer,
                projectName: projectName,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



