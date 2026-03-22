import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:site_buddy/shared/domain/models/design/footing_type.dart';

extension FootingTypeL10n on FootingType {
  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case FootingType.isolated:
        return l10n.labelIsolatedFooting;
      case FootingType.combined:
        return l10n.labelCombinedFooting;
      case FootingType.strap:
        return l10n.labelStrapFooting;
      case FootingType.strip:
        return l10n.labelStripFooting;
      case FootingType.raft:
        return l10n.labelRaftFooting;
      case FootingType.pile:
        return l10n.labelPileFooting;
    }
  }

  String getLocalizedDescription(AppLocalizations l10n) {
    switch (this) {
      case FootingType.isolated:
        return l10n.descIsolatedFooting;
      case FootingType.combined:
        return l10n.descCombinedFooting;
      case FootingType.strap:
        return l10n.descStrapFooting;
      case FootingType.strip:
        return l10n.descStripFooting;
      case FootingType.raft:
        return l10n.descRaftFooting;
      case FootingType.pile:
        return l10n.descPileFooting;
    }
  }
}
