import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';

/// Enum representing the type of comparison for determining safety.
enum ResultType {
  /// Value should be less than or equal to allowable (e.g., stress, deflection).
  /// Safety: actual <= allowable.
  lessThan,

  /// Value should be greater than or equal to allowable (e.g., capacity, strength).
  /// Safety: actual >= allowable.
  greaterThan,

  /// Value should be within a range [min, max].
  /// Safety: min <= actual <= max.
  range,
}

/// Enum representing the type of detail row value.
enum DetailValueType {
  /// Regular value without comparison.
  plain,

  /// Actual value with comparison to allowable.
  actual,

  /// Allowable/limit value.
  allowable,

  /// Calculated/derived value.
  calculated,

  /// Ratio value (actual/allowable).
  ratio,
}

/// WIDGET: SbResultCard
/// PURPOSE: Unified result summary card for design checks.
/// FEATURES:
/// - Displays safety indicator (SAFE/UNSAFE) with color system
/// - Displays comparison bar (actual vs allowable)
/// - Shows detail rows for additional values
/// - Supports different comparison types (lessThan, greaterThan, range)
/// - Uses standardized SbCard wrapper
class SbResultCard extends StatelessWidget {
  /// Primary label/title for the result card.
  /// 
  /// For backward compatibility, this widget also accepts [label] parameter
  /// which will be used as the title if [title] is not provided.
  final String? title;

  /// @deprecated Use [title] instead. Kept for backward compatibility.
  /// This parameter will be used if [title] is not provided.
  final String? label;

  /// Comparison bar data.
  final double actual;
  final double allowable;

  /// Optional range bounds for range type comparisons.
  final double? minValue;
  final double? maxValue;

  /// Unit for displaying values.
  final String unit;

  /// Number of decimal places for formatting (default: 2).
  final int decimalPlaces;

  /// Safety status of the result.
  /// - For lessThan: safe if actual <= allowable
  /// - For greaterThan: safe if actual >= allowable
  /// - For range: safe if minValue <= actual <= maxValue
  final bool? isSafe;

  /// Type of comparison for determining safety.
  /// - lessThan: actual should be less than allowable (stress, deflection)
  /// - greaterThan: actual should be greater than allowable (capacity, strength)
  /// - range: actual should be within [minValue, maxValue]
  final ResultType resultType;

  /// Detail rows to display below comparison bar.
  final List<ResultDetailItem> details;

  /// Whether to show the safety indicator badge.
  final bool showSafetyIndicator;

  /// Whether to show the title section.
  final bool showTitle;

  /// Custom color for the safety indicator (overrides default).
  final Color? safetyColor;

  const SbResultCard({
    super.key,
    this.title,
    this.label,
    required this.actual,
    required this.allowable,
    this.minValue,
    this.maxValue,
    required this.unit,
    this.decimalPlaces = 2,
    this.isSafe,
    this.resultType = ResultType.lessThan,
    this.details = const [],
    this.showSafetyIndicator = true,
    this.showTitle = true,
    this.safetyColor,
  });

  /// Gets the resolved title (supports backward compatibility).
  String get resolvedTitle => title ?? label ?? '';

  /// Computes safety status based on result type and values.
  bool get computedIsSafe {
    if (isSafe != null) return isSafe!;

    switch (resultType) {
      case ResultType.lessThan:
        return actual <= allowable;
      case ResultType.greaterThan:
        return actual >= allowable;
      case ResultType.range:
        final min = minValue ?? double.negativeInfinity;
        final max = maxValue ?? double.infinity;
        return actual >= min && actual <= max;
    }
  }

  /// Gets the safety color based on status.
  Color _getSafetyColor(BuildContext context) {
    if (safetyColor != null) return safetyColor!;
    return computedIsSafe
        ? AppColors.success(context)
        : Theme.of(context).colorScheme.error;
  }

  /// Formats a numeric value with the configured decimal places.
  String _formatValue(double value) {
    return value.toStringAsFixed(decimalPlaces);
  }

  /// Gets the formatted display value.
  String get formattedActual => _formatValue(actual);
  String get formattedAllowable => _formatValue(allowable);
  String get formattedMinValue => minValue != null ? _formatValue(minValue!) : '';
  String get formattedMaxValue => maxValue != null ? _formatValue(maxValue!) : '';
  String get formattedRatio {
    if (allowable == 0) return '∞';
    return '${(actual / allowable).toStringAsFixed(decimalPlaces)}x';
  }

