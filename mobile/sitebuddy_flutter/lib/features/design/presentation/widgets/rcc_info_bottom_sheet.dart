
import 'package:site_buddy/core/design_system/sb_spacing.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/design/design_item.dart';

/// CLASS: RccInfoBottomSheet
/// PURPOSE: Detailed view for structural design specs.
class RccInfoBottomSheet extends StatelessWidget {
  final DesignItem item;

  const RccInfoBottomSheet({super.key, required this.item});

  /// STATIC METHOD: show
  /// PURPOSE: Standard way to launch this bottom sheet.
  static Future<void> show(BuildContext context, DesignItem item) {
    return SbFeedback.showBottomSheet(
      context: context,
      isScrollControlled: true,
      child: RccInfoBottomSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: SbSpacing.paddingLG,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle/Indicator
          const Center(
            child: SizedBox(
              width: 40,
              height: 4,
            ),
          ),
          const SizedBox(height: SbSpacing.lg),

          // Header
          Row(
            children: [
              Container(
                padding: SbSpacing.paddingSM,
                
                child: Icon(item.icon, color: colorScheme.primary, size: 24),
              ),
              const SizedBox(width: SbSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RCC Information',
                      style: Theme.of(context).textTheme.titleMedium!,
                    ),
                    Text(
                      'Structural RCC Guidelines',
                      style: Theme.of(context).textTheme.labelMedium!,
                    ),
                  ],
                ),
              ),
              SbButton.icon(
                icon: SbIcons.close,
                onPressed: () {
                  debugPrint('ACTION: Closing RccInfoBottomSheet via X');
                  context.pop();
                },
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.lg),

          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
          const SizedBox(height: SbSpacing.lg),

          // Specs List
          ...item.rccSpecs.map(
            (spec) => SbListItemTile(
              title: spec.label,
              onTap: () {}, // Detail view entry
              trailing: Text(
                spec.value,
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
          ),

          const SizedBox(height: SbSpacing.xxl),

          // Action Buttons
          Column(
            children: [
              if (item.id == 'slab' ||
                  item.id == 'beam' ||
                  item.id == 'column' ||
                  item.id == 'footing') ...[
                SizedBox(
                  width: double.infinity,
                  child: SbButton.primary(
                    onPressed: () {
                      // determine destination based on selected item id
                      final route = switch (item.id) {
                        'slab' => '/slab/design',
                        'beam' => '/beam/input',
                        'column' => '/column/input',
                        'footing' => '/footing/type',
                        _ => '/',
                      };
                      debugPrint('ACTION: Navigating to $route');

                      context.pop();

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.push(route);
                      });
                    },
                    label: 'DESIGN NOW',
                  ),
                ),
                const SizedBox(height: SbSpacing.md),
              ],
              SizedBox(
                width: double.infinity,
                child: SbButton.outline(
                  onPressed: () {
                    debugPrint(
                      'ACTION: Closing RccInfoBottomSheet via GOT IT button',
                    );
                    context.pop();
                  },
                  label: 'GOT IT',
                ),
              ),
            ],
          ),

          const SizedBox(height: SbSpacing.lg),
        ],
      ),
    );
  }
}










