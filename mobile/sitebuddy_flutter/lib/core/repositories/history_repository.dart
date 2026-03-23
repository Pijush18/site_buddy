import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:site_buddy/core/models/history_item.dart';

/// REPOSITORY: HistoryRepository
/// Handles CRUD operations for HistoryItem persistence using Hive
class HistoryRepository {
  static const String _boxName = 'history';
  late Box<HistoryItem> _box;
  final Uuid _uuid = const Uuid();

  /// Initialize the repository and open Hive box
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HistoryItemAdapter());
    }
    _box = await Hive.openBox<HistoryItem>(_boxName);
  }

  /// Add a new history item
  Future<HistoryItem> addHistory({
    required String toolId,
    required String title,
    required Map<String, dynamic> inputData,
    required Map<String, dynamic> resultData,
    String? projectId,
  }) async {
    final item = HistoryItem(
      id: _uuid.v4(),
      toolId: toolId,
      title: title,
      inputData: inputData,
      resultData: resultData,
      createdAt: DateTime.now(),
      projectId: projectId,
    );
    await _box.put(item.id, item);
    return item;
  }

  /// Get all history items sorted by date (newest first)
  List<HistoryItem> getAllHistory() {
    final items = _box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  /// Get recent history items with limit
  List<HistoryItem> getRecentHistory({int limit = 10}) {
    final items = getAllHistory();
    return items.take(limit).toList();
  }

  /// Get history items by tool ID
  List<HistoryItem> getHistoryByTool(String toolId) {
    return _box.values
        .where((item) => item.toolId == toolId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get history items by project ID
  List<HistoryItem> getHistoryByProject(String projectId) {
    return _box.values
        .where((item) => item.projectId == projectId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Delete a history item
  Future<void> deleteHistory(String id) async {
    await _box.delete(id);
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await _box.clear();
  }

  /// Get history item by ID
  HistoryItem? getHistory(String id) {
    return _box.get(id);
  }

  /// Get total count
  int get count => _box.length;
}