  /// Gets the comparison ratio for the comparison bar.
  double get comparisonRatio {
    if (resultType == ResultType.greaterThan && actual > 0) {
      // For greaterThan, ratio shows how much headroom
      return allowable > 0 ? (actual / allowable).clamp(0.0, 2.0) : 0.0;
    }
    // For lessThan and range, show utilization
    if (allowable > 0) {
      return (actual / allowable).clamp(0.0, 1.2);
    }
    return 0.0;
  }

  /// Gets the ratio color based on utilization.
  Color _getRatioColor(BuildContext context, double ratio) {
    if (ratio <= 0.5) return AppColors.success(context);
    if (ratio <= 0.8) return AppColors.warning(context);
    if (ratio <= 1.0) return Theme.of(context).colorScheme.error;
    return Theme.of(context).colorScheme.error;
  }

  @override
  Widget build(BuildContext context) {
    final isResultSafe = computedIsSafe;
    final safetyColor = _getSafetyColor(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title section with safety indicator
          if (showTitle && resolvedTitle.isNotEmpty) ...[
            const SizedBox(height: SbSpacing.lg),
            _buildHeaderSection(context, isResultSafe, safetyColor),
          ] else if (showTitle) ...[
            const SizedBox(height: SbSpacing.lg),
          ],

          // Comparison bar (primary content)
          const SizedBox(height: SbSpacing.lg),
          _buildComparisonBar(context, safetyColor),

          // Detail rows (secondary content)
          if (details.isNotEmpty) ...[
            const SizedBox(height: SbSpacing.lg),
            const Divider(height: 1),
            const SizedBox(height: SbSpacing.md),
            ...details.map(
              (detail) => _buildDetailRow(context, detail, colorScheme),
            ),
          ],

          const SizedBox(height: SbSpacing.lg),
        ],
      ),
    );
  }

  /// Builds the header section with title and safety indicator.
  Widget _buildHeaderSection(
    BuildContext context,
    bool isResultSafe,
    Color safetyColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            resolvedTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        if (showSafetyIndicator && isSafe != null)
          _SafetyIndicator(
            isSafe: isResultSafe,
            color: safetyColor,
          ),
      ],
    );
  }

  /// Builds the comparison bar widget.
  Widget _buildComparisonBar(BuildContext context, Color safetyColor) {
    final ratio = comparisonRatio;
    final ratioColor = _getRatioColor(context, ratio);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Value display row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildValueChip(
              context,
              label: 'Actual',
              value: formattedActual,
              unit: unit,
              color: ratioColor,
            ),
            _buildComparisonOperator(context),
            _buildValueChip(
              context,
              label: _getAllowableLabel(),
              value: _getAllowableDisplayValue(),
              unit: unit,
              color: colorScheme.outline,
            ),
          ],
        ),

        const SizedBox(height: SbSpacing.md),

        // Comparison bar visualization
        _ComparisonBarVisual(
          ratio: ratio,
          color: ratioColor,
          resultType: resultType,
          isSafe: computedIsSafe,
        ),

        const SizedBox(height: SbSpacing.sm),

        // Ratio display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ratio: ',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
            ),
            Text(
              '$formattedActual / $formattedAllowable = $formattedRatio',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ratioColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a value chip displaying label, value, and unit.
  Widget _buildValueChip(
    BuildContext context, {
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SbSpacing.md,
        vertical: SbSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: SbRadius.borderMd,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                ),
          ),
          const SizedBox(height: SbSpacing.xs),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: SbSpacing.xs),
                Text(
                  unit,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                      ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Gets the comparison operator based on result type.
  String _getComparisonOperator() {
    switch (resultType) {
      case ResultType.lessThan:
        return '≤';
      case ResultType.greaterThan:
        return '≥';
      case ResultType.range:
        return '∈';
    }
  }

  /// Builds the comparison operator widget.
  Widget _buildComparisonOperator(BuildContext context) {
    return Text(
      _getComparisonOperator(),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
    );
  }

  /// Gets the allowable label based on result type.
  String _getAllowableLabel() {
    switch (resultType) {
      case ResultType.lessThan:
        return 'Allowable';
      case ResultType.greaterThan:
        return 'Required';
      case ResultType.range:
        return 'Range';
    }
  }

  /// Gets the allowable display value based on result type.
  String _getAllowableDisplayValue() {
    switch (resultType) {
      case ResultType.lessThan:
      case ResultType.greaterThan:
        return formattedAllowable;
      case ResultType.range:
        return '[$formattedMinValue, $formattedMaxValue]';
    }
  }

  /// Builds a detail row widget.
  Widget _buildDetailRow(
    BuildContext context,
    ResultDetailItem detail,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SbSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              detail.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(width: SbSpacing.md),
          _buildDetailValue(context, detail, colorScheme),
        ],
      ),
    );
  }

  /// Builds the detail value widget with appropriate styling.
  Widget _buildDetailValue(
    BuildContext context,
    ResultDetailItem detail,
    ColorScheme colorScheme,
  ) {
    String displayValue;
    Color textColor = colorScheme.onSurface;
    FontWeight fontWeight = FontWeight.normal;

    if (detail.valueType == DetailValueType.ratio && detail.numericValue != null) {
      displayValue = '${detail.numericValue!.toStringAsFixed(decimalPlaces)}x';
      final ratio = detail.numericValue!;
      if (ratio <= 0.5) {
        textColor = AppColors.success(context);
      } else if (ratio <= 0.8) {
        textColor = AppColors.warning(context);
      } else if (ratio <= 1.0) {
        textColor = colorScheme.error;
      } else {
        textColor = colorScheme.error;
      }
      fontWeight = FontWeight.w600;
    } else if (detail.valueType == DetailValueType.plain) {
      displayValue = detail.value;
    } else {
      displayValue = detail.value;
    }

    return Text(
      displayValue,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: fontWeight,
          ),
    );
  }
}

