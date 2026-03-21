import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';

/// CLASS: HomeHeaderSection
/// PURPOSE: Isolated UI component for the top of the Home Screen.
class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: SbSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.readyToBuild,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: SbSpacing.xs),
              Text(
                l10n.appName,
                style: textTheme.displayLarge,
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



