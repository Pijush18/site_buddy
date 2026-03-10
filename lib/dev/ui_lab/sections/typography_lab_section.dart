import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

class TypographyLabSection extends StatelessWidget {
  const TypographyLabSection({super.key});

  @override
  Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

    final styles = [
      _TypoData('Headline Large', SbTextStyles.headlineLarge(context), '32px, Bold'),
      _TypoData('Headline Medium', SbTextStyles.headline(context), '28px, Bold'),
      _TypoData('Title Large', SbTextStyles.title(context), '22px, Bold'),
      _TypoData('Title Medium', SbTextStyles.title(context), '18px, Semibold'),
      _TypoData('Title Small', SbTextStyles.body(context), '16px, Semibold'),
      _TypoData('Body Large', SbTextStyles.body(context), '16px, Regular'),
      _TypoData('Body Medium', SbTextStyles.body(context), '14px, Regular'),
      _TypoData('Body Small', SbTextStyles.bodySecondary(context), '12px, Regular'),
      _TypoData('Label Large', SbTextStyles.button(context), '14px, Medium'),
      _TypoData('Label Small', SbTextStyles.caption(context), '12px, Medium'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Typography System',
          style: SbTextStyles.title(context),
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
                  style: SbTextStyles.bodySecondary(context).copyWith(color: Colors.grey),
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