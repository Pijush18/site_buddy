

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';

/// SERVICE: BeamHistoryService
/// PURPOSE: Persists beam designs locally.
class BeamHistoryService {
  static const String _key = 'beam_design_history';

  Future<void> saveDesign(BeamDesignState state, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    final entry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'date': DateTime.now().toIso8601String(),
      'data': {
        'type': state.type.index,
        'span': state.span,
        'width': state.width,
        'depth': state.overallDepth,
        'cover': state.cover,
        'concrete': state.concreteGrade,
        'steel': state.steelGrade,
        'dl': state.deadLoad,
        'll': state.liveLoad,
        'pl': state.pointLoad,
      },
    };

    history.insert(0, entry);
    if (history.length > 20) history.removeLast();

    await prefs.setString(_key, jsonEncode(history));
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      return List<Map<String, dynamic>>.from(jsonDecode(raw));
    } catch (_) {
      return [];
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
