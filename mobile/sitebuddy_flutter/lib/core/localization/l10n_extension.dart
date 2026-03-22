import 'package:flutter/widgets.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';

extension LocalizedContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
