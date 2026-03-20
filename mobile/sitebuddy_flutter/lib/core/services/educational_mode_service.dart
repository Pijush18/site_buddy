import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PROVIDER: educationalModeProvider
final educationalModeProvider =
    StateNotifierProvider<EducationalModeService, bool>((ref) {
      return EducationalModeService();
    });

/// SERVICE: EducationalModeService
/// PURPOSE: Manages the global toggle for "Educational Mode" (showing IS Code references).
class EducationalModeService extends StateNotifier<bool> {
  static const String _storageKey = 'is_educational_mode_enabled';

  EducationalModeService() : super(false) {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_storageKey) ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_storageKey, state);
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_storageKey, state);
  }
}



