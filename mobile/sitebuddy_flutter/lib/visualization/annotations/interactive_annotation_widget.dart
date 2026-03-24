import 'package:flutter/material.dart';
import 'package:site_buddy/visualization/annotations/annotation_model.dart';
import 'package:site_buddy/visualization/annotations/annotation_controller.dart';

/// Interactive annotation layer widget
/// 
/// Wraps a diagram and adds annotation interaction capabilities:
/// - Selection with tap
/// - Drag to move
/// - Tool-based creation
/// - Zoom/pan awareness
/// 
/// NOTE: This widget only handles INTERACTION.
/// Rendering is handled through the controller.primitives getter
/// which feeds into renderDiagram() for the single rendering pipeline.
class InteractiveAnnotationLayer extends StatefulWidget {
  final Widget child;
  final AnnotationController controller;
  final bool enabled;
  final void Function(Offset worldPosition)? onTap;
  final void Function(Annotation annotation)? onAnnotationSelected;
  final void Function(Annotation annotation)? onAnnotationCreated;

  const InteractiveAnnotationLayer({
    super.key,
    required this.child,
    required this.controller,
    this.enabled = true,
    this.onTap,
    this.onAnnotationSelected,
    this.onAnnotationCreated,
  });

  @override
  State<InteractiveAnnotationLayer> createState() => _InteractiveAnnotationLayerState();
}

class _InteractiveAnnotationLayerState extends State<InteractiveAnnotationLayer> {
  String? _draggingId;
  Offset? _dragStart;
  Offset? _dimensionStart;
  Offset? _calloutTarget;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: widget.enabled ? _onPointerDown : null,
      onPointerMove: widget.enabled ? _onPointerMove : null,
      onPointerUp: widget.enabled ? _onPointerUp : null,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: widget.enabled ? _onTapDown : null,
        child: widget.child,
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    // Convert to world coordinates - caller should provide this via CoordinateMapper
    // For now, use position directly
    final position = details.localPosition;
    
    widget.onTap?.call(position);
  }

  void _onPointerDown(PointerDownEvent event) {
    final position = event.localPosition;
    
    // Check for selection - use the controller's hit test
    final hitId = widget.controller.findAnnotationAt(position);
    
    if (hitId != null) {
      // Select and start dragging
      widget.controller.selectAnnotation(hitId);
      _draggingId = hitId;
      _dragStart = position;
      final annotation = widget.controller.getAnnotation(hitId);
      
      widget.onAnnotationSelected?.call(annotation!);
      return;
    }

    // Clear selection if tapping empty space
    widget.controller.clearSelection();

    // Handle tool-based creation
    final tool = widget.controller.activeTool;
    if (tool != null) {
      switch (tool) {
        case AnnotationType.text:
          _createTextAnnotation(position);
          break;
        case AnnotationType.marker:
          _createMarkerAnnotation(position);
          break;
        case AnnotationType.highlight:
          _createHighlightStart(position);
          break;
        case AnnotationType.dimension:
          _createDimensionStart(position);
          break;
        case AnnotationType.callout:
          _createCalloutStart(position);
          break;
      }
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_draggingId == null || _dragStart == null) return;
    
    final currentPos = event.localPosition;
    final delta = currentPos - _dragStart!;
    
    // Move annotation by delta
    widget.controller.moveAnnotation(_draggingId!, delta);
    
    _dragStart = currentPos;
  }

  void _onPointerUp(PointerUpEvent event) {
    // Complete dimension annotation if in progress
    if (_dimensionStart != null && widget.controller.activeTool == AnnotationType.dimension) {
      final endPos = event.localPosition;
      _createDimensionComplete(endPos);
    }
    
    // Complete callout annotation if in progress
    if (_calloutTarget != null && widget.controller.activeTool == AnnotationType.callout) {
      _createCalloutComplete();
    }
    
    _draggingId = null;
    _dragStart = null;
    _dimensionStart = null;
    _calloutTarget = null;
  }

  void _createTextAnnotation(Offset position) {
    final id = widget.controller.generateId();
    final annotation = TextAnnotation(
      id: id,
      position: position,
      text: 'Text',
      style: widget.controller.currentStyle,
    );
    widget.controller.addAnnotation(annotation);
    widget.controller.selectAnnotation(id);
    widget.controller.setActiveTool(null);
    widget.onAnnotationCreated?.call(annotation);
  }

  void _createMarkerAnnotation(Offset position) {
    final id = widget.controller.generateId();
    final annotation = MarkerAnnotation(
      id: id,
      position: position,
      style: widget.controller.currentStyle,
    );
    widget.controller.addAnnotation(annotation);
    widget.controller.selectAnnotation(id);
    widget.controller.setActiveTool(null);
    widget.onAnnotationCreated?.call(annotation);
  }

  void _createHighlightStart(Offset position) {
    _dimensionStart = position;
    // For highlight, we'll create a fixed-size rectangle
    final id = widget.controller.generateId();
    final annotation = HighlightAnnotation(
      id: id,
      position: position,
      width: 100,
      height: 50,
      style: widget.controller.currentStyle,
    );
    widget.controller.addAnnotation(annotation);
    widget.controller.selectAnnotation(id);
    widget.controller.setActiveTool(null);
    widget.onAnnotationCreated?.call(annotation);
  }

  void _createDimensionStart(Offset position) {
    _dimensionStart = position;
    // Dimension needs two points, so we wait for pointer up
  }

  void _createDimensionComplete(Offset endPosition) {
    if (_dimensionStart == null) return;
    
    final id = widget.controller.generateId();
    final distance = (endPosition - _dimensionStart!).distance;
    final annotation = DimensionAnnotation(
      id: id,
      position: _dimensionStart!,
      endPosition: endPosition,
      value: distance.toStringAsFixed(1),
      style: widget.controller.currentStyle,
    );
    widget.controller.addAnnotation(annotation);
    widget.controller.selectAnnotation(id);
    widget.controller.setActiveTool(null);
    widget.onAnnotationCreated?.call(annotation);
    
    _dimensionStart = null;
  }

  void _createCalloutStart(Offset position) {
    _calloutTarget = position;
    // Callout needs two points, so we wait for pointer up
  }

  void _createCalloutComplete() {
    if (_calloutTarget == null) return;
    
    final id = widget.controller.generateId();
    final annotation = CalloutAnnotation(
      id: id,
      position: _calloutTarget! + const Offset(80, 40), // Text position
      targetPosition: _calloutTarget!, // Arrow target
      text: 'Note',
      style: widget.controller.currentStyle,
    );
    widget.controller.addAnnotation(annotation);
    widget.controller.selectAnnotation(id);
    widget.controller.setActiveTool(null);
    widget.onAnnotationCreated?.call(annotation);
    
    _calloutTarget = null;
  }
}

