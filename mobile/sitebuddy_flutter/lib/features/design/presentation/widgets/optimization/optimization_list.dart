import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/components/sb_button.dart';
import 'package:site_buddy/core/widgets/components/sb_card.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/core/constants/app_strings.dart';

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
        child: Text(AppStrings.noOptimizationSuggestions),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: options
          .map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: SBCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      option.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Divider(height: 1),
                    const SizedBox(height: AppSpacing.md),
                    SBButton(
                      label: AppStrings.selectOption,
                      onPressed: onOptionSelected != null
                          ? () => onOptionSelected!(option)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
