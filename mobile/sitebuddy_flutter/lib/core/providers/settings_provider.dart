import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:site_buddy/core/models/app_settings.dart';
import 'package:site_buddy/core/providers/shared_prefs_provider.dart';
import 'package:site_buddy/core/enums/unit_system.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends Notifier<AppSettings> {
  static const String _keyTheme = 'app_theme_mode';
  static const String _keyUnit = 'app_unit_system';
  static const String _keyLocale =
      'app_language'; // Matching LanguageService's key for migration
  static const String _keyRestoreLastScreen = 'restore_last_screen';
  static const String _keyLastRoute = 'last_visited_route';

  late SharedPreferences _prefs;

  @override
  AppSettings build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return _loadSettings();
  }

  AppSettings _loadSettings() {
    final savedTheme = _prefs.getString(_keyTheme);
    final themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    final unitIndex = _prefs.getInt(_keyUnit) ?? UnitSystem.metric.index;
    final unitSystem = UnitSystem.values[unitIndex];
    final locale = _prefs.getString(_keyLocale) ?? 'en';
    final restoreLastScreen = _prefs.getBool(_keyRestoreLastScreen) ?? false;

    return AppSettings(
      themeMode: themeMode,
      unitSystem: unitSystem,
      locale: locale,
      restoreLastScreen: restoreLastScreen,
    );
  }

  void setTheme(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _prefs.setString(_keyTheme, mode == ThemeMode.dark ? 'dark' : 'light');
  }

  void setUnitSystem(UnitSystem unit) {
    state = state.copyWith(unitSystem: unit);
    _prefs.setInt(_keyUnit, unit.index);
  }

  void setLocale(String languageCode) {
    state = state.copyWith(locale: languageCode);
    _prefs.setString(_keyLocale, languageCode);
  }

  void setRestoreLastScreen(bool value) {
    state = state.copyWith(restoreLastScreen: value);
    _prefs.setBool(_keyRestoreLastScreen, value);
  }

  String? getLastRoute() => _prefs.getString(_keyLastRoute);

  void setLastRoute(String route) {
    if (state.restoreLastScreen) {
      _prefs.setString(_keyLastRoute, route);
    }
  }
}

extension AppSettingsX on AppSettings {
  String get lengthUnit => unitSystem == UnitSystem.metric ? 'mm' : 'in';
  String get spanUnit => unitSystem == UnitSystem.metric ? 'm' : 'ft';
  String get forceUnit => unitSystem == UnitSystem.metric ? 'kN' : 'kip';
  String get stressUnit => unitSystem == UnitSystem.metric ? 'MPa' : 'ksi';
}