/// Callback type for annotation creation
typedef AnnotationCreatedCallback = void Function(Annotation annotation);

/// Toolbar widget for annotation tools
class AnnotationToolbar extends StatelessWidget {
  final AnnotationController controller;
  final VoidCallback? onDelete;

  const AnnotationToolbar({
    super.key,
    required this.controller,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selection tool
              _ToolButton(
                icon: Icons.near_me,
                tooltip: 'Select',
                isActive: controller.activeTool == null,
                onPressed: () => controller.setActiveTool(null),
              ),
              const SizedBox(width: 4),
              const VerticalDivider(width: 1),
              const SizedBox(width: 4),
              // Text tool
              _ToolButton(
                icon: Icons.text_fields,
                tooltip: 'Add Text',
                isActive: controller.activeTool == AnnotationType.text,
                onPressed: () => controller.setActiveTool(AnnotationType.text),
              ),
              // Marker tool
              _ToolButton(
                icon: Icons.push_pin,
                tooltip: 'Add Marker',
                isActive: controller.activeTool == AnnotationType.marker,
                onPressed: () => controller.setActiveTool(AnnotationType.marker),
              ),
              // Highlight tool
              _ToolButton(
                icon: Icons.crop_square,
                tooltip: 'Add Highlight',
                isActive: controller.activeTool == AnnotationType.highlight,
                onPressed: () => controller.setActiveTool(AnnotationType.highlight),
              ),
              // Dimension tool
              _ToolButton(
                icon: Icons.straighten,
                tooltip: 'Add Dimension',
                isActive: controller.activeTool == AnnotationType.dimension,
                onPressed: () => controller.setActiveTool(AnnotationType.dimension),
              ),
              // Callout tool
              _ToolButton(
                icon: Icons.comment,
                tooltip: 'Add Callout',
                isActive: controller.activeTool == AnnotationType.callout,
                onPressed: () => controller.setActiveTool(AnnotationType.callout),
              ),
              const SizedBox(width: 4),
              const VerticalDivider(width: 1),
              const SizedBox(width: 4),
              // Delete selected
              _ToolButton(
                icon: Icons.delete_outline,
                tooltip: 'Delete Selected',
                isActive: false,
                enabled: controller.selectedId != null,
                onPressed: () {
                  final selectedId = controller.selectedId;
                  if (selectedId != null) {
                    controller.removeAnnotation(selectedId);
                  }
                  onDelete?.call();
                },
              ),
              // Undo
              _ToolButton(
                icon: Icons.undo,
                tooltip: 'Undo',
                isActive: false,
                enabled: controller.canUndo,
                onPressed: controller.undo,
              ),
              // Redo
              _ToolButton(
                icon: Icons.redo,
                tooltip: 'Redo',
                isActive: false,
                enabled: controller.canRedo,
                onPressed: controller.redo,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isActive;
  final bool enabled;
  final VoidCallback onPressed;

  const _ToolButton({
    required this.icon,
    required this.tooltip,
    required this.isActive,
    this.enabled = true,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isActive ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 20,
              color: enabled 
                  ? (isActive ? Theme.of(context).primaryColor : Colors.black87)
                  : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
