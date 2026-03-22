import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';

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
    Locale('ta'),
  ];

  /// No description provided for @titleAppName.
  ///
  /// In en, this message translates to:
  /// **'SiteBuddy'**
  String get titleAppName;

  /// No description provided for @titleSlabDesign.
  ///
  /// In en, this message translates to:
  /// **'Slab Design'**
  String get titleSlabDesign;

  /// No description provided for @titleBeamDesign.
  ///
  /// In en, this message translates to:
  /// **'Beam Design'**
  String get titleBeamDesign;

  /// No description provided for @titleColumnDesign.
  ///
  /// In en, this message translates to:
  /// **'Column Design'**
  String get titleColumnDesign;

  /// No description provided for @titleColumn.
  ///
  /// In en, this message translates to:
  /// **'Column'**
  String get titleColumn;

  /// No description provided for @titleFootingDesign.
  ///
  /// In en, this message translates to:
  /// **'Footing Design'**
  String get titleFootingDesign;

  /// No description provided for @titleLevelCalc.
  ///
  /// In en, this message translates to:
  /// **'Level Calc'**
  String get titleLevelCalc;

  /// No description provided for @titleGradient.
  ///
  /// In en, this message translates to:
  /// **'Gradient'**
  String get titleGradient;

  /// No description provided for @titleConverter.
  ///
  /// In en, this message translates to:
  /// **'Converter'**
  String get titleConverter;

  /// No description provided for @titleCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get titleCurrency;

  /// No description provided for @titleAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get titleAiAssistant;

  /// No description provided for @titleLevellingLog.
  ///
  /// In en, this message translates to:
  /// **'Levelling Log'**
  String get titleLevellingLog;

  /// No description provided for @titleLevelLogSession.
  ///
  /// In en, this message translates to:
  /// **'Level Log Session'**
  String get titleLevelLogSession;

  /// No description provided for @titlePlasterEstimator.
  ///
  /// In en, this message translates to:
  /// **'Plaster Estimator'**
  String get titlePlasterEstimator;

  /// No description provided for @titleConcreteEstimator.
  ///
  /// In en, this message translates to:
  /// **'Concrete Estimator'**
  String get titleConcreteEstimator;

  /// No description provided for @titleCementEstimator.
  ///
  /// In en, this message translates to:
  /// **'Cement Estimator'**
  String get titleCementEstimator;

  /// No description provided for @titleBrickWallEstimator.
  ///
  /// In en, this message translates to:
  /// **'Brick Wall Estimator'**
  String get titleBrickWallEstimator;

  /// No description provided for @titleRebarEstimator.
  ///
  /// In en, this message translates to:
  /// **'Rebar Estimator'**
  String get titleRebarEstimator;

  /// No description provided for @titleExcavationEstimator.
  ///
  /// In en, this message translates to:
  /// **'Excavation Estimator'**
  String get titleExcavationEstimator;

  /// No description provided for @titleShutteringEstimator.
  ///
  /// In en, this message translates to:
  /// **'Shuttering Estimator'**
  String get titleShutteringEstimator;

  /// No description provided for @titleLevelEstimator.
  ///
  /// In en, this message translates to:
  /// **'Level Estimator'**
  String get titleLevelEstimator;

  /// No description provided for @titleGradientEstimator.
  ///
  /// In en, this message translates to:
  /// **'Gradient Estimator'**
  String get titleGradientEstimator;

  /// No description provided for @titleSandEstimator.
  ///
  /// In en, this message translates to:
  /// **'Sand Estimator'**
  String get titleSandEstimator;

  /// No description provided for @titleDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get titleDashboard;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SiteBuddy'**
  String get appName;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @chooseHowAppAppears.
  ///
  /// In en, this message translates to:
  /// **'Choose how SiteBuddy appears'**
  String get chooseHowAppAppears;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

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

  /// No description provided for @unitSystem.
  ///
  /// In en, this message translates to:
  /// **'Unit System'**
  String get unitSystem;

  /// No description provided for @selectMeasurementSystem.
  ///
  /// In en, this message translates to:
  /// **'Select measurement system'**
  String get selectMeasurementSystem;

  /// No description provided for @appBehavior.
  ///
  /// In en, this message translates to:
  /// **'App Behavior'**
  String get appBehavior;

  /// No description provided for @restoreLastScreen.
  ///
  /// In en, this message translates to:
  /// **'Restore Last Screen on Launch'**
  String get restoreLastScreen;

  /// No description provided for @continueWhereLeftOff.
  ///
  /// In en, this message translates to:
  /// **'Continue where you left off when reopening the app.'**
  String get continueWhereLeftOff;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default Settings'**
  String get resetToDefault;

  /// No description provided for @revertSettingsState.
  ///
  /// In en, this message translates to:
  /// **'Revert all settings to their original state'**
  String get revertSettingsState;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @subscriptionBilling.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Billing'**
  String get subscriptionBilling;

  /// No description provided for @noEmailRegistered.
  ///
  /// In en, this message translates to:
  /// **'No Email Registered'**
  String get noEmailRegistered;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get freePlan;

  /// No description provided for @premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get premiumPlan;

  /// No description provided for @resetSettingsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings?'**
  String get resetSettingsQuestion;

  /// No description provided for @settingsResetToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Settings reset to defaults'**
  String get settingsResetToDefaults;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @selectPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get selectPreferredLanguage;

  /// No description provided for @titleToolbox.
  ///
  /// In en, this message translates to:
  /// **'Engineering Toolbox'**
  String get titleToolbox;

  /// No description provided for @titleReportPreview.
  ///
  /// In en, this message translates to:
  /// **'Report Preview'**
  String get titleReportPreview;

  /// No description provided for @titleBeamInput.
  ///
  /// In en, this message translates to:
  /// **'Beam Geometry'**
  String get titleBeamInput;

  /// No description provided for @titleLoads.
  ///
  /// In en, this message translates to:
  /// **'Loads'**
  String get titleLoads;

  /// No description provided for @titleAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis Summary'**
  String get titleAnalysis;

  /// No description provided for @titleReinforcement.
  ///
  /// In en, this message translates to:
  /// **'Reinforcement Design'**
  String get titleReinforcement;

  /// No description provided for @titleBeamSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety Check'**
  String get titleBeamSafety;

  /// No description provided for @navCalculator.
  ///
  /// In en, this message translates to:
  /// **'Calc'**
  String get navCalculator;

  /// No description provided for @navDesign.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get navDesign;

  /// No description provided for @navProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get navProject;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @actionCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get actionCalculate;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get actionReset;

  /// No description provided for @actionViewCalcSheet.
  ///
  /// In en, this message translates to:
  /// **'View Full Calculation Sheet'**
  String get actionViewCalcSheet;

  /// No description provided for @actionShareDesign.
  ///
  /// In en, this message translates to:
  /// **'Share Design Report'**
  String get actionShareDesign;

  /// No description provided for @actionClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get actionClearCache;

  /// No description provided for @actionResetAppData.
  ///
  /// In en, this message translates to:
  /// **'Reset App Data'**
  String get actionResetAppData;

  /// No description provided for @actionViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get actionViewAll;

  /// No description provided for @actionNewProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get actionNewProject;

  /// No description provided for @actionShareReport.
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get actionShareReport;

  /// No description provided for @actionAddReading.
  ///
  /// In en, this message translates to:
  /// **'+ Add Reading'**
  String get actionAddReading;

  /// No description provided for @actionAddStation.
  ///
  /// In en, this message translates to:
  /// **'Add Station'**
  String get actionAddStation;

  /// No description provided for @actionExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get actionExportPdf;

  /// No description provided for @actionCalculateMaterials.
  ///
  /// In en, this message translates to:
  /// **'Calculate Materials'**
  String get actionCalculateMaterials;

  /// No description provided for @actionLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get actionLogin;

  /// No description provided for @actionOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get actionSubmit;

  /// No description provided for @actionClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get actionClearAll;

  /// No description provided for @actionSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get actionSignIn;

  /// No description provided for @actionSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get actionSignOut;

  /// No description provided for @actionRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get actionRegister;

  /// No description provided for @actionForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get actionForgotPassword;

  /// No description provided for @labelSafe.
  ///
  /// In en, this message translates to:
  /// **'SAFE'**
  String get labelSafe;

  /// No description provided for @labelWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING'**
  String get labelWarning;

  /// No description provided for @labelFail.
  ///
  /// In en, this message translates to:
  /// **'FAIL'**
  String get labelFail;

  /// No description provided for @labelEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get labelEnglish;

  /// No description provided for @labelHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get labelHindi;

  /// No description provided for @labelTamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get labelTamil;

  /// No description provided for @labelConcreteGrade.
  ///
  /// In en, this message translates to:
  /// **'Concrete Grade'**
  String get labelConcreteGrade;

  /// No description provided for @labelSteelGrade.
  ///
  /// In en, this message translates to:
  /// **'Steel Grade'**
  String get labelSteelGrade;

  /// No description provided for @labelIsolatedFooting.
  ///
  /// In en, this message translates to:
  /// **'Isolated Footing'**
  String get labelIsolatedFooting;

  /// No description provided for @labelColumn.
  ///
  /// In en, this message translates to:
  /// **'Column'**
  String get labelColumn;

  /// No description provided for @labelDimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get labelDimensions;

  /// No description provided for @descIsolatedFooting.
  ///
  /// In en, this message translates to:
  /// **'Single column support, square or rectangular.'**
  String get descIsolatedFooting;

  /// No description provided for @labelCombinedFooting.
  ///
  /// In en, this message translates to:
  /// **'Combined Footing'**
  String get labelCombinedFooting;

  /// No description provided for @descCombinedFooting.
  ///
  /// In en, this message translates to:
  /// **'Supports two or more columns.'**
  String get descCombinedFooting;

  /// No description provided for @labelStrapFooting.
  ///
  /// In en, this message translates to:
  /// **'Strap Footing'**
  String get labelStrapFooting;

  /// No description provided for @descStrapFooting.
  ///
  /// In en, this message translates to:
  /// **'Two footings connected by a structural strap beam.'**
  String get descStrapFooting;

  /// No description provided for @labelStripFooting.
  ///
  /// In en, this message translates to:
  /// **'Strip / Continuous'**
  String get labelStripFooting;

  /// No description provided for @descStripFooting.
  ///
  /// In en, this message translates to:
  /// **'Supports a load-bearing wall or row of columns.'**
  String get descStripFooting;

  /// No description provided for @labelRaftFooting.
  ///
  /// In en, this message translates to:
  /// **'Raft / Mat'**
  String get labelRaftFooting;

  /// No description provided for @descRaftFooting.
  ///
  /// In en, this message translates to:
  /// **'Large slab supporting the entire building area.'**
  String get descRaftFooting;

  /// No description provided for @labelPileFooting.
  ///
  /// In en, this message translates to:
  /// **'Pile Footing'**
  String get labelPileFooting;

  /// No description provided for @descPileFooting.
  ///
  /// In en, this message translates to:
  /// **'Deep foundation for low-bearing soil conditions.'**
  String get descPileFooting;

  /// No description provided for @labelStep2Loads.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Loads'**
  String get labelStep2Loads;

  /// No description provided for @labelColumn1Loading.
  ///
  /// In en, this message translates to:
  /// **'Column 1 Loading'**
  String get labelColumn1Loading;

  /// No description provided for @labelColumn2Loading.
  ///
  /// In en, this message translates to:
  /// **'Column 2 Loading'**
  String get labelColumn2Loading;

  /// No description provided for @labelAxialLoadP1Unit.
  ///
  /// In en, this message translates to:
  /// **'Axial Load (P1) (kN)'**
  String get labelAxialLoadP1Unit;

  /// No description provided for @labelAxialLoadP2Unit.
  ///
  /// In en, this message translates to:
  /// **'Axial Load (P2) (kN)'**
  String get labelAxialLoadP2Unit;

  /// No description provided for @labelMx1Unit.
  ///
  /// In en, this message translates to:
  /// **'Mx1 (kNm)'**
  String get labelMx1Unit;

  /// No description provided for @labelMy1Unit.
  ///
  /// In en, this message translates to:
  /// **'My1 (kNm)'**
  String get labelMy1Unit;

  /// No description provided for @labelMx2Unit.
  ///
  /// In en, this message translates to:
  /// **'Mx2 (kNm)'**
  String get labelMx2Unit;

  /// No description provided for @labelMy2Unit.
  ///
  /// In en, this message translates to:
  /// **'My2 (kNm)'**
  String get labelMy2Unit;

  /// No description provided for @labelBearingCapacityUnit.
  ///
  /// In en, this message translates to:
  /// **'Bearing Capacity (kN/m²)'**
  String get labelBearingCapacityUnit;

  /// No description provided for @labelDiameter.
  ///
  /// In en, this message translates to:
  /// **'Diameter'**
  String get labelDiameter;

  /// No description provided for @labelLoad.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get labelLoad;

  /// No description provided for @labelReinforcement.
  ///
  /// In en, this message translates to:
  /// **'Reinforcement'**
  String get labelReinforcement;

  /// No description provided for @labelSpacing.
  ///
  /// In en, this message translates to:
  /// **'Spacing'**
  String get labelSpacing;

  /// No description provided for @labelLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get labelLanguage;

  /// No description provided for @labelUnitSystem.
  ///
  /// In en, this message translates to:
  /// **'Unit System'**
  String get labelUnitSystem;

  /// No description provided for @labelSlabType.
  ///
  /// In en, this message translates to:
  /// **'SLAB TYPE'**
  String get labelSlabType;

  /// No description provided for @labelPhysicalDimensions.
  ///
  /// In en, this message translates to:
  /// **'PHYSICAL DIMENSIONS'**
  String get labelPhysicalDimensions;

  /// No description provided for @labelDesignResults.
  ///
  /// In en, this message translates to:
  /// **'DESIGN RESULTS'**
  String get labelDesignResults;

  /// No description provided for @msgCodeNoteSlenderness.
  ///
  /// In en, this message translates to:
  /// **'Based on IS 456 Cl 39.7.1'**
  String get msgCodeNoteSlenderness;

  /// No description provided for @labelLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get labelLength;

  /// No description provided for @labelWidth.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get labelWidth;

  /// No description provided for @labelHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get labelHeight;

  /// No description provided for @labelDepth.
  ///
  /// In en, this message translates to:
  /// **'Depth'**
  String get labelDepth;

  /// No description provided for @labelStep3Geometry.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Geometry'**
  String get labelStep3Geometry;

  /// No description provided for @titleSafetyCheck.
  ///
  /// In en, this message translates to:
  /// **'Safety Check'**
  String get titleSafetyCheck;

  /// No description provided for @titleSafetyChecks.
  ///
  /// In en, this message translates to:
  /// **'Safety Checks'**
  String get titleSafetyChecks;

  /// No description provided for @labelStep5Reinforcement.
  ///
  /// In en, this message translates to:
  /// **'Step 5: Reinforcement'**
  String get labelStep5Reinforcement;

  /// No description provided for @labelSteelRequirement.
  ///
  /// In en, this message translates to:
  /// **'Steel Requirement'**
  String get labelSteelRequirement;

  /// No description provided for @labelMinRequiredAst.
  ///
  /// In en, this message translates to:
  /// **'Min. Required Ast'**
  String get labelMinRequiredAst;

  /// No description provided for @labelProvidedAst.
  ///
  /// In en, this message translates to:
  /// **'Provided Ast'**
  String get labelProvidedAst;

  /// No description provided for @msgBendingMomentAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Based on Bending Moment analysis'**
  String get msgBendingMomentAnalysis;

  /// No description provided for @labelDesignVisualization.
  ///
  /// In en, this message translates to:
  /// **'Design Visualization'**
  String get labelDesignVisualization;

  /// No description provided for @labelBarDetailing.
  ///
  /// In en, this message translates to:
  /// **'Bar Detailing'**
  String get labelBarDetailing;

  /// No description provided for @labelMainReinforcementX.
  ///
  /// In en, this message translates to:
  /// **'Main Reinforcement (X-Direction)'**
  String get labelMainReinforcementX;

  /// No description provided for @labelDistributionSteelY.
  ///
  /// In en, this message translates to:
  /// **'Distribution Steel (Y-Direction)'**
  String get labelDistributionSteelY;

  /// No description provided for @unitCC.
  ///
  /// In en, this message translates to:
  /// **'c/c'**
  String get unitCC;

  /// No description provided for @labelStep4Analysis.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Analysis'**
  String get labelStep4Analysis;

  /// No description provided for @labelBearingArea.
  ///
  /// In en, this message translates to:
  /// **'Bearing Area'**
  String get labelBearingArea;

  /// No description provided for @labelAreaReq.
  ///
  /// In en, this message translates to:
  /// **'Area Req'**
  String get labelAreaReq;

  /// No description provided for @labelAreaProv.
  ///
  /// In en, this message translates to:
  /// **'Area Prov'**
  String get labelAreaProv;

  /// No description provided for @msgSelfWeightIncluded.
  ///
  /// In en, this message translates to:
  /// **'Includes 10% self-weight'**
  String get msgSelfWeightIncluded;

  /// No description provided for @labelSoilPressure.
  ///
  /// In en, this message translates to:
  /// **'Soil Pressure'**
  String get labelSoilPressure;

  /// No description provided for @labelMaxPressure.
  ///
  /// In en, this message translates to:
  /// **'Max Pressure'**
  String get labelMaxPressure;

  /// No description provided for @labelMinPressure.
  ///
  /// In en, this message translates to:
  /// **'Min Pressure'**
  String get labelMinPressure;

  /// No description provided for @labelAllowable.
  ///
  /// In en, this message translates to:
  /// **'Allowable'**
  String get labelAllowable;

  /// No description provided for @msgSlsLimit.
  ///
  /// In en, this message translates to:
  /// **'Serviceability Limit State'**
  String get msgSlsLimit;

  /// No description provided for @labelPilesRequired.
  ///
  /// In en, this message translates to:
  /// **'Piles Required'**
  String get labelPilesRequired;

  /// No description provided for @labelColumnAUnit.
  ///
  /// In en, this message translates to:
  /// **'Column A (mm)'**
  String get labelColumnAUnit;

  /// No description provided for @labelColumnBUnit.
  ///
  /// In en, this message translates to:
  /// **'Column B (mm)'**
  String get labelColumnBUnit;

  /// No description provided for @msgCriticalShearBending.
  ///
  /// In en, this message translates to:
  /// **'Critical for shear and bending calculations at face.'**
  String get msgCriticalShearBending;

  /// No description provided for @labelWidthBUnit.
  ///
  /// In en, this message translates to:
  /// **'Width (b) (mm)'**
  String get labelWidthBUnit;

  /// No description provided for @labelLengthLUnit.
  ///
  /// In en, this message translates to:
  /// **'Length (L) (mm)'**
  String get labelLengthLUnit;

  /// No description provided for @labelThicknessDUnit.
  ///
  /// In en, this message translates to:
  /// **'Thickness (D) (mm)'**
  String get labelThicknessDUnit;

  /// No description provided for @labelColumnSpacingUnit.
  ///
  /// In en, this message translates to:
  /// **'Column C/C Spacing (mm)'**
  String get labelColumnSpacingUnit;

  /// No description provided for @actionCalculationSheet.
  ///
  /// In en, this message translates to:
  /// **'Calculation Sheet'**
  String get actionCalculationSheet;

  /// No description provided for @msgGeneratingReport.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF Report...'**
  String get msgGeneratingReport;

  /// No description provided for @errorGeneratingReport.
  ///
  /// In en, this message translates to:
  /// **'Error generating report: {error}'**
  String errorGeneratingReport(Object error);

  /// No description provided for @actionNewDesign.
  ///
  /// In en, this message translates to:
  /// **'New Design'**
  String get actionNewDesign;

  /// No description provided for @actionSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Save Image'**
  String get actionSaveImage;

  /// No description provided for @actionSavePdf.
  ///
  /// In en, this message translates to:
  /// **'Save PDF'**
  String get actionSavePdf;

  /// No description provided for @labelDesignValidation.
  ///
  /// In en, this message translates to:
  /// **'Design Validation'**
  String get labelDesignValidation;

  /// No description provided for @labelDesignSafe.
  ///
  /// In en, this message translates to:
  /// **'DESIGN IS SAFE'**
  String get labelDesignSafe;

  /// No description provided for @labelDesignUnsafe.
  ///
  /// In en, this message translates to:
  /// **'DESIGN UNSAFE'**
  String get labelDesignUnsafe;

  /// No description provided for @labelSoilBearing.
  ///
  /// In en, this message translates to:
  /// **'Soil Bearing'**
  String get labelSoilBearing;

  /// No description provided for @labelMaxPressureQMax.
  ///
  /// In en, this message translates to:
  /// **'Max Pressure (q_max)'**
  String get labelMaxPressureQMax;

  /// No description provided for @labelAllowableSbc.
  ///
  /// In en, this message translates to:
  /// **'Allowable SBC'**
  String get labelAllowableSbc;

  /// No description provided for @labelShearValidation.
  ///
  /// In en, this message translates to:
  /// **'Shear Validation'**
  String get labelShearValidation;

  /// No description provided for @labelOneWayShearTauV.
  ///
  /// In en, this message translates to:
  /// **'One-Way Shear (τv)'**
  String get labelOneWayShearTauV;

  /// No description provided for @msgLimitTauC.
  ///
  /// In en, this message translates to:
  /// **'Limit τc: {limit} N/mm²'**
  String msgLimitTauC(Object limit);

  /// No description provided for @labelPunchingShearVu.
  ///
  /// In en, this message translates to:
  /// **'Punching Shear (Vu)'**
  String get labelPunchingShearVu;

  /// No description provided for @msgEffectiveDepth.
  ///
  /// In en, this message translates to:
  /// **'Effective Depth: {depth} mm'**
  String msgEffectiveDepth(Object depth);

  /// No description provided for @labelPileRequirements.
  ///
  /// In en, this message translates to:
  /// **'Pile Requirements'**
  String get labelPileRequirements;

  /// No description provided for @labelPileCheck.
  ///
  /// In en, this message translates to:
  /// **'Pile Check'**
  String get labelPileCheck;

  /// No description provided for @labelNumberOfPiles.
  ///
  /// In en, this message translates to:
  /// **'Number of Piles'**
  String get labelNumberOfPiles;

  /// No description provided for @labelReinforcementLayout.
  ///
  /// In en, this message translates to:
  /// **'Reinforcement Layout'**
  String get labelReinforcementLayout;

  /// No description provided for @msgSettlementWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: Low SBC detected. Consider detailed settlement analysis.'**
  String get msgSettlementWarning;

  /// No description provided for @labelEconomicalAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Economical Alternatives'**
  String get labelEconomicalAlternatives;

  /// No description provided for @msgFootingAreaCapture.
  ///
  /// In en, this message translates to:
  /// **'For {type}, ensure dimensions capture the full required bearing area of {area} m².'**
  String msgFootingAreaCapture(String type, String area);

  /// No description provided for @labelSpanLx.
  ///
  /// In en, this message translates to:
  /// **'Span Lx (m)'**
  String get labelSpanLx;

  /// No description provided for @labelSpanLy.
  ///
  /// In en, this message translates to:
  /// **'Span Ly (m)'**
  String get labelSpanLy;

  /// No description provided for @labelEffectiveDepth.
  ///
  /// In en, this message translates to:
  /// **'Effective Depth'**
  String get labelEffectiveDepth;

  /// No description provided for @labelBendingMoment.
  ///
  /// In en, this message translates to:
  /// **'Bending Moment'**
  String get labelBendingMoment;

  /// No description provided for @labelMainRebar.
  ///
  /// In en, this message translates to:
  /// **'Main Rebar'**
  String get labelMainRebar;

  /// No description provided for @labelDistributionSteel.
  ///
  /// In en, this message translates to:
  /// **'Distribution Steel'**
  String get labelDistributionSteel;

  /// No description provided for @labelShear.
  ///
  /// In en, this message translates to:
  /// **'Shear'**
  String get labelShear;

  /// No description provided for @labelDeflection.
  ///
  /// In en, this message translates to:
  /// **'Deflection'**
  String get labelDeflection;

  /// No description provided for @labelCracking.
  ///
  /// In en, this message translates to:
  /// **'Cracking'**
  String get labelCracking;

  /// No description provided for @labelAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get labelAppearance;

  /// No description provided for @labelLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get labelLight;

  /// No description provided for @labelDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get labelDark;

  /// No description provided for @labelThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get labelThemeMode;

  /// No description provided for @labelMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get labelMetric;

  /// No description provided for @labelImperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get labelImperial;

  /// No description provided for @labelAiFeatures.
  ///
  /// In en, this message translates to:
  /// **'AI Features'**
  String get labelAiFeatures;

  /// No description provided for @labelEnableAiSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Enable AI Suggestions'**
  String get labelEnableAiSuggestions;

  /// No description provided for @labelAutoFillCalculations.
  ///
  /// In en, this message translates to:
  /// **'Auto-fill Calculations'**
  String get labelAutoFillCalculations;

  /// No description provided for @labelDataAndStorage.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get labelDataAndStorage;

  /// No description provided for @labelAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get labelAppVersion;

  /// No description provided for @labelDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get labelDeveloper;

  /// No description provided for @labelPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get labelPrivacyPolicy;

  /// No description provided for @labelTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get labelTermsAndConditions;

  /// No description provided for @labelRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'RECENT ACTIVITY'**
  String get labelRecentActivity;

  /// No description provided for @labelFieldTools.
  ///
  /// In en, this message translates to:
  /// **'Field Tools'**
  String get labelFieldTools;

  /// No description provided for @labelQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get labelQuickActions;

  /// No description provided for @labelQuickReadingEntry.
  ///
  /// In en, this message translates to:
  /// **'Quick Reading Entry'**
  String get labelQuickReadingEntry;

  /// No description provided for @labelProjectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get labelProjectName;

  /// No description provided for @labelBenchmarkRL.
  ///
  /// In en, this message translates to:
  /// **'Benchmark RL'**
  String get labelBenchmarkRL;

  /// No description provided for @labelCurrentRL.
  ///
  /// In en, this message translates to:
  /// **'CURRENT REDUCED LEVEL'**
  String get labelCurrentRL;

  /// No description provided for @labelInstrumentHeight.
  ///
  /// In en, this message translates to:
  /// **'Instrument Height'**
  String get labelInstrumentHeight;

  /// No description provided for @labelFieldBook.
  ///
  /// In en, this message translates to:
  /// **'Field Book'**
  String get labelFieldBook;

  /// No description provided for @labelPoint.
  ///
  /// In en, this message translates to:
  /// **'Point'**
  String get labelPoint;

  /// No description provided for @labelBS.
  ///
  /// In en, this message translates to:
  /// **'BS'**
  String get labelBS;

  /// No description provided for @labelIS.
  ///
  /// In en, this message translates to:
  /// **'IS'**
  String get labelIS;

  /// No description provided for @labelFS.
  ///
  /// In en, this message translates to:
  /// **'FS'**
  String get labelFS;

  /// No description provided for @labelHI.
  ///
  /// In en, this message translates to:
  /// **'HI'**
  String get labelHI;

  /// No description provided for @labelRL.
  ///
  /// In en, this message translates to:
  /// **'RL'**
  String get labelRL;

  /// No description provided for @labelRem.
  ///
  /// In en, this message translates to:
  /// **'Rem'**
  String get labelRem;

  /// No description provided for @labelCP.
  ///
  /// In en, this message translates to:
  /// **'CP'**
  String get labelCP;

  /// No description provided for @labelCalcMethod.
  ///
  /// In en, this message translates to:
  /// **'CALCULATION METHOD'**
  String get labelCalcMethod;

  /// No description provided for @labelHiMethod.
  ///
  /// In en, this message translates to:
  /// **'H.I. Method'**
  String get labelHiMethod;

  /// No description provided for @labelRiseFall.
  ///
  /// In en, this message translates to:
  /// **'Rise & Fall'**
  String get labelRiseFall;

  /// No description provided for @labelPlasterArea.
  ///
  /// In en, this message translates to:
  /// **'Plaster Area'**
  String get labelPlasterArea;

  /// No description provided for @labelWallArea.
  ///
  /// In en, this message translates to:
  /// **'Wall Area (m²)'**
  String get labelWallArea;

  /// No description provided for @labelPlasterThickness.
  ///
  /// In en, this message translates to:
  /// **'Plaster Thickness (mm)'**
  String get labelPlasterThickness;

  /// No description provided for @labelMortarRatio.
  ///
  /// In en, this message translates to:
  /// **'MORTAR RATIO'**
  String get labelMortarRatio;

  /// No description provided for @labelEstimationResults.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATION RESULTS'**
  String get labelEstimationResults;

  /// No description provided for @labelMix.
  ///
  /// In en, this message translates to:
  /// **'mix'**
  String get labelMix;

  /// No description provided for @labelThick.
  ///
  /// In en, this message translates to:
  /// **'thick'**
  String get labelThick;

  /// No description provided for @labelCementBags.
  ///
  /// In en, this message translates to:
  /// **'Cement Bags'**
  String get labelCementBags;

  /// No description provided for @labelCementBags50kg.
  ///
  /// In en, this message translates to:
  /// **'Cement Bags (50 kg)'**
  String get labelCementBags50kg;

  /// No description provided for @labelBags.
  ///
  /// In en, this message translates to:
  /// **'bags'**
  String get labelBags;

  /// No description provided for @labelCementWeight.
  ///
  /// In en, this message translates to:
  /// **'Cement Weight'**
  String get labelCementWeight;

  /// No description provided for @labelMixRatio.
  ///
  /// In en, this message translates to:
  /// **'Mix Ratio'**
  String get labelMixRatio;

  /// No description provided for @labelSandVolume.
  ///
  /// In en, this message translates to:
  /// **'Sand Volume'**
  String get labelSandVolume;

  /// No description provided for @labelMortarVolume.
  ///
  /// In en, this message translates to:
  /// **'Mortar Volume'**
  String get labelMortarVolume;

  /// No description provided for @labelWetMortarVolume.
  ///
  /// In en, this message translates to:
  /// **'Wet Mortar Volume'**
  String get labelWetMortarVolume;

  /// No description provided for @labelWetVolume.
  ///
  /// In en, this message translates to:
  /// **'Wet Volume'**
  String get labelWetVolume;

  /// No description provided for @labelDryVolume.
  ///
  /// In en, this message translates to:
  /// **'Dry Volume'**
  String get labelDryVolume;

  /// No description provided for @labelAggregate.
  ///
  /// In en, this message translates to:
  /// **'Aggregate'**
  String get labelAggregate;

  /// No description provided for @labelWastage.
  ///
  /// In en, this message translates to:
  /// **'Wastage'**
  String get labelWastage;

  /// No description provided for @labelPricePerBag.
  ///
  /// In en, this message translates to:
  /// **'Price per Bag'**
  String get labelPricePerBag;

  /// No description provided for @labelEstimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost'**
  String get labelEstimatedCost;

  /// No description provided for @labelThickness.
  ///
  /// In en, this message translates to:
  /// **'Thickness'**
  String get labelThickness;

  /// No description provided for @labelArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get labelArea;

  /// No description provided for @labelVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get labelVolume;

  /// No description provided for @labelRatio.
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get labelRatio;

  /// No description provided for @labelRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get labelRate;

  /// No description provided for @labelParameters.
  ///
  /// In en, this message translates to:
  /// **'Parameters'**
  String get labelParameters;

  /// No description provided for @labelPressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get labelPressure;

  /// No description provided for @labelEccentricity.
  ///
  /// In en, this message translates to:
  /// **'Eccentricity'**
  String get labelEccentricity;

  /// No description provided for @labelStructure.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get labelStructure;

  /// No description provided for @labelIncludeBottom.
  ///
  /// In en, this message translates to:
  /// **'Include Bottom?'**
  String get labelIncludeBottom;

  /// No description provided for @labelBars.
  ///
  /// In en, this message translates to:
  /// **'Bars'**
  String get labelBars;

  /// No description provided for @labelTotalLength.
  ///
  /// In en, this message translates to:
  /// **'Total Length'**
  String get labelTotalLength;

  /// No description provided for @labelTotalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight'**
  String get labelTotalWeight;

  /// No description provided for @labelTotalArea.
  ///
  /// In en, this message translates to:
  /// **'Total Area'**
  String get labelTotalArea;

  /// No description provided for @labelPerimeter.
  ///
  /// In en, this message translates to:
  /// **'Perimeter'**
  String get labelPerimeter;

  /// No description provided for @labelComparison.
  ///
  /// In en, this message translates to:
  /// **'Comparison'**
  String get labelComparison;

  /// No description provided for @labelStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get labelStart;

  /// No description provided for @labelEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get labelEnd;

  /// No description provided for @labelRise.
  ///
  /// In en, this message translates to:
  /// **'Rise'**
  String get labelRise;

  /// No description provided for @labelFall.
  ///
  /// In en, this message translates to:
  /// **'Fall'**
  String get labelFall;

  /// No description provided for @labelFlat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get labelFlat;

  /// No description provided for @labelDifference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get labelDifference;

  /// No description provided for @labelGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get labelGrade;

  /// No description provided for @labelSpecification.
  ///
  /// In en, this message translates to:
  /// **'Specification'**
  String get labelSpecification;

  /// No description provided for @labelSteel.
  ///
  /// In en, this message translates to:
  /// **'Steel'**
  String get labelSteel;

  /// No description provided for @labelBindingWire.
  ///
  /// In en, this message translates to:
  /// **'Binding Wire'**
  String get labelBindingWire;

  /// No description provided for @labelSlopeCalculator.
  ///
  /// In en, this message translates to:
  /// **'Slope Calculator'**
  String get labelSlopeCalculator;

  /// No description provided for @labelVerticalRise.
  ///
  /// In en, this message translates to:
  /// **'Vertical Rise'**
  String get labelVerticalRise;

  /// No description provided for @labelHorizontalRun.
  ///
  /// In en, this message translates to:
  /// **'Horizontal Run'**
  String get labelHorizontalRun;

  /// No description provided for @labelPercentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get labelPercentage;

  /// No description provided for @labelAngle.
  ///
  /// In en, this message translates to:
  /// **'Angle'**
  String get labelAngle;

  /// No description provided for @labelVertical.
  ///
  /// In en, this message translates to:
  /// **'Vertical'**
  String get labelVertical;

  /// No description provided for @labelClassification.
  ///
  /// In en, this message translates to:
  /// **'Classification'**
  String get labelClassification;

  /// No description provided for @labelMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get labelMild;

  /// No description provided for @labelModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get labelModerate;

  /// No description provided for @labelSteep.
  ///
  /// In en, this message translates to:
  /// **'Steep'**
  String get labelSteep;

  /// No description provided for @labelSlopeVisualization.
  ///
  /// In en, this message translates to:
  /// **'Slope Visualization'**
  String get labelSlopeVisualization;

  /// No description provided for @labelFieldReference.
  ///
  /// In en, this message translates to:
  /// **'Field Reference'**
  String get labelFieldReference;

  /// No description provided for @labelSewerPipes.
  ///
  /// In en, this message translates to:
  /// **'Sewer Pipes'**
  String get labelSewerPipes;

  /// No description provided for @labelRoadCrossFall.
  ///
  /// In en, this message translates to:
  /// **'Road Cross-fall'**
  String get labelRoadCrossFall;

  /// No description provided for @labelWheelchairRamp.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair Ramp'**
  String get labelWheelchairRamp;

  /// No description provided for @labelEarthworksBatter.
  ///
  /// In en, this message translates to:
  /// **'Earthworks Batter'**
  String get labelEarthworksBatter;

  /// No description provided for @labelClearance.
  ///
  /// In en, this message translates to:
  /// **'Clearance'**
  String get labelClearance;

  /// No description provided for @labelSwellFactor.
  ///
  /// In en, this message translates to:
  /// **'Swell Factor'**
  String get labelSwellFactor;

  /// No description provided for @labelDryMortarVolume.
  ///
  /// In en, this message translates to:
  /// **'Dry Mortar Volume'**
  String get labelDryMortarVolume;

  /// No description provided for @labelEngineeringStandards.
  ///
  /// In en, this message translates to:
  /// **'Engineering Standards'**
  String get labelEngineeringStandards;

  /// No description provided for @labelLegalAndAbout.
  ///
  /// In en, this message translates to:
  /// **'Legal & About'**
  String get labelLegalAndAbout;

  /// No description provided for @labelQuantityTools.
  ///
  /// In en, this message translates to:
  /// **'Quantity Tools'**
  String get labelQuantityTools;

  /// No description provided for @labelFieldSurveying.
  ///
  /// In en, this message translates to:
  /// **'Field Surveying'**
  String get labelFieldSurveying;

  /// No description provided for @labelPitDimensions.
  ///
  /// In en, this message translates to:
  /// **'Pit Dimensions'**
  String get labelPitDimensions;

  /// No description provided for @labelTotalVolumeLoose.
  ///
  /// In en, this message translates to:
  /// **'Total Volume (Loose)'**
  String get labelTotalVolumeLoose;

  /// No description provided for @labelBankVolumeNatural.
  ///
  /// In en, this message translates to:
  /// **'Bank Volume (Natural)'**
  String get labelBankVolumeNatural;

  /// No description provided for @labelOtherTools.
  ///
  /// In en, this message translates to:
  /// **'Other Tools'**
  String get labelOtherTools;

  /// No description provided for @labelMasonry.
  ///
  /// In en, this message translates to:
  /// **'Masonry'**
  String get labelMasonry;

  /// No description provided for @labelBrickSize.
  ///
  /// In en, this message translates to:
  /// **'Brick Size'**
  String get labelBrickSize;

  /// No description provided for @labelBricks.
  ///
  /// In en, this message translates to:
  /// **'Bricks'**
  String get labelBricks;

  /// No description provided for @labelBrickVolume.
  ///
  /// In en, this message translates to:
  /// **'Brick Vol'**
  String get labelBrickVolume;

  /// No description provided for @labelCement.
  ///
  /// In en, this message translates to:
  /// **'Cement'**
  String get labelCement;

  /// No description provided for @labelSand.
  ///
  /// In en, this message translates to:
  /// **'Sand'**
  String get labelSand;

  /// No description provided for @labelTotalVolume.
  ///
  /// In en, this message translates to:
  /// **'Total Vol'**
  String get labelTotalVolume;

  /// No description provided for @labelStep1Geometry.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Geometry'**
  String get labelStep1Geometry;

  /// No description provided for @labelStep3Analysis.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Analysis'**
  String get labelStep3Analysis;

  /// No description provided for @labelStep4Reinforcement.
  ///
  /// In en, this message translates to:
  /// **'Step 4 of 5: Steel Detailing'**
  String get labelStep4Reinforcement;

  /// No description provided for @labelStep5Safety.
  ///
  /// In en, this message translates to:
  /// **'Step 5: Safety Check'**
  String get labelStep5Safety;

  /// No description provided for @labelSpanL.
  ///
  /// In en, this message translates to:
  /// **'Span (L) (mm)'**
  String get labelSpanL;

  /// No description provided for @labelWidthB.
  ///
  /// In en, this message translates to:
  /// **'Width (b) (mm)'**
  String get labelWidthB;

  /// No description provided for @labelDepthD.
  ///
  /// In en, this message translates to:
  /// **'Overall Depth (D) (mm)'**
  String get labelDepthD;

  /// No description provided for @labelCover.
  ///
  /// In en, this message translates to:
  /// **'Clear Cover (mm)'**
  String get labelCover;

  /// No description provided for @labelVerticalLoads.
  ///
  /// In en, this message translates to:
  /// **'Vertical Loads'**
  String get labelVerticalLoads;

  /// No description provided for @labelDeadLoad.
  ///
  /// In en, this message translates to:
  /// **'Dead Load (kN/m)'**
  String get labelDeadLoad;

  /// No description provided for @labelLiveLoad.
  ///
  /// In en, this message translates to:
  /// **'Live Load (kN/m)'**
  String get labelLiveLoad;

  /// No description provided for @labelPointLoad.
  ///
  /// In en, this message translates to:
  /// **'Point Load (kN)'**
  String get labelPointLoad;

  /// No description provided for @labelLimitState.
  ///
  /// In en, this message translates to:
  /// **'Limit State'**
  String get labelLimitState;

  /// No description provided for @labelULS.
  ///
  /// In en, this message translates to:
  /// **'ULS (Factored)'**
  String get labelULS;

  /// No description provided for @labelSLS.
  ///
  /// In en, this message translates to:
  /// **'SLS (Service)'**
  String get labelSLS;

  /// No description provided for @labelGeometry.
  ///
  /// In en, this message translates to:
  /// **'Geometry'**
  String get labelGeometry;

  /// No description provided for @labelMaterials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get labelMaterials;

  /// No description provided for @labelType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get labelType;

  /// No description provided for @labelSectionProperties.
  ///
  /// In en, this message translates to:
  /// **'Section Properties'**
  String get labelSectionProperties;

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @labelPrincipalForces.
  ///
  /// In en, this message translates to:
  /// **'Principal Forces'**
  String get labelPrincipalForces;

  /// No description provided for @labelULSForces.
  ///
  /// In en, this message translates to:
  /// **'ULS Forces'**
  String get labelULSForces;

  /// No description provided for @labelMomentMu.
  ///
  /// In en, this message translates to:
  /// **'Moment (Mu)'**
  String get labelMomentMu;

  /// No description provided for @labelShearVu.
  ///
  /// In en, this message translates to:
  /// **'Design Shear (Vu)'**
  String get labelShearVu;

  /// No description provided for @labelTotalLoadWu.
  ///
  /// In en, this message translates to:
  /// **'Total Load (wu)'**
  String get labelTotalLoadWu;

  /// No description provided for @labelDiagrams.
  ///
  /// In en, this message translates to:
  /// **'Engineering Diagrams'**
  String get labelDiagrams;

  /// No description provided for @labelReinforcementSummary.
  ///
  /// In en, this message translates to:
  /// **'Reinforcement Summary'**
  String get labelReinforcementSummary;

  /// No description provided for @labelMainTensionRebar.
  ///
  /// In en, this message translates to:
  /// **'Main Tension Rebar'**
  String get labelMainTensionRebar;

  /// No description provided for @labelShearLinkRebar.
  ///
  /// In en, this message translates to:
  /// **'Shear Stirrups'**
  String get labelShearLinkRebar;

  /// No description provided for @labelAreaRequired.
  ///
  /// In en, this message translates to:
  /// **'Area Required'**
  String get labelAreaRequired;

  /// No description provided for @labelAreaProvided.
  ///
  /// In en, this message translates to:
  /// **'Area Provided'**
  String get labelAreaProvided;

  /// No description provided for @labelBarDiameter.
  ///
  /// In en, this message translates to:
  /// **'Diameter'**
  String get labelBarDiameter;

  /// No description provided for @labelBarCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get labelBarCount;

  /// No description provided for @labelSafetySummary.
  ///
  /// In en, this message translates to:
  /// **'Safety Summary'**
  String get labelSafetySummary;

  /// No description provided for @labelLimitStateCheck.
  ///
  /// In en, this message translates to:
  /// **'Limit State Checks'**
  String get labelLimitStateCheck;

  /// No description provided for @labelDeflectionCheck.
  ///
  /// In en, this message translates to:
  /// **'Deflection Control'**
  String get labelDeflectionCheck;

  /// No description provided for @labelCrackingCheck.
  ///
  /// In en, this message translates to:
  /// **'Cracking Control'**
  String get labelCrackingCheck;

  /// No description provided for @labelDevelopmentLength.
  ///
  /// In en, this message translates to:
  /// **'Development Length'**
  String get labelDevelopmentLength;

  /// No description provided for @labelCrossSection.
  ///
  /// In en, this message translates to:
  /// **'Cross-Section'**
  String get labelCrossSection;

  /// No description provided for @labelInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get labelInsights;

  /// No description provided for @labelSteelSpecs.
  ///
  /// In en, this message translates to:
  /// **'Steel Specs'**
  String get labelSteelSpecs;

  /// No description provided for @labelFlexure.
  ///
  /// In en, this message translates to:
  /// **'Flexure'**
  String get labelFlexure;

  /// No description provided for @labelOptimization.
  ///
  /// In en, this message translates to:
  /// **'Optimization'**
  String get labelOptimization;

  /// No description provided for @labelVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get labelVerification;

  /// No description provided for @labelAstRequired.
  ///
  /// In en, this message translates to:
  /// **'Ast Req'**
  String get labelAstRequired;

  /// No description provided for @labelAstProvided.
  ///
  /// In en, this message translates to:
  /// **'Ast Prov'**
  String get labelAstProvided;

  /// No description provided for @actionSaveDrawing.
  ///
  /// In en, this message translates to:
  /// **'Save Drawing'**
  String get actionSaveDrawing;

  /// No description provided for @titleSlab.
  ///
  /// In en, this message translates to:
  /// **'Slab'**
  String get titleSlab;

  /// No description provided for @labelThicknessD.
  ///
  /// In en, this message translates to:
  /// **'Thickness (D) (mm)'**
  String get labelThicknessD;

  /// No description provided for @labelConcrete.
  ///
  /// In en, this message translates to:
  /// **'Concrete'**
  String get labelConcrete;

  /// No description provided for @labelFloorFinish.
  ///
  /// In en, this message translates to:
  /// **'Floor Finish (kN/m²)'**
  String get labelFloorFinish;

  /// No description provided for @labelPartition.
  ///
  /// In en, this message translates to:
  /// **'Partition (kN/m²)'**
  String get labelPartition;

  /// No description provided for @labelOneWay.
  ///
  /// In en, this message translates to:
  /// **'One-Way'**
  String get labelOneWay;

  /// No description provided for @labelTwoWay.
  ///
  /// In en, this message translates to:
  /// **'Two-Way'**
  String get labelTwoWay;

  /// No description provided for @labelCantilever.
  ///
  /// In en, this message translates to:
  /// **'Cantilever'**
  String get labelCantilever;

  /// No description provided for @labelLoadsUnit.
  ///
  /// In en, this message translates to:
  /// **'Loads (kN/m²)'**
  String get labelLoadsUnit;

  /// No description provided for @labelFactorApplied.
  ///
  /// In en, this message translates to:
  /// **'Factor: 1.5 applied.'**
  String get labelFactorApplied;

  /// No description provided for @labelPrincipalMoments.
  ///
  /// In en, this message translates to:
  /// **'Principal Moments'**
  String get labelPrincipalMoments;

  /// No description provided for @labelMx.
  ///
  /// In en, this message translates to:
  /// **'Mx (kN-m/m)'**
  String get labelMx;

  /// No description provided for @labelMy.
  ///
  /// In en, this message translates to:
  /// **'My (kN-m/m)'**
  String get labelMy;

  /// No description provided for @labelMux.
  ///
  /// In en, this message translates to:
  /// **'Factored Mux'**
  String get labelMux;

  /// No description provided for @labelMuy.
  ///
  /// In en, this message translates to:
  /// **'Factored Muy'**
  String get labelMuy;

  /// No description provided for @labelAstX.
  ///
  /// In en, this message translates to:
  /// **'Ast X-direction'**
  String get labelAstX;

  /// No description provided for @labelAstY.
  ///
  /// In en, this message translates to:
  /// **'Ast Y-direction'**
  String get labelAstY;

  /// No description provided for @labelSpacingX.
  ///
  /// In en, this message translates to:
  /// **'Spacing X'**
  String get labelSpacingX;

  /// No description provided for @labelResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get labelResults;

  /// No description provided for @labelDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get labelDetails;

  /// No description provided for @labelSpacingY.
  ///
  /// In en, this message translates to:
  /// **'Spacing Y'**
  String get labelSpacingY;

  /// No description provided for @labelTotalLoad.
  ///
  /// In en, this message translates to:
  /// **'Total Load'**
  String get labelTotalLoad;

  /// No description provided for @labelSlabMomentInsight.
  ///
  /// In en, this message translates to:
  /// **'Maximum moment occurs at the midspan for a simply supported slab.'**
  String get labelSlabMomentInsight;

  /// No description provided for @labelSteelAreaCheck.
  ///
  /// In en, this message translates to:
  /// **'Steel Area Check'**
  String get labelSteelAreaCheck;

  /// No description provided for @labelRequiredAstUnit.
  ///
  /// In en, this message translates to:
  /// **'Required Ast (mm²/m)'**
  String get labelRequiredAstUnit;

  /// No description provided for @labelProvidedAstUnit.
  ///
  /// In en, this message translates to:
  /// **'Provided Ast (mm²)'**
  String get labelProvidedAstUnit;

  /// No description provided for @labelPracticalDetailing.
  ///
  /// In en, this message translates to:
  /// **'Practical Detailing'**
  String get labelPracticalDetailing;

  /// No description provided for @labelLayoutStrategy.
  ///
  /// In en, this message translates to:
  /// **'Layout Strategy'**
  String get labelLayoutStrategy;

  /// No description provided for @labelDetailingRules.
  ///
  /// In en, this message translates to:
  /// **'Detailing Rules'**
  String get labelDetailingRules;

  /// No description provided for @labelSlabDetailingInsight.
  ///
  /// In en, this message translates to:
  /// **'Rebar spacing should not exceed 3d or 300mm for main rebar.'**
  String get labelSlabDetailingInsight;

  /// No description provided for @labelStepValidation.
  ///
  /// In en, this message translates to:
  /// **'Step: Validation'**
  String get labelStepValidation;

  /// No description provided for @labelCriticalSafetyStatus.
  ///
  /// In en, this message translates to:
  /// **'Critical Safety Status'**
  String get labelCriticalSafetyStatus;

  /// No description provided for @labelSafeCaps.
  ///
  /// In en, this message translates to:
  /// **'SAFE'**
  String get labelSafeCaps;

  /// No description provided for @labelActionRequired.
  ///
  /// In en, this message translates to:
  /// **'ACTION REQUIRED'**
  String get labelActionRequired;

  /// No description provided for @labelPass.
  ///
  /// In en, this message translates to:
  /// **'PASS'**
  String get labelPass;

  /// No description provided for @labelOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get labelOk;

  /// No description provided for @labelDesignAdvisorService.
  ///
  /// In en, this message translates to:
  /// **'Design Advisor'**
  String get labelDesignAdvisorService;

  /// No description provided for @labelShareReport.
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get labelShareReport;

  /// No description provided for @snackbarSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Please select an option first'**
  String get snackbarSelectOption;

  /// No description provided for @snackbarGeneratingReport.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF Report...'**
  String get snackbarGeneratingReport;

  /// No description provided for @titleSlenderness.
  ///
  /// In en, this message translates to:
  /// **'Slenderness'**
  String get titleSlenderness;

  /// No description provided for @titleDesignCalculation.
  ///
  /// In en, this message translates to:
  /// **'Design Calculation'**
  String get titleDesignCalculation;

  /// No description provided for @labelStep3Stability.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Stability'**
  String get labelStep3Stability;

  /// No description provided for @labelStep4StructuralDesign.
  ///
  /// In en, this message translates to:
  /// **'Step 4 of 6: Structural Design'**
  String get labelStep4StructuralDesign;

  /// No description provided for @labelStep5Detailing.
  ///
  /// In en, this message translates to:
  /// **'Step 5: Detailing'**
  String get labelStep5Detailing;

  /// No description provided for @labelStep6Validation.
  ///
  /// In en, this message translates to:
  /// **'Step 6: Validation'**
  String get labelStep6Validation;

  /// No description provided for @labelDiaUnit.
  ///
  /// In en, this message translates to:
  /// **'Dia (mm)'**
  String get labelDiaUnit;

  /// No description provided for @labelDepthDUnit.
  ///
  /// In en, this message translates to:
  /// **'Depth (D) (mm)'**
  String get labelDepthDUnit;

  /// No description provided for @labelEndCondition.
  ///
  /// In en, this message translates to:
  /// **'End Condition'**
  String get labelEndCondition;

  /// No description provided for @labelEndSupportCondition.
  ///
  /// In en, this message translates to:
  /// **'End Support Condition'**
  String get labelEndSupportCondition;

  /// No description provided for @labelCoverUnit.
  ///
  /// In en, this message translates to:
  /// **'Cover (mm)'**
  String get labelCoverUnit;

  /// No description provided for @labelAxialLoadPuUnit.
  ///
  /// In en, this message translates to:
  /// **'Axial Load (Pu) (kN)'**
  String get labelAxialLoadPuUnit;

  /// No description provided for @labelShortColumn.
  ///
  /// In en, this message translates to:
  /// **'SHORT'**
  String get labelShortColumn;

  /// No description provided for @labelSlenderColumn.
  ///
  /// In en, this message translates to:
  /// **'SLENDER'**
  String get labelSlenderColumn;

  /// No description provided for @labelRule.
  ///
  /// In en, this message translates to:
  /// **'Rule'**
  String get labelRule;

  /// No description provided for @labelEffectiveLength.
  ///
  /// In en, this message translates to:
  /// **'Effective Length'**
  String get labelEffectiveLength;

  /// No description provided for @labelLexMajor.
  ///
  /// In en, this message translates to:
  /// **'lex (Major)'**
  String get labelLexMajor;

  /// No description provided for @labelLeyMinor.
  ///
  /// In en, this message translates to:
  /// **'ley (Minor)'**
  String get labelLeyMinor;

  /// No description provided for @labelUnsupportedLengthLUnit.
  ///
  /// In en, this message translates to:
  /// **'Unsupported Length (L) (mm)'**
  String get labelUnsupportedLengthLUnit;

  /// No description provided for @labelTargetSteelPercentUnit.
  ///
  /// In en, this message translates to:
  /// **'Target Steel %'**
  String get labelTargetSteelPercentUnit;

  /// No description provided for @labelGrossAreaAgUnit.
  ///
  /// In en, this message translates to:
  /// **'Gross Area (Ag) (mm²)'**
  String get labelGrossAreaAgUnit;

  /// No description provided for @labelDesignConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Design Configuration'**
  String get labelDesignConfiguration;

  /// No description provided for @labelDesignMethod.
  ///
  /// In en, this message translates to:
  /// **'Design Method'**
  String get labelDesignMethod;

  /// No description provided for @labelAutoCalculateSteel.
  ///
  /// In en, this message translates to:
  /// **'Auto-calculate Steel %'**
  String get labelAutoCalculateSteel;

  /// No description provided for @labelAutoSteelDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically find minimum steel'**
  String get labelAutoSteelDescription;

  /// No description provided for @labelManualSteelUnit.
  ///
  /// In en, this message translates to:
  /// **'Manual Steel (%)'**
  String get labelManualSteelUnit;

  /// No description provided for @labelReinforcementRequirement.
  ///
  /// In en, this message translates to:
  /// **'Reinforcement Requirement'**
  String get labelReinforcementRequirement;

  /// No description provided for @labelRequiredSteelAreaAscUnit.
  ///
  /// In en, this message translates to:
  /// **'Required Steel Area (Asc) (mm²)'**
  String get labelRequiredSteelAreaAscUnit;

  /// No description provided for @labelMainBars.
  ///
  /// In en, this message translates to:
  /// **'Main Bars'**
  String get labelMainBars;

  /// No description provided for @labelBarDia.
  ///
  /// In en, this message translates to:
  /// **'Bar Dia'**
  String get labelBarDia;

  /// No description provided for @labelNumberOfBars.
  ///
  /// In en, this message translates to:
  /// **'Number of Bars'**
  String get labelNumberOfBars;

  /// No description provided for @labelAstRequiredUnit.
  ///
  /// In en, this message translates to:
  /// **'Ast Req (mm²)'**
  String get labelAstRequiredUnit;

  /// No description provided for @labelAstProvidedUnit.
  ///
  /// In en, this message translates to:
  /// **'Ast Prov (mm²)'**
  String get labelAstProvidedUnit;

  /// No description provided for @labelLateralTies.
  ///
  /// In en, this message translates to:
  /// **'Lateral Ties'**
  String get labelLateralTies;

  /// No description provided for @labelTieDiaMinUnit.
  ///
  /// In en, this message translates to:
  /// **'Tie Dia (min) (mm)'**
  String get labelTieDiaMinUnit;

  /// No description provided for @labelSpacingSUnit.
  ///
  /// In en, this message translates to:
  /// **'Spacing (s) (mm c/c)'**
  String get labelSpacingSUnit;

  /// No description provided for @actionOptimize.
  ///
  /// In en, this message translates to:
  /// **'Optimize'**
  String get actionOptimize;

  /// No description provided for @labelColumnReinforcement.
  ///
  /// In en, this message translates to:
  /// **'Column Reinforcement'**
  String get labelColumnReinforcement;

  /// No description provided for @labelVisualization.
  ///
  /// In en, this message translates to:
  /// **'Visualization'**
  String get labelVisualization;

  /// No description provided for @labelCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get labelCapacity;

  /// No description provided for @labelDemandVsCapacity.
  ///
  /// In en, this message translates to:
  /// **'Demand vs Capacity'**
  String get labelDemandVsCapacity;

  /// No description provided for @labelInteractionRatio.
  ///
  /// In en, this message translates to:
  /// **'Interaction Ratio'**
  String get labelInteractionRatio;

  /// No description provided for @labelDemandCapacity.
  ///
  /// In en, this message translates to:
  /// **'Demand / Capacity'**
  String get labelDemandCapacity;

  /// No description provided for @labelFailureMode.
  ///
  /// In en, this message translates to:
  /// **'Failure Mode'**
  String get labelFailureMode;

  /// No description provided for @labelStability.
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get labelStability;

  /// No description provided for @labelSteelPercentage.
  ///
  /// In en, this message translates to:
  /// **'Steel Percentage'**
  String get labelSteelPercentage;

  /// No description provided for @labelSteelRange.
  ///
  /// In en, this message translates to:
  /// **'Range: 0.8% - 6.0%'**
  String get labelSteelRange;

  /// No description provided for @labelMagnifiedMoment.
  ///
  /// In en, this message translates to:
  /// **'Magnified Moment'**
  String get labelMagnifiedMoment;

  /// No description provided for @labelDrawing.
  ///
  /// In en, this message translates to:
  /// **'Drawing'**
  String get labelDrawing;

  /// No description provided for @actionNextSoilLoad.
  ///
  /// In en, this message translates to:
  /// **'Next: Soil & Load'**
  String get actionNextSoilLoad;

  /// No description provided for @labelStep1FoundationType.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 6: Foundation Type'**
  String get labelStep1FoundationType;

  /// No description provided for @labelSelectFoundationType.
  ///
  /// In en, this message translates to:
  /// **'Select Foundation Type'**
  String get labelSelectFoundationType;

  /// No description provided for @labelColumn1Loadings.
  ///
  /// In en, this message translates to:
  /// **'Column 1 Loadings'**
  String get labelColumn1Loadings;

  /// No description provided for @labelColumnLoading.
  ///
  /// In en, this message translates to:
  /// **'Column Loading'**
  String get labelColumnLoading;

  /// No description provided for @labelColumn2Loadings.
  ///
  /// In en, this message translates to:
  /// **'Column 2 Loadings'**
  String get labelColumn2Loadings;

  /// No description provided for @labelSoilProperties.
  ///
  /// In en, this message translates to:
  /// **'Soil Properties'**
  String get labelSoilProperties;

  /// No description provided for @labelSBCUnit.
  ///
  /// In en, this message translates to:
  /// **'Bearing Capacity (kN/m²)'**
  String get labelSBCUnit;

  /// No description provided for @labelDepthUnit.
  ///
  /// In en, this message translates to:
  /// **'Depth (m)'**
  String get labelDepthUnit;

  /// No description provided for @labelFootingColumnCriticalInsight.
  ///
  /// In en, this message translates to:
  /// **'Critical for shear and bending calculations at face.'**
  String get labelFootingColumnCriticalInsight;

  /// No description provided for @labelFootingAreaInsight.
  ///
  /// In en, this message translates to:
  /// **'For {type}, ensure dimensions capture the full required bearing area of {area} m².'**
  String labelFootingAreaInsight(Object area, Object type);

  /// No description provided for @labelAreaReqUnit.
  ///
  /// In en, this message translates to:
  /// **'Area Req (m²)'**
  String get labelAreaReqUnit;

  /// No description provided for @labelAreaReqNote.
  ///
  /// In en, this message translates to:
  /// **'Includes 10% self-weight'**
  String get labelAreaReqNote;

  /// No description provided for @labelAreaProvUnit.
  ///
  /// In en, this message translates to:
  /// **'Area Prov (m²)'**
  String get labelAreaProvUnit;

  /// No description provided for @labelMaxPressureUnit.
  ///
  /// In en, this message translates to:
  /// **'Max Pressure (kN/m²)'**
  String get labelMaxPressureUnit;

  /// No description provided for @labelMinPressureUnit.
  ///
  /// In en, this message translates to:
  /// **'Min Pressure (kN/m²)'**
  String get labelMinPressureUnit;

  /// No description provided for @labelAllowableUnit.
  ///
  /// In en, this message translates to:
  /// **'Allowable (kN/m²)'**
  String get labelAllowableUnit;

  /// No description provided for @labelEccentricityExUnit.
  ///
  /// In en, this message translates to:
  /// **'Eccentricity (ex) (mm)'**
  String get labelEccentricityExUnit;

  /// No description provided for @labelStep5SteelDetailing.
  ///
  /// In en, this message translates to:
  /// **'Step 5 of 6: Steel Detailing'**
  String get labelStep5SteelDetailing;

  /// No description provided for @labelMinRequiredAstUnit.
  ///
  /// In en, this message translates to:
  /// **'Min. Required Ast (mm²)'**
  String get labelMinRequiredAstUnit;

  /// No description provided for @labelFootingBendingMomentInsight.
  ///
  /// In en, this message translates to:
  /// **'Based on Bending Moment analysis'**
  String get labelFootingBendingMomentInsight;

  /// No description provided for @actionSavePdfDrawing.
  ///
  /// In en, this message translates to:
  /// **'Save PDF'**
  String get actionSavePdfDrawing;

  /// No description provided for @labelStep6DesignValidation.
  ///
  /// In en, this message translates to:
  /// **'Step 6 of 6: Design Validation'**
  String get labelStep6DesignValidation;

  /// No description provided for @labelDesignIsSafe.
  ///
  /// In en, this message translates to:
  /// **'DESIGN IS SAFE'**
  String get labelDesignIsSafe;

  /// No description provided for @labelMaxPressureQMaxUnit.
  ///
  /// In en, this message translates to:
  /// **'Max Pressure (q_max) (kN/m²)'**
  String get labelMaxPressureQMaxUnit;

  /// No description provided for @labelAllowableSBCUnit.
  ///
  /// In en, this message translates to:
  /// **'Allowable SBC (kN/m²)'**
  String get labelAllowableSBCUnit;

  /// No description provided for @labelOneWayShearTauVUnit.
  ///
  /// In en, this message translates to:
  /// **'One-Way Shear (τv) (N/mm²)'**
  String get labelOneWayShearTauVUnit;

  /// No description provided for @labelLimitTauCUnit.
  ///
  /// In en, this message translates to:
  /// **'Limit τc: {limit} N/mm²'**
  String labelLimitTauCUnit(Object limit);

  /// No description provided for @labelPunchingShearVuUnit.
  ///
  /// In en, this message translates to:
  /// **'Punching Shear (Vu) (kN)'**
  String get labelPunchingShearVuUnit;

  /// No description provided for @labelEffectiveDepthUnit.
  ///
  /// In en, this message translates to:
  /// **'Effective Depth: {depth} mm'**
  String labelEffectiveDepthUnit(Object depth);

  /// No description provided for @labelLowSBCWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: Low SBC detected. Consider detailed settlement analysis.'**
  String get labelLowSBCWarning;

  /// No description provided for @hintAiInput.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10x5m slab M20...'**
  String get hintAiInput;

  /// No description provided for @hintLength.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5.0'**
  String get hintLength;

  /// No description provided for @hintWidth.
  ///
  /// In en, this message translates to:
  /// **'e.g. 0.3'**
  String get hintWidth;

  /// No description provided for @hintDepth.
  ///
  /// In en, this message translates to:
  /// **'e.g. 0.6'**
  String get hintDepth;

  /// No description provided for @hintSpacing.
  ///
  /// In en, this message translates to:
  /// **'e.g. 0.15'**
  String get hintSpacing;

  /// No description provided for @hintDiameter.
  ///
  /// In en, this message translates to:
  /// **'e.g. 12'**
  String get hintDiameter;

  /// No description provided for @hintArea.
  ///
  /// In en, this message translates to:
  /// **'e.g. 50'**
  String get hintArea;

  /// No description provided for @hintPitLength.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2.0'**
  String get hintPitLength;

  /// No description provided for @hintSteelRatio.
  ///
  /// In en, this message translates to:
  /// **'1%'**
  String get hintSteelRatio;

  /// No description provided for @hintWastage.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5 - 10'**
  String get hintWastage;

  /// No description provided for @hintPitDepth.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1.5'**
  String get hintPitDepth;

  /// No description provided for @hintSwellFactor.
  ///
  /// In en, this message translates to:
  /// **'1.25'**
  String get hintSwellFactor;

  /// No description provided for @hintWasteFactor.
  ///
  /// In en, this message translates to:
  /// **'5%'**
  String get hintWasteFactor;

  /// No description provided for @msgReadyToBuild.
  ///
  /// In en, this message translates to:
  /// **'Ready to Build'**
  String get msgReadyToBuild;

  /// No description provided for @msgAiSuggestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get intelligent recommendations during structural design calculations.'**
  String get msgAiSuggestionsDesc;

  /// No description provided for @msgClearCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'Removes temporary files to free space'**
  String get msgClearCacheDesc;

  /// No description provided for @msgResetAppDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Restores all settings to defaults'**
  String get msgResetAppDataDesc;

  /// No description provided for @msgUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get msgUpToDate;

  /// No description provided for @msgDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String msgDaysAgo(int count);

  /// No description provided for @msgAiAssistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask site questions or get instant material calculations.'**
  String get msgAiAssistantSubtitle;

  /// No description provided for @msgNoReadingsYet.
  ///
  /// In en, this message translates to:
  /// **'No readings yet. Add first point above.'**
  String get msgNoReadingsYet;

  /// No description provided for @msgNoLevelingLogs.
  ///
  /// In en, this message translates to:
  /// **'No Leveling Logs Yet'**
  String get msgNoLevelingLogs;

  /// No description provided for @msgTapAddStation.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Add Station\' to start tracking.'**
  String get msgTapAddStation;

  /// No description provided for @msgTypicalThickness.
  ///
  /// In en, this message translates to:
  /// **'Typical: 12 mm internal · 15 mm external · 6 mm ceiling'**
  String get msgTypicalThickness;

  /// No description provided for @msgCalculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get msgCalculating;

  /// No description provided for @msgCementRatioInfo.
  ///
  /// In en, this message translates to:
  /// **'Proportion of cement in the mix (by volume).'**
  String get msgCementRatioInfo;

  /// No description provided for @valSewerPipesRef.
  ///
  /// In en, this message translates to:
  /// **'1 : 60 - 1 : 100'**
  String get valSewerPipesRef;

  /// No description provided for @valRoadCrossFallRef.
  ///
  /// In en, this message translates to:
  /// **'1 : 40 (2.5%)'**
  String get valRoadCrossFallRef;

  /// No description provided for @valWheelchairRampRef.
  ///
  /// In en, this message translates to:
  /// **'1 : 12 (8.3%)'**
  String get valWheelchairRampRef;

  /// No description provided for @valEarthworksBatterRef.
  ///
  /// In en, this message translates to:
  /// **'1 : 1.5 - 1 : 2'**
  String get valEarthworksBatterRef;

  /// No description provided for @msgSandRatioInfo.
  ///
  /// In en, this message translates to:
  /// **'Proportion of sand in the mix (by volume).'**
  String get msgSandRatioInfo;

  /// No description provided for @msgAggregateRatioInfo.
  ///
  /// In en, this message translates to:
  /// **'Proportion of aggregate (stone) in the mix.'**
  String get msgAggregateRatioInfo;

  /// No description provided for @msgWastageInfo.
  ///
  /// In en, this message translates to:
  /// **'Recommended: 5% for concrete · 10% for masonry.'**
  String get msgWastageInfo;

  /// No description provided for @readyToBuild.
  ///
  /// In en, this message translates to:
  /// **'Ready to build?'**
  String get readyToBuild;

  /// No description provided for @smartAssistant.
  ///
  /// In en, this message translates to:
  /// **'Smart Assistant'**
  String get smartAssistant;

  /// No description provided for @aiHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask anything about your project or engineering standards.'**
  String get aiHeroSubtitle;

  /// No description provided for @aiInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type your engineering query...'**
  String get aiInputHint;

  /// No description provided for @msgClearanceInfo.
  ///
  /// In en, this message translates to:
  /// **'Clearance space around the pit for work accessibility.'**
  String get msgClearanceInfo;

  /// No description provided for @msgSwellFactorInfo.
  ///
  /// In en, this message translates to:
  /// **'Ratio of bank volume to loose volume. Typical values: 1.1 - 1.3.'**
  String get msgSwellFactorInfo;

  /// No description provided for @msgPlasterThicknessNote.
  ///
  /// In en, this message translates to:
  /// **'Typical thickness: Internal (12mm) · External (15-20mm) · Ceiling (6mm).'**
  String get msgPlasterThicknessNote;

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
  /// **'No leveling logs yet'**
  String get noLevelingLogsYet;

  /// No description provided for @tapAddStationToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Add Station\' to start'**
  String get tapAddStationToStart;

  /// No description provided for @calculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get calculationMethod;

  /// No description provided for @hiMethod.
  ///
  /// In en, this message translates to:
  /// **'HI Method'**
  String get hiMethod;

  /// No description provided for @riseFall.
  ///
  /// In en, this message translates to:
  /// **'Rise/Fall'**
  String get riseFall;

  /// No description provided for @bs.
  ///
  /// In en, this message translates to:
  /// **'B.S.'**
  String get bs;

  /// No description provided for @isReading.
  ///
  /// In en, this message translates to:
  /// **'I.S.'**
  String get isReading;

  /// No description provided for @fs.
  ///
  /// In en, this message translates to:
  /// **'F.S.'**
  String get fs;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'H.I.'**
  String get hi;

  /// No description provided for @rl.
  ///
  /// In en, this message translates to:
  /// **'R.L.'**
  String get rl;

  /// No description provided for @msgShutteringNote.
  ///
  /// In en, this message translates to:
  /// **'Calculation assumes rectangular formwork. Area includes sides and optional bottom.'**
  String get msgShutteringNote;

  /// No description provided for @msgIsCodeNote.
  ///
  /// In en, this message translates to:
  /// **'Calculations use standard volume-proportioning method.\nDry mortar factor: 1.30 · Cement density: 1440 kg/m³ (IS 456:2000).\nCement bag weight: 50 kg.'**
  String get msgIsCodeNote;

  /// No description provided for @msgDesignSaved.
  ///
  /// In en, this message translates to:
  /// **'Design saved to history'**
  String get msgDesignSaved;

  /// No description provided for @msgCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard!'**
  String get msgCopiedToClipboard;

  /// No description provided for @msgResetSettingsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This will revert all your preferences (Theme, Units, Language) to default. This action cannot be undone.'**
  String get msgResetSettingsDisclaimer;

  /// No description provided for @msgStandardBrickSize.
  ///
  /// In en, this message translates to:
  /// **'190 × 90 × 90 mm  (IS modular standard)'**
  String get msgStandardBrickSize;

  /// No description provided for @msgBrickWithJoint.
  ///
  /// In en, this message translates to:
  /// **'With 10 mm mortar joint: 200 × 100 × 100 mm'**
  String get msgBrickWithJoint;

  /// No description provided for @msgBrickStandardRef.
  ///
  /// In en, this message translates to:
  /// **'IS 2212:1991 standard brick dimensions'**
  String get msgBrickStandardRef;

  /// No description provided for @msgBrickInfo.
  ///
  /// In en, this message translates to:
  /// **'IS modular brick: 190×90×90 mm (without joint).\nCustom brick sizes coming soon.'**
  String get msgBrickInfo;

  /// No description provided for @msgBrickMasonryRef.
  ///
  /// In en, this message translates to:
  /// **'Calculations per IS 2212:1991 (Brick masonry code of practice).\nIS modular brick: 190 × 90 × 90 mm · Joint: 10 mm · Wastage: 5%.\nMortar dry volume factor: 1.30 · Cement density: 1440 kg/m³.'**
  String get msgBrickMasonryRef;

  /// No description provided for @msgIsCodeNoteSlenderness.
  ///
  /// In en, this message translates to:
  /// **'Based on IS 456 Cl 39.7.1'**
  String get msgIsCodeNoteSlenderness;

  /// No description provided for @msgSignificantOverStress.
  ///
  /// In en, this message translates to:
  /// **'Significant over-stress detected. Increase column cross-section dimensions.'**
  String get msgSignificantOverStress;

  /// No description provided for @msgMinorOverStress.
  ///
  /// In en, this message translates to:
  /// **'Minor over-stress. Try increasing Concrete Grade (e.g., M30 to M35) or Steel %.'**
  String get msgMinorOverStress;

  /// No description provided for @msgColumnTooSlender.
  ///
  /// In en, this message translates to:
  /// **'Column is too slender. Increase lateral dimensions (b or D) to reduce λ.'**
  String get msgColumnTooSlender;

  /// No description provided for @msgSteelBelowMin.
  ///
  /// In en, this message translates to:
  /// **'Steel percentage is below IS 456 minimum (0.8%). Increase number of bars or diameter.'**
  String get msgSteelBelowMin;

  /// No description provided for @msgSteelHighCongestion.
  ///
  /// In en, this message translates to:
  /// **'Steel percentage is high (>4%). Consider increasing column size to reduce congestion.'**
  String get msgSteelHighCongestion;

  /// No description provided for @msgSectionOverDesigned.
  ///
  /// In en, this message translates to:
  /// **'Section is potentially over-designed. You may reduce dimensions for economy.'**
  String get msgSectionOverDesigned;

  /// No description provided for @msgCalculatorHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Precision estimating and surveying tools designed for real-world site conditions.'**
  String get msgCalculatorHeroSubtitle;

  /// No description provided for @msgQuantityToolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Specialized calculators for volume and weight.'**
  String get msgQuantityToolsSubtitle;

  /// No description provided for @msgOtherToolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick material and geometry calculations.'**
  String get msgOtherToolsSubtitle;

  /// No description provided for @errorOneReadingOnly.
  ///
  /// In en, this message translates to:
  /// **'Only one reading allowed per entry (BS / IS / FS)'**
  String get errorOneReadingOnly;

  /// No description provided for @actionResetDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset Defaults'**
  String get actionResetDefaults;

  /// No description provided for @labelError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String labelError(Object error);

  /// No description provided for @msgSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String msgSaveFailed(Object error);

  /// No description provided for @msgProjectNotFound.
  ///
  /// In en, this message translates to:
  /// **'Project not found'**
  String get msgProjectNotFound;

  /// No description provided for @msgNoRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get msgNoRecordsFound;

  /// No description provided for @msgVersionRestored.
  ///
  /// In en, this message translates to:
  /// **'{type} version restored.'**
  String msgVersionRestored(Object type);

  /// No description provided for @msgSelectOptionFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select an option first'**
  String get msgSelectOptionFirst;

  /// No description provided for @msgErrorGeneratingReport.
  ///
  /// In en, this message translates to:
  /// **'Error generating report: {error}'**
  String msgErrorGeneratingReport(Object error);

  /// No description provided for @noProjectsYet.
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get noProjectsYet;

  /// No description provided for @tapAddProjectToStart.
  ///
  /// In en, this message translates to:
  /// **'Create a project to start.'**
  String get tapAddProjectToStart;

  /// No description provided for @actionNewEntry.
  ///
  /// In en, this message translates to:
  /// **'New Entry'**
  String get actionNewEntry;

  /// No description provided for @labelPrimaryDetails.
  ///
  /// In en, this message translates to:
  /// **'Primary Details'**
  String get labelPrimaryDetails;

  /// No description provided for @labelLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get labelLocation;

  /// No description provided for @labelStakeholders.
  ///
  /// In en, this message translates to:
  /// **'Stakeholders'**
  String get labelStakeholders;

  /// No description provided for @labelClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get labelClient;

  /// No description provided for @labelStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get labelStatus;

  /// No description provided for @labelDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get labelDescription;

  /// No description provided for @brandingSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Branding'**
  String get brandingSettingsTitle;

  /// No description provided for @brandingErrorBlankFields.
  ///
  /// In en, this message translates to:
  /// **'Company and Engineer names cannot be blank.'**
  String get brandingErrorBlankFields;

  /// No description provided for @brandingSuccessUpdate.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get brandingSuccessUpdate;

  /// No description provided for @brandingErrorUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String brandingErrorUpdate(Object error);

  /// No description provided for @brandingSuccessDefaultsRestored.
  ///
  /// In en, this message translates to:
  /// **'Defaults Restored'**
  String get brandingSuccessDefaultsRestored;

  /// No description provided for @brandingErrorSync.
  ///
  /// In en, this message translates to:
  /// **'Sync Failed: {error}'**
  String brandingErrorSync(Object error);

  /// No description provided for @brandingSuccessSync.
  ///
  /// In en, this message translates to:
  /// **'Profile Synced Successfully'**
  String get brandingSuccessSync;
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
      <String>['en', 'hi', 'ta'].contains(locale.languageCode);

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
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
