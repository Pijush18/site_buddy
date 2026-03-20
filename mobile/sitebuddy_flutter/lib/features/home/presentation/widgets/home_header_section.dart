import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';

/// CLASS: HomeHeaderSection
/// PURPOSE: Isolated UI component for the top of the Home Screen.
class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppLayout.pMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.readyToBuild,
                style: AppTextStyles.body(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              AppLayout.vGap4,
              Text(
                l10n.appName,
                style: AppTextStyles.screenTitle(context).copyWith(fontSize: 32),
              ),
            ],
          ),

          SbButton.icon(
            icon: SbIcons.account,
            onPressed: () => debugPrint('TODO: action - Profile Settings'),
          ),
        ],
      ),
    );
  }
}
