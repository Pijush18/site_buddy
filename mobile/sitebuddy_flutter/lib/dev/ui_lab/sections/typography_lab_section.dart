
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

class TypographyLabSection extends StatelessWidget {
  const TypographyLabSection({super.key});

  @override
  Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

    final styles = [
      _TypoData('Screen Title', Theme.of(context).textTheme.titleLarge!, '20px, Bold'),
      _TypoData('Section Title', Theme.of(context).textTheme.titleMedium!, '17px, Semibold'),
      _TypoData('Card Title', Theme.of(context).textTheme.labelLarge!, '14px, Semibold'),
      _TypoData('Body Text', Theme.of(context).textTheme.bodyLarge!, '13px, Regular'),
      _TypoData('Body Secondary', Theme.of(context).textTheme.bodyMedium!, '13px, Regular, Opacity'),
      _TypoData('Caption', Theme.of(context).textTheme.labelMedium!, '12px, Regular'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Typography System',
          style: Theme.of(context).textTheme.titleMedium!,
        ),
        SizedBox(height: SbSpacing.lg),
        ...styles.map(
          (style) => Padding(
            padding: const EdgeInsets.all(SbSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(style.name, style: style.style),
                Text(
                  'Size: ${style.info}',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TypoData {
  final String name;
  final TextStyle style;
  final String info;

  _TypoData(this.name, this.style, this.info);
}








