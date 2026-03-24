import 'package:flutter/material.dart';
import 'package:site_buddy/visualization/config/diagram_config.dart';
import 'package:site_buddy/visualization/primitives/primitives.dart' show 
    DiagramPrimitive, DiagramLine, DiagramRect, DiagramText, DiagramGroup;
import 'package:site_buddy/visualization/core/diagram_renderer.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';

/// Simple example demonstrating the core visualization engine
class SimpleDiagramExample extends StatefulWidget {
  const SimpleDiagramExample({super.key});

  @override
  State<SimpleDiagramExample> createState() => _SimpleDiagramExampleState();
}

class _SimpleDiagramExampleState extends State<SimpleDiagramExample> {
  late DiagramConfig _config;
  late List<DiagramPrimitive> _primitives;

  @override
  void initState() {
    super.initState();
    _config = const DiagramConfig(
      worldWidth: 1000.0,
      worldHeight: 800.0,
      canvasWidth: 600.0,
      canvasHeight: 400.0,
      showGrid: true,
      gridSpacing: 50.0,
      backgroundColor: Color(0xFFFAFAFA),
    );
    _primitives = _createSampleDiagram();
  }

  /// Create a sample engineering diagram (simple beam with labels)
  List<DiagramPrimitive> _createSampleDiagram() {
    return [
      // Ground/Foundation line
      const DiagramLine(
        id: 'ground',
        start: Offset(50, 0),
        end: Offset(950, 0),
        strokeWidth: 3.0,
        color: Color(0xFF4CAF50),
        label: 'Ground Level',
        zIndex: 1,
      ),

      // Main beam
      const DiagramRect(
        id: 'beam',
        position: Offset(100, 100),
        width: 800,
        height: 80,
        fillColor: Color(0xFF90CAF9),
        strokeColor: Color(0xFF1565C0),
        strokeWidth: 2.0,
        cornerRadius: 4.0,
        label: 'Main Beam',
        zIndex: 2,
      ),

      // Left support
      const DiagramRect(
        id: 'support_left',
        position: Offset(80, 0),
        width: 60,
        height: 100,
        fillColor: Color(0xFF8D6E63),
        strokeColor: Color(0xFF5D4037),
        strokeWidth: 2.0,
        label: 'Left Support',
        zIndex: 2,
      ),

      // Right support
      const DiagramRect(
        id: 'support_right',
        position: Offset(860, 0),
        width: 60,
        height: 100,
        fillColor: Color(0xFF8D6E63),
        strokeColor: Color(0xFF5D4037),
        strokeWidth: 2.0,
        label: 'Right Support',
        zIndex: 2,
      ),

      // Beam label
      const DiagramText(
        id: 'beam_label',
        position: Offset(500, 140),
        text: 'RC Beam 300x600mm',
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1565C0),
        textAlign: TextAlign.center,
        label: 'Beam Label',
        zIndex: 3,
      ),

      // Dimension line - span
      const DiagramLine(
        id: 'span_dim',
        start: Offset(100, 220),
        end: Offset(900, 220),
        strokeWidth: 1.0,
        color: Color(0xFF757575),
        dashed: true,
        label: 'Span Dimension',
        zIndex: 1,
      ),

      // Dimension text
      const DiagramText(
        id: 'span_text',
        position: Offset(500, 240),
        text: 'L = 8.0m',
        fontSize: 12,
        color: Color(0xFF757575),
        textAlign: TextAlign.center,
        label: 'Span Label',
        zIndex: 3,
      ),

      // Load indicator
      const DiagramLine(
        id: 'load_arrow',
        start: Offset(500, 50),
        end: Offset(500, 100),
        strokeWidth: 2.0,
        color: Color(0xFFF44336),
        label: 'Point Load',
        zIndex: 1,
      ),

      // Load text
      const DiagramText(
        id: 'load_text',
        position: Offset(500, 35),
        text: 'P = 50kN',
        fontSize: 11,
        color: Color(0xFFF44336),
        textAlign: TextAlign.center,
        label: 'Load Label',
        zIndex: 3,
      ),

      // Grouped annotation
      const DiagramGroup(
        id: 'annotation_group',
        children: [
          DiagramRect(
            id: 'note_bg',
            position: Offset(700, 250),
            width: 200,
            height: 60,
            fillColor: Color(0xFFFFF9C4),
            strokeColor: Color(0xFFF9A825),
            strokeWidth: 1.0,
            cornerRadius: 4.0,
            zIndex: 1,
          ),
          DiagramText(
            id: 'note_text',
            position: Offset(710, 280),
            text: 'M+ at mid-span',
            fontSize: 11,
            color: Color(0xFF5D4037),
            label: 'Note',
            zIndex: 2,
          ),
          DiagramText(
            id: 'note_text2',
            position: Offset(710, 300),
            text: 'Vmax at supports',
            fontSize: 11,
            color: Color(0xFF5D4037),
            label: 'Note',
            zIndex: 2,
          ),
        ],
        label: 'Analysis Notes',
        zIndex: 4,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Diagram Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _primitives = _createSampleDiagram();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Diagram widget
            Card(
              elevation: 2,
              child: SizedBox(
                height: 450,
                child: DiagramWidget(
                  config: _config,
                  primitives: _primitives,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info panel
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diagram Elements (${_primitives.length} primitives)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _primitives.map((p) {
                        return Chip(
                          label: Text(
                            p.label ?? p.id,
                            style: SbTypography.body,
                          ),
                          avatar: CircleAvatar(
                            backgroundColor: _getPrimitiveColor(p),
                            radius: 8,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Controls',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('• Drag to pan'),
                    const Text('• Pinch to zoom'),
                    const Text('• Double-tap to reset'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPrimitiveColor(DiagramPrimitive p) {
    if (p is DiagramLine) return p.color;
    if (p is DiagramRect) return p.fillColor;
    if (p is DiagramText) return p.color;
    if (p is DiagramGroup) return const Color(0xFF9E9E9E);
    return const Color(0xFF9E9E9E);
  }
}

/// Alternative: Minimal usage example
class MinimalDiagramExample extends StatelessWidget {
  const MinimalDiagramExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Minimal configuration
    const config = DiagramConfig(
      worldWidth: 100,
      worldHeight: 100,
      showGrid: true,
    );

    // Simple primitives
    const primitives = [
      DiagramLine(
        id: 'line1',
        start: Offset(10, 10),
        end: Offset(90, 90),
        strokeWidth: 2,
        color: Colors.red,
      ),
      DiagramRect(
        id: 'rect1',
        position: Offset(30, 30),
        width: 40,
        height: 40,
        fillColor: Colors.blue,
      ),
      DiagramText(
        id: 'text1',
        position: Offset(10, 5),
        text: 'Hello World',
        fontSize: 8,
      ),
    ];

    return const DiagramWidget(
      config: config,
      primitives: primitives,
    );
  }
}