/// SAFETY INDICATOR WIDGET
class _SafetyIndicator extends StatelessWidget {
  final bool isSafe;
  final Color color;

  const _SafetyIndicator({
    required this.isSafe,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SbSpacing.sm,
        vertical: SbSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: SbRadius.borderMd,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSafe ? Icons.check_circle : Icons.warning,
            size: 16,
            color: color,
          ),
          const SizedBox(width: SbSpacing.xs),
          Text(
            isSafe ? 'SAFE' : 'UNSAFE',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

/// COMPARISON BAR VISUALIZATION WIDGET
class _ComparisonBarVisual extends StatelessWidget {
  final double ratio;
  final Color color;
  final ResultType resultType;
  final bool isSafe;

  const _ComparisonBarVisual({
    required this.ratio,
    required this.color,
    required this.resultType,
    required this.isSafe,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final fillWidth = (ratio.clamp(0.0, 1.0)) * maxWidth;
        final markerPosition = maxWidth * 0.833; // 1.0 / 1.2

        return Stack(
          children: [
            // Background track
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            // Fill bar
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: fillWidth,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            // Safety threshold marker (100% line)
            if (resultType == ResultType.lessThan)
              Positioned(
                left: markerPosition - 1,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),

            // Zone indicators
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.error.withValues(alpha: 0.0),
                      colorScheme.error.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// DATA: ResultDetailItem
/// PURPOSE: Data class for result detail rows with value formatting support.
class ResultDetailItem {
  /// Label for the detail row.
  final String label;

  /// Display value (pre-formatted string).
  final String value;

  /// Optional numeric value for ratio calculations and styling.
  final double? numericValue;

  /// Type of value for styling purposes.
  final DetailValueType valueType;

  const ResultDetailItem({
    required this.label,
    required this.value,
    this.numericValue,
    this.valueType = DetailValueType.plain,
  });

  /// Creates a plain text detail item.
  factory ResultDetailItem.plain({
    required String label,
    required String value,
  }) {
    return ResultDetailItem(
      label: label,
      value: value,
      valueType: DetailValueType.plain,
    );
  }

  /// Creates an actual value detail item.
  factory ResultDetailItem.actual({
    required String label,
    required String value,
    double? numericValue,
  }) {
    return ResultDetailItem(
      label: label,
      value: value,
      numericValue: numericValue,
      valueType: DetailValueType.actual,
    );
  }

  /// Creates an allowable/limit detail item.
  factory ResultDetailItem.allowable({
    required String label,
    required String value,
    double? numericValue,
  }) {
    return ResultDetailItem(
      label: label,
      value: value,
      numericValue: numericValue,
      valueType: DetailValueType.allowable,
    );
  }

  /// Creates a calculated/derived value detail item.
  factory ResultDetailItem.calculated({
    required String label,
    required String value,
    double? numericValue,
  }) {
    return ResultDetailItem(
      label: label,
      value: value,
      numericValue: numericValue,
      valueType: DetailValueType.calculated,
    );
  }

  /// Creates a ratio detail item (actual/allowable).
  factory ResultDetailItem.ratio({
    required String label,
    required double ratio,
    int decimalPlaces = 2,
  }) {
    return ResultDetailItem(
      label: label,
      value: '${ratio.toStringAsFixed(decimalPlaces)}x',
      numericValue: ratio,
      valueType: DetailValueType.ratio,
    );
  }
}
