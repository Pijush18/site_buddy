import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';



/// WIDGET: SbListGroup
/// PURPOSE: Standardized container for a vertical list of items.
class SbListGroup extends StatelessWidget {
  final List<Widget> children;
  final bool isSubtle;

  const SbListGroup({
    super.key,
    required this.children,
    this.isSubtle = false,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return SbCard(
      padding: EdgeInsets.zero,
      isSubtle: isSubtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent: SbSpacing.lg,
                endIndent: SbSpacing.lg,
                color: context.colors.outline,
              ),


          ],
        ],
      ),
    );
  }
}
