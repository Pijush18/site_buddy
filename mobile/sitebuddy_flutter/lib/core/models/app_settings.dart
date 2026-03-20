import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:site_buddy/core/enums/unit_system.dart';

class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final UnitSystem unitSystem;
  final String locale;
  final bool restoreLastScreen;

  const AppSettings({
    required this.themeMode,
    required this.unitSystem,
    required this.locale,
    this.restoreLastScreen = false,
  });

  const AppSettings.initial()
    : themeMode = ThemeMode.light,
      unitSystem = UnitSystem.metric,
      locale = 'en',
      restoreLastScreen = false;

  AppSettings copyWith({
    ThemeMode? themeMode,
    UnitSystem? unitSystem,
    String? locale,
    bool? restoreLastScreen,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      unitSystem: unitSystem ?? this.unitSystem,
      locale: locale ?? this.locale,
      restoreLastScreen: restoreLastScreen ?? this.restoreLastScreen,
    );
  }

  @override
  List<Object?> get props => [themeMode, unitSystem, locale, restoreLastScreen];
}



