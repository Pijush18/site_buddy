import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

class SpacingLabSection extends StatelessWidget {
  const SpacingLabSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = [
      _TokenData('xs', SbSpacing.xs),
      _TokenData('sm', SbSpacing.sm),
      _TokenData('md', SbSpacing.md),
      _TokenData('lg', SbSpacing.lg),
      _TokenData('xl', SbSpacing.xl),
      _TokenData('xxl', SbSpacing.xxl),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Spacing Tokens', style: Theme.of(context).textTheme.titleMedium!),
        const SizedBox(height: SbSpacing.lg),
        ...tokens.map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: SbSpacing.sm),
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
        const SizedBox(height: SbSpacing.lg),
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
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Center(
            child: Text(
              '${radius.toInt()}',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
          ),
        ),
        const SizedBox(height: SbSpacing.xs),
        Text(name, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
