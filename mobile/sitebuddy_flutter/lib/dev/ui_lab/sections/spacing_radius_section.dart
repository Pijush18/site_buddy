import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_border.dart';


class SpacingLabSection extends StatelessWidget {
  const SpacingLabSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = [
      _TokenData('xs', AppSpacing.xs),
      _TokenData('sm', AppSpacing.sm),
      _TokenData('md', AppSpacing.md),
      _TokenData('lg', AppSpacing.lg),
      _TokenData('xl', AppSpacing.xl),
      _TokenData('xxl', AppSpacing.xxl),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Spacing Tokens', style: Theme.of(context).textTheme.titleMedium!),
        const SizedBox(height: AppSpacing.lg),
        ...tokens.map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    t.name,
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                ),
                Container(
                  height: 24,
                  width: t.value * 2, // Scaled for visibility
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    borderRadius: SbRadius.borderSmall,
                  ),
                  child: Center(
                    child: Text(
                      '${t.value.toInt()}',
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RadiusLabSection extends StatelessWidget {
  const RadiusLabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Radius & Elevation',
          style: Theme.of(context).textTheme.titleMedium!,
        ),
        const SizedBox(height: AppSpacing.lg),
        const _RadiusBox(name: 'Standard', radius: SbRadius.standard),
      ],
    );
  }
}


class _TokenData {
  final String name;
  final double value;
  _TokenData(this.name, this.value);
}

class _RadiusBox extends StatelessWidget {
  final String name;
  final double radius;
  const _RadiusBox({required this.name, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: context.colors.outline, width: AppBorder.width),


          ),
          child: Center(
            child: Text(
              '${radius.toInt()}',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(name, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
