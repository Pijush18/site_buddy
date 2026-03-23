import 'package:flutter/material.dart';
import '../adapters/road_pavement_diagram.dart';
import '../adapters/canal_cross_section_diagram.dart';
import '../config/diagram_config.dart';
import '../primitives/primitives.dart' show DiagramPrimitive;
import '../core/diagram_renderer.dart';

/// Test screen demonstrating real-world diagram adapters
class DiagramTestScreen extends StatefulWidget {
  const DiagramTestScreen({super.key});

  @override
  State<DiagramTestScreen> createState() => _DiagramTestScreenState();
}

class _DiagramTestScreenState extends State<DiagramTestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DiagramConfig _pavementConfig;
  late DiagramConfig _canalConfig;
  late List<DiagramPrimitive> _pavementPrimitives;
  late List<DiagramPrimitive> _canalPrimitives;
  bool _isFlexiblePavement = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initDiagrams();
  }

  void _initDiagrams() {
    // Pavement configuration
    _pavementConfig = const DiagramConfig(
      worldWidth: 500,
      worldHeight: 150,
      showGrid: false,
      backgroundColor: Color(0xFFF5F5F5),
    );

    // Canal configuration
    _canalConfig = const DiagramConfig(
      worldWidth: 400,
      worldHeight: 200,
      showGrid: false,
      backgroundColor: Color(0xFFFAFAFA),
    );

    _buildPavementDiagram();
    _buildCanalDiagram();
  }

  void _buildPavementDiagram() {
    final adapter = PavementDiagramAdapter();
    final layers = _isFlexiblePavement
        ? PavementTemplates.flexiblePavement()
        : PavementTemplates.rigidPavement();

    _pavementPrimitives = adapter.createDiagram(
      layers: layers,
      width: 300,
      groundY: 100,
      scale: 0.15,
    );
  }

  void _buildCanalDiagram() {
    final adapter = CanalDiagramAdapter();
    final section = CanalTemplates.trapezoidalCanal();

    _canalPrimitives = adapter.createDiagram(
      section: section,
      centerX: 200,
      groundY: 150,
      horizontalScale: 10.0,
      verticalScale: 8.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagram Engine Test'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pavement'),
            Tab(text: 'Canal'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPavementTab(),
          _buildCanalTab(),
        ],
      ),
    );
  }

  Widget _buildPavementTab() {
    return Column(
      children: [
        // Toggle for pavement type
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('Pavement Type: '),
              ChoiceChip(
                label: const Text('Flexible'),
                selected: _isFlexiblePavement,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _isFlexiblePavement = true;
                      _buildPavementDiagram();
                    });
                  }
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Rigid'),
                selected: !_isFlexiblePavement,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _isFlexiblePavement = false;
                      _buildPavementDiagram();
                    });
                  }
                },
              ),
            ],
          ),
        ),

        // Diagram
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DiagramWidget(
                config: _pavementConfig,
                primitives: _pavementPrimitives,
              ),
            ),
          ),
        ),

        // Info panel
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pavement Diagram - Issues Identified:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('• Dimension lines are manual workarounds'),
                  const Text('• No automatic hatching patterns for materials'),
                  const Text('• Labels positioned manually'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCanalTab() {
    return Column(
      children: [
        // Diagram
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DiagramWidget(
                config: _canalConfig,
                primitives: _canalPrimitives,
              ),
            ),
          ),
        ),

        // Info panel
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Canal Diagram - Issues Identified:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('• No polygon primitive - used 20 stripe rectangles'),
                  const Text('• No water/wave pattern primitive'),
                  const Text('• Parabolic shape approximated with trapezoid'),
                  const Text('• No proper cross-section fill with hatch'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
