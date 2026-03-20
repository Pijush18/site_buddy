import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PROVIDER: designHistoryServiceProvider
final designHistoryServiceProvider = Provider((ref) => DesignHistoryService());

/// SERVICE: DesignHistoryService
/// PURPOSE: Persists and retrieves design calculation history for all structural modes.
class DesignHistoryService {
  static const String _key = 'structural_design_history';

  Future<void> saveDesign({
    required String type, // 'column', 'beam', 'slab', 'footing'
    required String name,
    required Map<String, dynamic> data,
    String? projectId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    final entry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'name': name,
      'projectId': projectId,
      'date': DateTime.now().toIso8601String(),
      'data': data,
    };

    history.insert(0, entry);

    // Keep only last 50 designs
    if (history.length > 50) history.removeLast();

    await prefs.setString(_key, jsonEncode(history));
  }

  Future<List<Map<String, dynamic>>> getHistory({
    String? projectId,
    String? type,
  }) async {
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
      if (type != null) {
        history = history.where((e) => e['type'] == type).toList();
      }

      return history;
    } catch (_) {
      return [];
    }
  }

  Future<void> deleteDesign(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    history.removeWhere((e) => e['id'] == id);
    await prefs.setString(_key, jsonEncode(history));
  }
}



