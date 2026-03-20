import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

class TypographyLabSection extends StatelessWidget {
  const TypographyLabSection({super.key});

  @override
  Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

    final styles = [
      _TypoData('Screen Title', AppTextStyles.screenTitle(context), '20px, Bold'),
      _TypoData('Section Title', AppTextStyles.sectionTitle(context), '17px, Semibold'),
      _TypoData('Card Title', AppTextStyles.cardTitle(context), '14px, Semibold'),
      _TypoData('Body Text', AppTextStyles.body(context), '13px, Regular'),
      _TypoData('Body Secondary', AppTextStyles.body(context, secondary: true), '13px, Regular, Opacity'),
      _TypoData('Caption', AppTextStyles.caption(context), '12px, Regular'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Typography System',
          style: AppTextStyles.sectionTitle(context),
        ),
        AppLayout.vGap16,
        ...styles.map(
          (style) => Padding(
            padding: const EdgeInsets.all(AppLayout.pSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(style.name, style: style.style),
                Text(
                  'Size: ${style.info}',
                  style: AppTextStyles.body(context, secondary: true).copyWith(color: Colors.grey),
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