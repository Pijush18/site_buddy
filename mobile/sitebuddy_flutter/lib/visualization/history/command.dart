/// Command Pattern Implementation for Diagram/Annotation History Management
/// 
/// This provides a scalable, testable, and extensible undo/redo system
/// that supports future time-travel debugging capabilities.

import 'package:flutter/material.dart';
import '../annotations/annotation_model.dart';
import '../annotations/annotation_controller.dart';

/// Base class for all commands in the history system
/// 
/// Commands encapsulate state changes that can be:
/// - Executed (apply the change)
/// - Undone (reverse the change)
/// - Composed into macro commands
abstract class Command {
  /// Execute this command (apply the change)
  void execute();
  
  /// Undo this command (reverse the change)
  void undo();
  
  /// Human-readable description for debugging/history display
  String get description;
  
  /// Timestamp when this command was created
  DateTime get timestamp;
  
  /// Unique identifier for this command instance
  String get id;
}

/// Mixin for commands that need access to the controller
mixin ControllerAware {
  AnnotationController? _controller;
  
  void setController(AnnotationController controller) {
    _controller = controller;
  }
  
  AnnotationController get controller {
    if (_controller == null) {
      throw StateError('Controller not set for command: $this');
    }
    return _controller!;
  }
}

/// Command for adding an annotation
class AddAnnotationCommand extends Command with ControllerAware {
  final Annotation _annotation;
  
  AddAnnotationCommand({required Annotation annotation}) 
      : _annotation = annotation;
  
  Annotation get annotation => _annotation;
  
  @override
  String get description => 'Add ${_annotation.type.name}';
  
  @override
  DateTime get timestamp => DateTime.now();
  
  @override
  String get id => 'add_${_annotation.id}_${timestamp.millisecondsSinceEpoch}';
  
  @override
  void execute() {
    controller.addAnnotation(_annotation);
  }
  
  @override
  void undo() {
    controller.removeAnnotation(_annotation.id);
  }
}

/// Command for removing an annotation
class RemoveAnnotationCommand extends Command with ControllerAware {
  final Annotation _annotation;
  int _index = -1;
  
  RemoveAnnotationCommand({required Annotation annotation}) 
      : _annotation = annotation;
  
  Annotation get annotation => _annotation;
  
  @override
  String get description => 'Remove ${_annotation.type.name}';
  
  @override
  DateTime get timestamp => DateTime.now();
  
  @override
  String get id => 'remove_${_annotation.id}_${timestamp.millisecondsSinceEpoch}';
  
  @override
  void execute() {
    final annotations = controller.annotations;
    _index = annotations.indexWhere((a) => a.id == _annotation.id);
    controller.removeAnnotation(_annotation.id);
  }
  
  @override
  void undo() {
    if (_index >= 0) {
      controller.addAnnotationAt(_annotation, _index);
    } else {
      controller.addAnnotation(_annotation);
    }
  }
}

/// Command for moving an annotation
class MoveAnnotationCommand extends Command with ControllerAware {
  final String _annotationId;
  final Offset _oldPosition;
  final Offset _newPosition;
  
  MoveAnnotationCommand({
    required String annotationId,
    required Offset oldPosition,
    required Offset newPosition,
  }) : _annotationId = annotationId,
       _oldPosition = oldPosition,
       _newPosition = newPosition;
  
  @override
  String get description => 'Move annotation';
  
  @override
  DateTime get timestamp => DateTime.now();
  
  @override
  String get id => 'move_${_annotationId}_${timestamp.millisecondsSinceEpoch}';
  
  @override
  void execute() {
    final annotation = controller.getAnnotation(_annotationId);
    if (annotation != null) {
      final delta = _newPosition - _oldPosition;
      controller.moveAnnotation(_annotationId, delta);
    }
  }
  
  @override
  void undo() {
    final annotation = controller.getAnnotation(_annotationId);
    if (annotation != null) {
      final delta = _oldPosition - _newPosition;
      controller.moveAnnotation(_annotationId, delta);
    }
  }
}

/// Command for updating an annotation
class UpdateAnnotationCommand extends Command with ControllerAware {
  final Annotation _oldAnnotation;
  final Annotation _newAnnotation;
  
  UpdateAnnotationCommand({
    required Annotation oldAnnotation,
    required Annotation newAnnotation,
  }) : _oldAnnotation = oldAnnotation,
       _newAnnotation = newAnnotation;
  
