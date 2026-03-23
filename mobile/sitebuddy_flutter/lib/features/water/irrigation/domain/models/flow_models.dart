/// lib/features/water/irrigation/domain/models/flow_models.dart
///
/// Flow distribution domain models for irrigation network systems.
///
/// PURPOSE:
/// - Flow distribution across canal networks
/// - Graph-based network topology support
/// - Scalable node relationship modeling
library;

import 'package:site_buddy/features/water/irrigation/domain/models/scenario_models.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/soil_models.dart';

/// Node types in a flow distribution network
/// 
/// Supports extensible network design for future graph-based flow modeling.
enum FlowNodeType {
  /// Source node (reservoir, pump, intake)
  source,
  
  /// Distribution node (canal head, junction)
  distributor,
  
  /// Intermediate node (check structure, bifurcation)
  junction,
  
  /// Outlet node (field inlet, farm turnout)
  outlet,
  
  /// Measurement node (gauge, weir)
  measuring,
}

/// Flow distribution node in irrigation network
/// 
/// Extended with parent/child relationships for graph-based scalability.
class FlowDistributionNode {
  /// Unique identifier for this node
  final String id;
  
  /// Human-readable name
  final String name;
  
  /// Node type for network classification
  final FlowNodeType nodeType;
  
  /// Discharge (m³/s)
  final double discharge;
  
  /// Water surface elevation (m)
  final double head;
  
  /// Flow velocity (m/s)
  final double velocity;
  
  /// Total losses (m) - friction + minor losses
  final double losses;
  
  /// Parent node ID (null for root nodes)
  final String? parentId;
  
  /// Child node IDs (for branching networks)
  final List<String> childIds;
  
  /// Upstream child nodes for tree structure
  final List<FlowDistributionNode> children;

  const FlowDistributionNode({
    required this.id,
    required this.name,
    this.nodeType = FlowNodeType.distributor,
    required this.discharge,
    required this.head,
    required this.velocity,
    required this.losses,
    this.parentId,
    this.childIds = const [],
    this.children = const [],
  });

  /// Check if this is a root node (no parent)
  bool get isRootNode => parentId == null;
  
  /// Check if this is a leaf node (no children)
  bool get isLeafNode => children.isEmpty && childIds.isEmpty;
  
  /// Check if this is a branching node
  bool get isBranchingNode => children.length > 1 || childIds.length > 1;

  /// Calculate remaining head after losses
  double get availableHead => head - losses;

  /// Calculate Froude number for flow classification
  double froudeNumber({double gravitationalAcceleration = 9.81}) {
    if (velocity <= 0 || head <= 0) return 0;
    return velocity / (gravitationalAcceleration * head);
  }

  /// Check if flow is subcritical (Fr < 1) or supercritical (Fr > 1)
  bool get isSubcritical => froudeNumber(gravitationalAcceleration: 9.81) < 1;

