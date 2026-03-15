import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/knowledge_topic.dart';
import 'package:site_buddy/features/ai/application/controllers/ai_assistant_controller.dart';

class KnowledgeCard extends ConsumerWidget {
  final KnowledgeTopic topic;

  const KnowledgeCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(aiControllerProvider);
    final query = state.searchQuery.toLowerCase();

    final filteredKeyPoints = query.isEmpty
        ? topic.keyPoints
        : topic.keyPoints
              .where((p) => p.toLowerCase().contains(query))
              .toList();

    final filteredTypes = query.isEmpty
        ? topic.types
        : topic.types.where((t) => t.toLowerCase().contains(query)).toList();

    final filteredThumbRules = query.isEmpty
        ? topic.thumbRules
        : topic.thumbRules
              .where((tr) => tr.toLowerCase().contains(query))
              .toList();

    final matchesDefinition =
        query.isEmpty || topic.definition.toLowerCase().contains(query);

    final hasResults =
        matchesDefinition ||
        filteredKeyPoints.isNotEmpty ||
        filteredTypes.isNotEmpty ||
        filteredThumbRules.isNotEmpty ||
        topic.siteTip.toLowerCase().contains(query);

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppLayout.md),
            color: colorScheme.primary,
            child: Row(
              children: [
                Icon(SbIcons.book, color: colorScheme.onPrimary, size: 24),
                AppLayout.hGap8,
                Expanded(
                  child: Text(
                    topic.title.toUpperCase(),
                    style: SbTextStyles.title(
                      context,
                    ).copyWith(color: colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppLayout.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // BREADCRUMB
                if (state.breadcrumb.isNotEmpty) ...[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.breadcrumb.asMap().entries.map((entry) {
                        final index = entry.key;
                        final title = entry.value;

                        return Row(
                          children: [
                            SbButton.ghost(
                              label: title,
                              onPressed: () => ref
                                  .read(aiControllerProvider.notifier)
                                  .goBackTo(context, index),
                            ),
                            if (index != state.breadcrumb.length - 1)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppLayout.xs,
                                ),
                                child: Icon(
                                  SbIcons.chevronRight,
                                  size: 20,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppLayout.sm),
                    child: Divider(),
                  ),
                ],

                // SEARCH
                SbInput(
                  onChanged: (value) => ref
                      .read(aiControllerProvider.notifier)
                      .updateSearch(value),
                  hint: 'Search inside topic...',
                  prefixIcon: Icon(SbIcons.search, color: colorScheme.primary),
                ),
                AppLayout.vGap16,

                // CONTENT
                if (hasResults) ...[
                  if (matchesDefinition) ...[
                    Text(
                      topic.definition,
                      style: SbTextStyles.body(context).copyWith(height: 1.5),
                    ),
                    AppLayout.vGap16,
                  ],
                  if (filteredKeyPoints.isNotEmpty) ...[
                    const _SectionHeader(title: 'Key Points'),
                    AppLayout.vGap8,
                    ...filteredKeyPoints.map(
                      (point) => _BulletPoint(text: point),
                    ),
                    AppLayout.vGap16,
                  ],
                  if (filteredThumbRules.isNotEmpty) ...[
                    _HighlightBox(
                      title: 'Thumb Rules',
                      icon: SbIcons.architecture,
                      color: colorScheme.secondary,
                      items: filteredThumbRules,
                    ),
                    AppLayout.vGap16,
                  ],
                  if (filteredTypes.isNotEmpty) ...[
                    const _SectionHeader(title: 'Types'),
                    AppLayout.vGap8,
                    Wrap(
                      spacing: AppLayout.sm,
                      runSpacing: AppLayout.sm,
                      children: filteredTypes
                          .map(
                            (t) => SbButton.outline(
                              label: t,
                              onPressed: () => ref
                                  .read(aiControllerProvider.notifier)
                                  .openTopic(context, t),
                            ),
                          )
                          .toList(),
                    ),
                    AppLayout.vGap16,
                  ],
                  if (topic.relatedTopics.isNotEmpty) ...[
                    const _SectionHeader(title: 'Explore Related Topics'),
                    AppLayout.vGap8,
                    Wrap(
                      spacing: AppLayout.sm,
                      runSpacing: AppLayout.sm,
                      children: topic.relatedTopics
                          .map(
                            (t) => SbButton.outline(
                              label: t,
                              onPressed: () => ref
                                  .read(aiControllerProvider.notifier)
                                  .openTopic(context, t),
                            ),
                          )
                          .toList(),
                    ),
                    AppLayout.vGap16,
                  ],
                  if (topic.siteTip.isNotEmpty) ...[
                    _HighlightBox(
                      title: 'Site Tip',
                      icon: SbIcons.lightbulb,
                      color: colorScheme.tertiary,
                      items: [topic.siteTip],
                    ),
                  ],
                ] else ...[
                  const Center(
                    child: Padding(
                      padding: AppLayout.paddingLarge,
                      child: Text('No matches found'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: SbTextStyles.bodySecondary(context).copyWith(
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: SbTextStyles.body(context)),
          Expanded(
            child: Text(
              text,
              style: SbTextStyles.body(
                context,
              ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  const _HighlightBox({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppLayout.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.05),
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              AppLayout.hGap8,
              Text(
                title,
                style: SbTextStyles.body(context).copyWith(color: color),
              ),
            ],
          ),
          AppLayout.vGap8,
          ...items.map(
            (item) =>
                Text('• $item', style: SbTextStyles.bodySecondary(context)),
          ),
        ],
      ),
    );
  }
}
