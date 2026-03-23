import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
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
    final textTheme = theme.textTheme;
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
            padding: const EdgeInsets.all(AppSpacing.lg),
            color: colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Icon(SbIcons.book, color: colorScheme.onSurfaceVariant, size: 24),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    topic.title.toUpperCase(),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),

                ),
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.breadcrumb.isNotEmpty) ...[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.breadcrumb.asMap().entries.map((entry) {
                        final index = entry.key;
                        final title = entry.value;

                        return Row(
                          children: [
                            GhostButton(
                              label: title,
                              onPressed: () => ref
                                  .read(aiControllerProvider.notifier)
                                  .goBackTo(context, index),
                            ),
                            if (index != state.breadcrumb.length - 1)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
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
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Divider(),
                  ),
                ],

                SbInput(
                  onChanged: (value) => ref
                      .read(aiControllerProvider.notifier)
                      .updateSearch(value),
                  hint: AppStrings.searchInsideTopic,
                  prefixIcon: Icon(SbIcons.search, color: colorScheme.onSurfaceVariant),
                ),

                const SizedBox(height: AppSpacing.lg),

                if (hasResults) ...[
                  if (matchesDefinition) ...[
                    Text(
                      topic.definition,
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (filteredKeyPoints.isNotEmpty) ...[
                    const _SectionHeader(title: AppStrings.keyPoints),
                    const SizedBox(height: AppSpacing.sm),
                    ...filteredKeyPoints.map(
                      (point) => _BulletPoint(text: point),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (filteredThumbRules.isNotEmpty) ...[
                    _HighlightBox(
                      title: AppStrings.thumbRules,
                      icon: SbIcons.architecture,
                      color: colorScheme.secondary,
                      items: filteredThumbRules,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (filteredTypes.isNotEmpty) ...[
                    const _SectionHeader(title: AppStrings.types),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: filteredTypes
                          .map(
                            (t) => SecondaryButton(isOutlined: true, 
                              label: t,
                              onPressed: () => ref
                                  .read(aiControllerProvider.notifier)
                                  .openTopic(context, t),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (topic.relatedTopics.isNotEmpty) ...[
                    const _SectionHeader(title: AppStrings.exploreRelatedTopics),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: topic.relatedTopics
                          .map(
                            (t) => SecondaryButton(isOutlined: true, 
                              label: t,
                              onPressed: () => ref
                                  .read(aiControllerProvider.notifier)
                                  .openTopic(context, t),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (topic.siteTip.isNotEmpty) ...[
                    _HighlightBox(
                      title: AppStrings.siteTip,
                      icon: SbIcons.lightbulb,
                      color: colorScheme.tertiary,
                      items: [topic.siteTip],
                    ),
                  ],
                ] else ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Text(AppStrings.noMatchesFound),
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
      style: Theme.of(context).textTheme.labelLarge!,
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: textTheme.bodyLarge),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyMedium,
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
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...items.map(
            (item) =>
                Text('• $item', style: textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}








