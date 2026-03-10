import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PROVIDER: levelHistoryServiceProvider
final levelHistoryServiceProvider = Provider((ref) => LevelHistoryService());

/// SERVICE: LevelHistoryService
/// PURPOSE: Persists level log sessions with project association.
class LevelHistoryService {
  static const String _key = 'level_log_history';

  Future<void> saveSession({
    required String name,
    required List<Map<String, dynamic>> entries,
    required String method,
    String? projectId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    final entry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'projectId': projectId,
      'date': DateTime.now().toIso8601String(),
      'method': method,
      'entries': entries,
    };

    history.insert(0, entry);
    if (history.length > 50) history.removeLast();

    await prefs.setString(_key, jsonEncode(history));
  }

  Future<List<Map<String, dynamic>>> getHistory({String? projectId}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    try {
      List<Map<String, dynamic>> history = List<Map<String, dynamic>>.from(
        jsonDecode(raw),
      );
      if (projectId != null) {
        history = history.where((e) => e['projectId'] == projectId).toList();
      }
      return history;
    } catch (_) {
      return [];
    }
  }

  Future<void> deleteSession(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    history.removeWhere((e) => e['id'] == id);
    await prefs.setString(_key, jsonEncode(history));
  }
}
