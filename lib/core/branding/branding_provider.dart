/// FILE HEADER
/// ----------------------------------------------
/// File: branding_provider.dart
/// Feature: core/branding
/// Layer: application/providers
///
/// PURPOSE:
/// Manages the persistent, globally accessible user-level branding settings.
///
/// RESPONSIBILITIES:
/// - Initialize settings via SharedPreferences securely.
/// - Holds state defining the global Branding overrides.
/// - Notifies subscribers instantly on branding profile modifications.
/// ----------------------------------------------
library;


import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:site_buddy/core/branding/branding_model.dart';

const String _brandingPrefsKey = 'sitebuddy_global_branding';

class BrandingNotifier extends Notifier<BrandingModel> {
  @override
  BrandingModel build() {
    // Default synchronous return
    // Real initialization happens async in `_loadFromPrefs`.
    Future.microtask(() => _loadFromPrefs());
    return BrandingModel.defaultBranding();
  }

  /// Loads persisted JSON data offdisk into the active state.
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_brandingPrefsKey);

    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        state = BrandingModel.fromMap(decoded);
      } catch (e) {
        // Fallback natively to default on corruption.
        state = BrandingModel.defaultBranding();
      }
    }
  }

  /// Overwrites the running state entirely and saves immediately to disk.
  Future<void> updateBranding(BrandingModel newBranding) async {
    state = newBranding;
    final prefs = await SharedPreferences.getInstance();

    final jsonStr = jsonEncode(state.toMap());
    await prefs.setString(_brandingPrefsKey, jsonStr);
  }

  /// Merges partial updates onto the existing object cleanly.
  Future<void> updateFields({
    String? companyName,
    String? engineerName,
    String? logoPath,
    bool clearLogo = false,
  }) async {
    final updated = state.copyWith(
      companyName: companyName,
      engineerName: engineerName,
      logoPath: logoPath,
      clearLogo: clearLogo,
    );
    await updateBranding(updated);
  }

  /// Removes customization cleanly, restoring enterprise defaults.
  Future<void> resetToDefault() async {
    state = BrandingModel.defaultBranding();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_brandingPrefsKey);
  }
}

final brandingProvider = NotifierProvider<BrandingNotifier, BrandingModel>(() {
  return BrandingNotifier();
});
