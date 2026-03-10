import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SiteBuddy'**
  String get appName;

  /// No description provided for @safe.
  ///
  /// In en, this message translates to:
  /// **'SAFE'**
  String get safe;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'WARNING'**
  String get warning;

  /// No description provided for @fail.
  ///
  /// In en, this message translates to:
  /// **'FAIL'**
  String get fail;

  /// No description provided for @input.
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get input;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @slabDesign.
  ///
  /// In en, this message translates to:
  /// **'Slab Design'**
  String get slabDesign;

  /// No description provided for @concreteGrade.
  ///
  /// In en, this message translates to:
  /// **'Concrete Grade'**
  String get concreteGrade;

  /// No description provided for @steelGrade.
  ///
  /// In en, this message translates to:
  /// **'Steel Grade'**
  String get steelGrade;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @dimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get dimensions;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @depth.
  ///
  /// In en, this message translates to:
  /// **'Depth'**
  String get depth;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @unitSystem.
  ///
  /// In en, this message translates to:
  /// **'Unit System'**
  String get unitSystem;

  /// No description provided for @slabType.
  ///
  /// In en, this message translates to:
  /// **'SLAB TYPE'**
  String get slabType;

  /// No description provided for @physicalDimensions.
  ///
  /// In en, this message translates to:
  /// **'PHYSICAL DIMENSIONS'**
  String get physicalDimensions;

  /// No description provided for @designResults.
  ///
  /// In en, this message translates to:
  /// **'DESIGN RESULTS'**
  String get designResults;

  /// No description provided for @safetyChecks.
  ///
  /// In en, this message translates to:
  /// **'SAFETY CHECKS'**
  String get safetyChecks;

  /// No description provided for @spanLx.
  ///
  /// In en, this message translates to:
  /// **'Span Lx'**
  String get spanLx;

  /// No description provided for @spanLy.
  ///
  /// In en, this message translates to:
  /// **'Span Ly'**
  String get spanLy;

  /// No description provided for @effectiveDepth.
  ///
  /// In en, this message translates to:
  /// **'Effective Depth'**
  String get effectiveDepth;

  /// No description provided for @bendingMoment.
  ///
  /// In en, this message translates to:
  /// **'Bending Moment'**
  String get bendingMoment;

  /// No description provided for @mainRebar.
  ///
  /// In en, this message translates to:
  /// **'Main Rebar'**
  String get mainRebar;

  /// No description provided for @distributionSteel.
  ///
  /// In en, this message translates to:
  /// **'Distribution Steel'**
  String get distributionSteel;

  /// No description provided for @shear.
  ///
  /// In en, this message translates to:
  /// **'Shear'**
  String get shear;

  /// No description provided for @deflection.
  ///
  /// In en, this message translates to:
  /// **'Deflection'**
  String get deflection;

  /// No description provided for @cracking.
  ///
  /// In en, this message translates to:
  /// **'Cracking'**
  String get cracking;

  /// No description provided for @viewCalculationSheet.
  ///
  /// In en, this message translates to:
  /// **'View Full Calculation Sheet'**
  String get viewCalculationSheet;

  /// No description provided for @shareDesignResult.
  ///
  /// In en, this message translates to:
  /// **'Share Design Report'**
  String get shareDesignResult;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
