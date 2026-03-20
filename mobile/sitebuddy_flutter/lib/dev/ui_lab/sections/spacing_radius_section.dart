import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

class SpacingLabSection extends StatelessWidget {
  const SpacingLabSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = [
      _TokenData('xs (pTiny)', AppLayout.xs),
      _TokenData('sm (pSmall)', AppLayout.sm),
      _TokenData('md (pMedium)', AppLayout.md),
      _TokenData('lg (pLarge)', AppLayout.lg),
      _TokenData('xl (pHuge)', AppLayout.xl),
      _TokenData('xxl', AppLayout.xxl),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Spacing Tokens', style: AppTextStyles.sectionTitle(context)),
        AppLayout.vGap16,
        ...tokens.map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: AppLayout.pSmall),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    t.name,
                    style: AppTextStyles.body(context, secondary: true),
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
          style: AppTextStyles.sectionTitle(context),
        ),
        AppLayout.vGap16,
        const Row(
          children: [
            _RadiusBox(name: 'Small', radius: AppLayout.smallRadius),
            AppLayout.hGap16,
            _RadiusBox(name: 'Card', radius: AppLayout.cardRadius),
            AppLayout.hGap16,
            _RadiusBox(name: 'Input', radius: AppLayout.inputRadius),
            AppLayout.hGap16,
            _RadiusBox(name: 'Button', radius: AppLayout.buttonRadius),
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
              style: AppTextStyles.caption(context),
            ),
          ),
        ),
        AppLayout.vGap4,
        Text(name, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
