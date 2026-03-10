import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';

class EngineeringWidgetsSection extends StatelessWidget {
  const EngineeringWidgetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Engineering Results',
          style: SbTextStyles.title(context),
        ),
        AppLayout.vGap16,
        const DesignResultCard(
          title: 'Foundation Safety Check',
          isSafe: true,
          items: [
            DesignResultItem(
              label: 'Bearing Pressure',
              value: '185.2',
              unit: 'kN/m²',
              subtitle: 'Allowable: 200.0',
            ),
            DesignResultItem(
              label: 'Settlement',
              value: '12.4',
              unit: 'mm',
              isCritical: true,
            ),
          ],
        ),
        AppLayout.vGap16,
        const DesignResultCard(
          title: 'Failed Analysis Example',
          isSafe: false,
          items: [
            DesignResultItem(
              label: 'Slenderness Ratio',
              value: '145.0',
              unit: 'λ',
              isCritical: true,
              subtitle: 'Limit exceeded (120)',
            ),
          ],
        ),
      ],
    );
  }
}
