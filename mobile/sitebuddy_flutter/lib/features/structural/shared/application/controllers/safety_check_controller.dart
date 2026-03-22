import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/utils/share_helper.dart';
import 'package:site_buddy/core/providers/shared_prefs_provider.dart';

/// STATE: SafetyCheckState
class SafetyCheckState {
  final List<dynamic> history;
  final bool isLoading;

  SafetyCheckState({required this.history, this.isLoading = false});

  SafetyCheckState copyWith({List<dynamic>? history, bool? isLoading}) {
    return SafetyCheckState(
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// CONTROLLER: SafetyCheckController
/// Refactored to use Notifier (Riverpod 3.x compatible).
class SafetyCheckController extends Notifier<SafetyCheckState> {
  static const String _historyKey = 'safety_checks_history';

  @override
  SafetyCheckState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final String? data = prefs.getString(_historyKey);
    if (data != null) {
      try {
        return SafetyCheckState(history: jsonDecode(data));
      } catch (_) {
        return SafetyCheckState(history: []);
      }
    }
    return SafetyCheckState(history: []);
  }

  Future<void> saveCheck(Map<String, dynamic> checkData) async {
    final List<dynamic> updatedHistory = [checkData, ...state.history];
    if (updatedHistory.length > 10) updatedHistory.removeLast();

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_historyKey, jsonEncode(updatedHistory));
    state = state.copyWith(history: updatedHistory);
  }

  Future<void> clearHistory() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_historyKey);
    state = state.copyWith(history: []);
  }

  void shareResult({
    required String title,
    required Map<String, String> inputs,
    required Map<String, String> results,
    required bool isSafe,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('--- SITE BUDDY: $title ---');
    buffer.writeln('STATUS: ${isSafe ? "SAFE ✅" : "UNSAFE ❌"}');
    buffer.writeln('\nINPUTS:');
    inputs.forEach((k, v) => buffer.writeln('- $k: $v'));
    buffer.writeln('\nRESULTS:');
    results.forEach((k, v) => buffer.writeln('- $k: $v'));
    buffer.writeln('\nGenerated as per IS 456:2000');

    ShareHelper.shareSlabDesign(
      projectName: title,
      slabType: results['Result'] ?? 'Safety Check',
      lx: 0,
      ly: 0,
      depth: 0,
      deadLoad: 0,
      liveLoad: 0,
      totalLoad: 0,
      bendingMoment: 0,
      mainRebar: buffer.toString(),
      distributionSteel: '',
    );
  }
}

// NotifierProvider for the SafetyCheckController
final safetyCheckControllerProvider =
    NotifierProvider<SafetyCheckController, SafetyCheckState>(() {
      return SafetyCheckController();
    });



