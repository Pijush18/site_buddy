/// History Manager for Command Pattern Undo/Redo System
/// 
/// Manages undo/redo stacks with support for:
/// - Maximum history limit
/// - History state change notifications
/// - Future time-travel debugging

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'command.dart';

/// Configuration for history management
class HistoryConfig {
  /// Maximum number of commands to keep in history
  final int maxHistorySize;
  
  /// Whether to merge consecutive similar commands
  final bool mergeSimilarCommands;
  
  /// Time window for merging similar commands (milliseconds)
  final int mergeTimeWindow;
  
  const HistoryConfig({
    this.maxHistorySize = 50,
    this.mergeSimilarCommands = true,
    this.mergeTimeWindow = 500,
  });
  
  static const HistoryConfig defaultConfig = HistoryConfig();
}

/// History state for UI binding
class HistoryState {
  final bool canUndo;
  final bool canRedo;
  final int undoCount;
  final int redoCount;
  final String? lastActionDescription;
  
  const HistoryState({
    required this.canUndo,
    required this.canRedo,
    required this.undoCount,
    required this.redoCount,
    this.lastActionDescription,
  });
  
  static const initial = HistoryState(
    canUndo: false,
    canRedo: false,
    undoCount: 0,
    redoCount: 0,
  );
}

/// History manager class for managing command history
class HistoryManager extends ChangeNotifier {
  final List<Command> _undoStack = [];
  final List<Command> _redoStack = [];
  final HistoryConfig _config;
  Command? _lastCommand;
  
  HistoryManager({HistoryConfig? config}) 
      : _config = config ?? HistoryConfig.defaultConfig;
  
  /// Current history state
  HistoryState get state => HistoryState(
    canUndo: canUndo,
    canRedo: canRedo,
    undoCount: _undoStack.length,
    redoCount: _redoStack.length,
    lastActionDescription: _undoStack.isNotEmpty 
        ? _undoStack.last.description 
        : null,
  );
  
  /// Whether undo is available
  bool get canUndo => _undoStack.isNotEmpty;
  
  /// Whether redo is available
  bool get canRedo => _redoStack.isNotEmpty;
  
  /// Number of undoable actions
  int get undoCount => _undoStack.length;
  
  /// Number of redoable actions
  int get redoCount => _redoStack.length;
  
  /// Execute a command and add to history
  void execute(Command command) {
    // Check if we should merge with the last command
    if (_config.mergeSimilarCommands && _shouldMerge(command)) {
      _mergeWithLast(command);
      return;
    }
    
    // Execute the command
    command.execute();
    
    // Add to undo stack
    _undoStack.add(command);
    _lastCommand = command;
    
    // Clear redo stack (new action invalidates redo history)
    _redoStack.clear();
    
    // Enforce max history size
    while (_undoStack.length > _config.maxHistorySize) {
      _undoStack.removeAt(0);
    }
    
    notifyListeners();
  }
  
  /// Undo the last command
  bool undo() {
    if (!canUndo) return false;
    
    final command = _undoStack.removeLast();
    command.undo();
    _redoStack.add(command);
    
    // Update last command reference
    _lastCommand = _undoStack.isNotEmpty ? _undoStack.last : null;
    
    notifyListeners();
    return true;
  }
  
  /// Redo the last undone command
  bool redo() {
    if (!canRedo) return false;
    
    final command = _redoStack.removeLast();
    command.execute();
    _undoStack.add(command);
    _lastCommand = command;
    
    notifyListeners();
    return true;
  }
  
  /// Clear all history
  void clear() {
    _undoStack.clear();
    _redoStack.clear();
    _lastCommand = null;
    notifyListeners();
  }
  
  /// Get list of undoable actions (for display)
  List<Command> get undoHistory => List.unmodifiable(_undoStack);
  
  /// Get list of redoable actions (for display)
  List<Command> get redoHistory => List.unmodifiable(_redoStack);
  
  /// Check if new command should be merged with last command
  bool _shouldMerge(Command command) {
    if (_lastCommand == null) return false;
    if (_lastCommand.runtimeType != command.runtimeType) return false;
    
    // Check time window
    final timeDiff = command.timestamp.difference(_lastCommand!.timestamp).inMilliseconds;
    if (timeDiff > _config.mergeTimeWindow) return false;
    
    return true;
  }
  
  /// Merge new command with the last command
  void _mergeWithLast(Command command) {
    // For now, just execute the new command and update reference
    // In a more advanced implementation, we could merge the command data
    command.execute();
    _undoStack.removeLast();
    _undoStack.add(command);
    _lastCommand = command;
    
    // Note: Redo stack is still cleared for simplicity
    // A more advanced implementation could preserve redo for merge scenarios
    
    notifyListeners();
  }
}

/// Provider for history manager
final historyManagerProvider = ChangeNotifierProvider<HistoryManager>((ref) {
  return HistoryManager();
});
