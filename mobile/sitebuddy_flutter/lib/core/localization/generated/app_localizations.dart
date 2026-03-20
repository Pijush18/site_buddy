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
/// import 'generated/app_localizations.dart';
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

  /// No description provided for @calculator.
  ///
  /// In en, this message translates to:
  /// **'Calc'**
  String get calculator;

  /// No description provided for @design.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get design;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @readyToBuild.
  ///
  /// In en, this message translates to:
  /// **'Ready to Build'**
  String get readyToBuild;

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

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

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

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get imperial;

  /// No description provided for @aiFeatures.
  ///
  /// In en, this message translates to:
  /// **'AI Features'**
  String get aiFeatures;

  /// No description provided for @enableAiSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Enable AI Suggestions'**
  String get enableAiSuggestions;

  /// No description provided for @aiSuggestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get intelligent recommendations during structural design calculations.'**
  String get aiSuggestionsDesc;

  /// No description provided for @autoFillCalculations.
  ///
  /// In en, this message translates to:
  /// **'Auto-fill Calculations'**
  String get autoFillCalculations;

  /// No description provided for @dataAndStorage.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get dataAndStorage;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @clearCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'Removes temporary files to free space'**
  String get clearCacheDesc;

  /// No description provided for @resetAppData.
  ///
  /// In en, this message translates to:
  /// **'Reset App Data'**
  String get resetAppData;

  /// No description provided for @resetAppDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Restores all settings to defaults'**
  String get resetAppDataDesc;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get upToDate;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'RECENT ACTIVITY'**
  String get recentActivity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @fieldTools.
  ///
  /// In en, this message translates to:
  /// **'Field Tools'**
  String get fieldTools;

  /// No description provided for @levelCalc.
  ///
  /// In en, this message translates to:
  /// **'Level Calc'**
  String get levelCalc;

  /// No description provided for @gradient.
  ///
  /// In en, this message translates to:
  /// **'Gradient'**
  String get gradient;

  /// No description provided for @converter.
  ///
  /// In en, this message translates to:
  /// **'Converter'**
  String get converter;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// No description provided for @shareReport.
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get shareReport;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// No description provided for @smartAssistant.
  ///
  /// In en, this message translates to:
  /// **'Smart Assistant'**
  String get smartAssistant;

  /// No description provided for @aiHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask site questions or get instant material calculations.'**
  String get aiHeroSubtitle;

  /// No description provided for @aiInputHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10x5m slab M20...'**
  String get aiInputHint;

  /// No description provided for @quickReadingEntry.
  ///
  /// In en, this message translates to:
  /// **'Quick Reading Entry'**
  String get quickReadingEntry;

  /// No description provided for @levellingLog.
  ///
  /// In en, this message translates to:
  /// **'Levelling Log'**
  String get levellingLog;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectName;

  /// No description provided for @benchmarkRL.
  ///
  /// In en, this message translates to:
  /// **'Benchmark RL'**
  String get benchmarkRL;

  /// No description provided for @currentReducedLevel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT REDUCED LEVEL'**
  String get currentReducedLevel;

  /// No description provided for @instrumentHeight.
  ///
  /// In en, this message translates to:
  /// **'Instrument Height'**
  String get instrumentHeight;

  /// No description provided for @fieldBook.
  ///
  /// In en, this message translates to:
  /// **'Field Book'**
  String get fieldBook;

  /// No description provided for @point.
  ///
  /// In en, this message translates to:
  /// **'Point'**
  String get point;

  /// No description provided for @bs.
  ///
  /// In en, this message translates to:
  /// **'BS'**
  String get bs;

  /// No description provided for @isReading.
  ///
  /// In en, this message translates to:
  /// **'IS'**
  String get isReading;

  /// No description provided for @fs.
  ///
  /// In en, this message translates to:
  /// **'FS'**
  String get fs;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'HI'**
  String get hi;

  /// No description provided for @rl.
  ///
  /// In en, this message translates to:
  /// **'RL'**
  String get rl;

  /// No description provided for @addReading.
  ///
  /// In en, this message translates to:
  /// **'+ Add Reading'**
  String get addReading;

  /// No description provided for @oneReadingAllowedError.
  ///
  /// In en, this message translates to:
  /// **'Only one reading allowed per entry (BS / IS / FS)'**
  String get oneReadingAllowedError;

  /// No description provided for @noReadingsYet.
  ///
  /// In en, this message translates to:
  /// **'No readings yet. Add first point above.'**
  String get noReadingsYet;

  /// No description provided for @rem.
  ///
  /// In en, this message translates to:
  /// **'Rem'**
  String get rem;

  /// No description provided for @cp.
  ///
  /// In en, this message translates to:
  /// **'CP'**
  String get cp;

  /// No description provided for @levelLogSession.
  ///
  /// In en, this message translates to:
  /// **'Level Log Session'**
  String get levelLogSession;

  /// No description provided for @addStation.
  ///
  /// In en, this message translates to:
  /// **'Add Station'**
  String get addStation;

  /// No description provided for @exportPdfReport.
  ///
  /// In en, this message translates to:
  /// **'Export PDF Report'**
  String get exportPdfReport;

  /// No description provided for @noLevelingLogsYet.
  ///
  /// In en, this message translates to:
  /// **'No Leveling Logs Yet'**
  String get noLevelingLogsYet;

  /// No description provided for @tapAddStationToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Add Station\' to start tracking.'**
  String get tapAddStationToStart;

  /// No description provided for @calculationMethod.
  ///
  /// In en, this message translates to:
  /// **'CALCULATION METHOD'**
  String get calculationMethod;

  /// No description provided for @hiMethod.
  ///
  /// In en, this message translates to:
  /// **'H.I. Method'**
  String get hiMethod;

  /// No description provided for @riseFall.
  ///
  /// In en, this message translates to:
  /// **'Rise & Fall'**
  String get riseFall;

  /// No description provided for @plasterEstimator.
  ///
  /// In en, this message translates to:
  /// **'Plaster Estimator'**
  String get plasterEstimator;

  /// No description provided for @plasterArea.
  ///
  /// In en, this message translates to:
  /// **'Plaster Area'**
  String get plasterArea;

  /// No description provided for @wallArea.
  ///
  /// In en, this message translates to:
  /// **'Wall Area (m²)'**
  String get wallArea;

  /// No description provided for @plasterThickness.
  ///
  /// In en, this message translates to:
  /// **'Plaster Thickness (mm)'**
  String get plasterThickness;

  /// No description provided for @typicalThicknessNote.
  ///
  /// In en, this message translates to:
  /// **'Typical: 12 mm internal · 15 mm external · 6 mm ceiling'**
  String get typicalThicknessNote;

  /// No description provided for @mortarRatio.
  ///
  /// In en, this message translates to:
  /// **'MORTAR RATIO'**
  String get mortarRatio;

  /// No description provided for @calculateMaterials.
  ///
  /// In en, this message translates to:
  /// **'Calculate Materials'**
  String get calculateMaterials;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @isCodeNote.
  ///
  /// In en, this message translates to:
  /// **'Calculations use standard volume-proportioning method.\nDry mortar factor: 1.30 · Cement density: 1440 kg/m³ (IS 456:2000).\nCement bag weight: 50 kg.'**
  String get isCodeNote;

  /// No description provided for @estimationResults.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATION RESULTS'**
  String get estimationResults;

  /// No description provided for @mixLabel.
  ///
  /// In en, this message translates to:
  /// **'mix'**
  String get mixLabel;

  /// No description provided for @thickLabel.
  ///
  /// In en, this message translates to:
  /// **'thick'**
  String get thickLabel;

  /// No description provided for @cementBags.
  ///
  /// In en, this message translates to:
  /// **'Cement Bags'**
  String get cementBags;

  /// No description provided for @cementBags_50kg.
  ///
  /// In en, this message translates to:
  /// **'Cement Bags (50 kg)'**
  String get cementBags_50kg;

  /// No description provided for @bags.
  ///
  /// In en, this message translates to:
  /// **'bags'**
  String get bags;

  /// No description provided for @cementWeight.
  ///
  /// In en, this message translates to:
  /// **'Cement Weight'**
  String get cementWeight;

  /// No description provided for @mixRatio.
  ///
  /// In en, this message translates to:
  /// **'Mix Ratio'**
  String get mixRatio;

  /// No description provided for @sandVolume.
  ///
  /// In en, this message translates to:
  /// **'Sand Volume'**
  String get sandVolume;

  /// No description provided for @mortarVolume.
  ///
  /// In en, this message translates to:
  /// **'Mortar Volume'**
  String get mortarVolume;

  /// No description provided for @wetMortarVolume.
  ///
  /// In en, this message translates to:
  /// **'Wet Mortar Volume'**
  String get wetMortarVolume;

  /// No description provided for @engineeringStandards.
  ///
  /// In en, this message translates to:
  /// **'Engineering Standards'**
  String get engineeringStandards;

  /// No description provided for @legalAndAbout.
  ///
  /// In en, this message translates to:
  /// **'Legal & About'**
  String get legalAndAbout;

  /// No description provided for @dryMortarVolume.
  ///
  /// In en, this message translates to:
  /// **'Dry Mortar Volume'**
  String get dryMortarVolume;
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
