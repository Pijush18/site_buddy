import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/features/design/presentation/widgets/optimization/optimization_card.dart';

/// WIDGET: OptimizationList
/// Displays a vertical list of structural optimization suggestions.
class OptimizationList extends StatelessWidget {
  final List<OptimizationOption> options;
  final Function(OptimizationOption)? onOptionSelected;

  const OptimizationList({
    super.key,
    required this.options,
    this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const Center(
        child: Text('No optimization suggestions available for this load.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: options
          .map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: AppLayout.sectionGap),
              child: OptimizationCard(
                option: option,
                onSelected: onOptionSelected != null
                    ? () => onOptionSelected!(option)
                    : null,
              ),
            ),
          )
          .toList(),
    );
  }
}