  @override
  String get description => 'Update ${_newAnnotation.type.name}';
  
  @override
  DateTime get timestamp => DateTime.now();
  
  @override
  String get id => 'update_${_newAnnotation.id}_${timestamp.millisecondsSinceEpoch}';
  
  @override
  void execute() {
    controller.updateAnnotation(_newAnnotation);
  }
  
  @override
  void undo() {
    controller.updateAnnotation(_oldAnnotation);
  }
}

/// Command for changing annotation visibility
class ToggleVisibilityCommand extends Command with ControllerAware {
  final String _annotationId;
  final bool _wasVisible;
  
  ToggleVisibilityCommand({
    required String annotationId,
    required bool wasVisible,
  }) : _annotationId = annotationId,
       _wasVisible = wasVisible;
  
  @override
  String get description => 'Toggle visibility';
  
  @override
  DateTime get timestamp => DateTime.now();
  
  @override
  String get id => 'toggle_visibility_${_annotationId}_${timestamp.millisecondsSinceEpoch}';
  
  @override
  void execute() {
    controller.toggleVisibility(_annotationId);
  }
  
  @override
  void undo() {
    // Toggle back to original state
    controller.toggleVisibility(_annotationId);
  }
}

/// Command for changing annotation lock state
class ToggleLockCommand extends Command with ControllerAware {
  final String _annotationId;
  final bool _wasLocked;
  
  ToggleLockCommand({
    required String annotationId,
    required bool wasLocked,
  }) : _annotationId = annotationId,
       _wasLocked = wasLocked;
  
  @override
  String get description => 'Toggle lock';
  
  @override
  DateTime get timestamp => DateTime.now();
  
  @override
  String get id => 'toggle_lock_${_annotationId}_${timestamp.millisecondsSinceEpoch}';
  
  @override
  void execute() {
    controller.toggleLock(_annotationId);
  }
  
  @override
  void undo() {
    controller.toggleLock(_annotationId);
  }
}

/// Command for bringing annotation to front
class BringToFrontCommand extends Command with ControllerAware {
  final String _annotationId;
  final int _oldZIndex;
  
  BringToFrontCommand({
    required String annotationId,
    required int oldZIndex,
  }) : _annotationId = annotationId,
       _oldZIndex = oldZIndex;
  
  @override
  String get description => 'Bring to front';
  
  @override
  DateTime get timestamp => DateTime.now();
  
  @override
  String get id => 'bring_to_front_${_annotationId}_${timestamp.millisecondsSinceEpoch}';
  
  @override
  void execute() {
    controller.bringToFront(_annotationId);
  }
  
  @override
  void undo() {
    final annotation = controller.getAnnotation(_annotationId);
    if (annotation != null) {
      controller.updateAnnotation(annotation.copyWith(zIndex: _oldZIndex));
    }
  }
}

/// Command for sending annotation to back
class SendToBackCommand extends Command with ControllerAware {
  final String _annotationId;
  final int _oldZIndex;
  
  SendToBackCommand({
    required String annotationId,
    required int oldZIndex,
  }) : _annotationId = annotationId,
       _oldZIndex = oldZIndex;
  
  @override
  String get description => 'Send to back';
  
  @override
  DateTime get timestamp => DateTime.now();
  
  @override
  String get id => 'send_to_back_${_annotationId}_${timestamp.millisecondsSinceEpoch}';
  
  @override
  void execute() {
    controller.sendToBack(_annotationId);
  }
  
  @override
  void undo() {
    final annotation = controller.getAnnotation(_annotationId);
    if (annotation != null) {
      controller.updateAnnotation(annotation.copyWith(zIndex: _oldZIndex));
    }
  }
}

/// Macro command for grouping multiple commands
class MacroCommand extends Command {
  final List<Command> _commands = [];
  final String _description;
  @override
  final DateTime timestamp;
  
  MacroCommand({String? description}) 
      : _description = description ?? 'Multiple changes',
        timestamp = DateTime.now();
  
  @override
  String get description => _description;
  
  @override
  String get id => 'macro_${timestamp.millisecondsSinceEpoch}';
  
  void add(Command command) {
    _commands.add(command);
  }
  
  @override
  void execute() {
    for (final command in _commands) {
      command.execute();
    }
  }
  
  @override
  void undo() {
    for (final command in _commands.reversed) {
      command.undo();
    }
  }
}