  /// Create a copy with updated parameters
  FlowDistributionNode copyWith({
    String? id,
    String? name,
    FlowNodeType? nodeType,
    double? discharge,
    double? head,
    double? velocity,
    double? losses,
    String? parentId,
    List<String>? childIds,
    List<FlowDistributionNode>? children,
  }) {
    return FlowDistributionNode(
      id: id ?? this.id,
      name: name ?? this.name,
      nodeType: nodeType ?? this.nodeType,
      discharge: discharge ?? this.discharge,
      head: head ?? this.head,
      velocity: velocity ?? this.velocity,
      losses: losses ?? this.losses,
      parentId: parentId ?? this.parentId,
      childIds: childIds ?? this.childIds,
      children: children ?? this.children,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'nodeType': nodeType.name,
    'discharge': discharge,
    'head': head,
    'velocity': velocity,
    'losses': losses,
    'parentId': parentId,
    'childIds': childIds,
    'children': children.map((c) => c.toMap()).toList(),
  };

  /// Create from map
  factory FlowDistributionNode.fromMap(Map<String, dynamic> map) {
    return FlowDistributionNode(
      id: map['id'] as String,
      name: map['name'] as String,
      nodeType: FlowNodeType.values.firstWhere(
        (e) => e.name == map['nodeType'],
        orElse: () => FlowNodeType.distributor,
      ),
      discharge: (map['discharge'] as num).toDouble(),
      head: (map['head'] as num).toDouble(),
      velocity: (map['velocity'] as num).toDouble(),
      losses: (map['losses'] as num).toDouble(),
      parentId: map['parentId'] as String?,
      childIds: (map['childIds'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

/// Flow distribution result for canal network
class FlowDistributionResult {
  /// Total discharge at source (m³/s)
  final double totalDischarge;
  
  /// Total head at source (m)
  final double totalHead;
  
  /// Distribution network as tree structure
  final List<FlowDistributionNode> distributionNetwork;
  
  /// Overall network efficiency (%)
  final double overallEfficiency;
  
  /// Total losses across network (m)
  final double totalLosses;

  const FlowDistributionResult({
    required this.totalDischarge,
    required this.totalHead,
    required this.distributionNetwork,
    required this.overallEfficiency,
    required this.totalLosses,
  });

  /// Get root nodes from the distribution network
  List<FlowDistributionNode> get rootNodes =>
      distributionNetwork.where((n) => n.isRootNode).toList();

  /// Count total nodes in network
  int get totalNodes => distributionNetwork.length;

  /// Get all leaf nodes (outlets)
  List<FlowDistributionNode> get leafNodes =>
      distributionNetwork.where((n) => n.isLeafNode).toList();

  Map<String, dynamic> toMap() => {
    'totalDischarge': totalDischarge,
    'totalHead': totalHead,
    'distributionNetwork': distributionNetwork.map((n) => n.toMap()).toList(),
    'overallEfficiency': overallEfficiency,
    'totalLosses': totalLosses,
  };
}

/// Scenario-based irrigation design result
class ScenarioIrrigationResult {
  final IrrigationScenario scenario;
  
  /// Water requirement (m³/day)
  final double waterRequirement;
  
  /// Gross application (m³/day)
  final double grossApplication;
  
  /// Efficiency (%)
  final double efficiency;
  
  /// Recommended method name
  final String recommendedMethod;
  
  /// Required discharge (m³/s)
  final double dischargeRequired;
  
  /// Design assessment text
  final String assessment;

  const ScenarioIrrigationResult({
    required this.scenario,
    required this.waterRequirement,
    required this.grossApplication,
    required this.efficiency,
    required this.recommendedMethod,
    required this.dischargeRequired,
    required this.assessment,
  });

  Map<String, dynamic> toMap() => {
    'scenario': scenario.name,
    'waterRequirement': waterRequirement,
    'grossApplication': grossApplication,
    'efficiency': efficiency,
    'recommendedMethod': recommendedMethod,
    'dischargeRequired': dischargeRequired,
    'assessment': assessment,
  };
}

/// Comparison of irrigation methods
class IrrigationMethodComparison {
  final IrrigationMethod method;
  
  /// Water requirement (m³/day)
  final double waterRequirement;
  
  /// Efficiency (%)
  final double efficiency;
  
  /// Initial cost (relative index)
  final double initialCost;
  
  /// Operating cost (relative index)
  final double operatingCost;
  
  /// Lifecycle cost (relative index)
  final double lifecycleCost;
  
  /// Ranking (1 = best)
  final int rank;
  
  /// Whether this method is recommended
  final bool isRecommended;

  const IrrigationMethodComparison({
    required this.method,
    required this.waterRequirement,
    required this.efficiency,
    required this.initialCost,
    required this.operatingCost,
    required this.lifecycleCost,
    required this.rank,
    this.isRecommended = false,
  });

  Map<String, dynamic> toMap() => {
    'method': method.name,
    'waterRequirement': waterRequirement,
    'efficiency': efficiency,
    'initialCost': initialCost,
    'operatingCost': operatingCost,
    'lifecycleCost': lifecycleCost,
    'rank': rank,
    'isRecommended': isRecommended,
  };
}

/// Irrigation optimization result (PRO feature)
class IrrigationOptimizationResult {
  final IrrigationMethod recommendedMethod;
  
  /// Water savings (%) compared to flood irrigation
  final double waterSavings;
  
  /// Cost savings (%) on initial cost
  final double costSavings;
  
  /// Efficiency improvement (%)
  final double efficiencyGain;
  
  /// Method comparisons
  final List<IrrigationMethodComparison> methodComparisons;
  
  /// Analysis summary text
  final String analysisSummary;

  const IrrigationOptimizationResult({
    required this.recommendedMethod,
    required this.waterSavings,
    required this.costSavings,
    required this.efficiencyGain,
    required this.methodComparisons,
    required this.analysisSummary,
  });

  Map<String, dynamic> toMap() => {
    'recommendedMethod': recommendedMethod.name,
    'waterSavings': waterSavings,
    'costSavings': costSavings,
    'efficiencyGain': efficiencyGain,
    'methodComparisons': methodComparisons.map((m) => m.toMap()).toList(),
    'analysisSummary': analysisSummary,
  };
}
