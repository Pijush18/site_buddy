
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/core/constants/app_strings.dart';

/// Displays a vertical list of structural optimization suggestions.
class OptimizationList extends StatefulWidget {
  final List<OptimizationOption> options;
  final Function(OptimizationOption)? onOptionSelected;

  const OptimizationList({
    super.key,
    required this.options,
    this.onOptionSelected,
  });

  @override
  State<OptimizationList> createState() => _OptimizationListState();
}

class _OptimizationListState extends State<OptimizationList> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
      return const Center(
        child: Text(AppStrings.noOptimizationSuggestions),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(widget.options.length, (index) {
        final option = widget.options[index];
        final isSelected = _selectedIndex == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: SbSpacing.lg),
          child: SbCard(
            onTap: widget.onOptionSelected != null
                ? () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    widget.onOptionSelected!(option);
                  }
                : null,
            padding: const EdgeInsets.all(SbSpacing.md),
            color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                const SizedBox(height: SbSpacing.sm),
                Text(
                  option.description,
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
                const SizedBox(height: SbSpacing.lg),
                const Divider(height: 1),
                const SizedBox(height: SbSpacing.lg),
                PrimaryCTA(
                  label: isSelected ? 'Selected' : AppStrings.selectOption,
                  icon: isSelected ? Icons.check_circle : null,
                  onPressed: widget.onOptionSelected != null
                      ? () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          widget.onOptionSelected!(option);
                        }
                      : null,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}








