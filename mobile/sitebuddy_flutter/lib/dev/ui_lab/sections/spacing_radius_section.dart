import 'package:site_buddy/core/theme/app_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

class SpacingLabSection extends StatelessWidget {
  const SpacingLabSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = [
      _TokenData('xs (pTiny)', SbSpacing.xs),
      _TokenData('sm (pSmall)', SbSpacing.sm),
      _TokenData('md (pMedium)', SbSpacing.lg),
      _TokenData('lg (pLarge)', SbSpacing.xxl),
      _TokenData('xl (pHuge)', SbSpacing.xl),
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
                  width: t.value,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
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
        const Row(
          children: [
            _RadiusBox(name: 'Small', radius: AppRadius.sm),
            SizedBox(width: SbSpacing.lg),
            _RadiusBox(name: 'Card', radius: 12.0),
            SizedBox(width: SbSpacing.lg),
            _RadiusBox(name: 'Input', radius: 12.0),
            SizedBox(width: SbSpacing.lg),
            _RadiusBox(name: 'Button', radius: 16.0),
          ],
        ),
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
