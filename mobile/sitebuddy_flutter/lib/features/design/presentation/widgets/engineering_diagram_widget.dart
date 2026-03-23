// FILE HEADER
// ----------------------------------------------
// File: engineering_diagram_widget.dart
// Feature: design
// Layer: presentation/widgets
//
// PURPOSE:
// Widget that wraps the DiagramRenderer with engineering-specific features.
// This provides a ready-to-use component for integrating diagrams into screens.
//
// USAGE:
//   // Basic usage
//   EngineeringDiagramWidget(
//     diagramType: DiagramType.beamCrossSection,
//     state: beamState,
//   )
//
//   // With custom configuration
//   EngineeringDiagramWidget(
//     diagramType: DiagramType.columnInteraction,
//     state: columnState,
//     showExport: true,
//     backgroundColor: Colors.grey[100]!,
//   )
//
// ----------------------------------------------

import 'package:flutter/material.dart';

import 'package:site_buddy/visualization/engine_interface.dart';
import 'package:site_buddy/features/design/mappers/mappers.dart';
import 'package:site_buddy/features/design/presentation/widgets/diagram_renderer.dart';
import 'package:site_buddy/core/widgets/sb_diagram_card.dart';

/// ENUM: DiagramType
/// Defines the types of engineering diagrams available.
enum DiagramType {
  beamCrossSection,
  beamSFD,
  beamBMD,
  beamStirrupDetail,
  beamComplete,
  columnCrossSection,
  columnInteraction,
  columnSlenderness,
  columnComplete,
  footingPlan,
  footingSection,
  footingPressure,
  footingComplete,
  slabPlan,
  slabSection,
  slabMoment,
  slabComplete,
}

/// WIDGET: EngineeringDiagramWidget
/// PURPOSE: Ready-to-use widget for rendering engineering diagrams.
class EngineeringDiagramWidget extends StatelessWidget {
  /// Type of diagram to render
  final DiagramType diagramType;

  /// Beam design state (if rendering beam diagrams)
  final dynamic beamState;

  /// Column design state (if rendering column diagrams)
  final dynamic columnState;

  /// Footing design state (if rendering footing diagrams)
  final dynamic footingState;

  /// Slab design state (if rendering slab diagrams)
  final dynamic slabState;

  /// Whether to show export button
  final bool showExport;

  /// Background color
  final Color backgroundColor;

  /// Height constraint (optional)
  final double? height;

  /// Title to display
  final String? title;

  const EngineeringDiagramWidget({
    super.key,
    required this.diagramType,
    this.beamState,
    this.columnState,
    this.footingState,
    this.slabState,
    this.showExport = false,
    this.backgroundColor = Colors.white,
    this.height,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final primitives = _getPrimitives();

    if (primitives.isEmpty) {
      return _buildEmptyState(context);
    }

    if (showExport) {
      return Column(
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          Expanded(
            child: DiagramRenderer(
              primitives: primitives,
              backgroundColor: backgroundColor,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: height,
      child: DiagramRenderer(
        primitives: primitives,
        backgroundColor: backgroundColor,
        title: title,
      ),
    );
  }

  List<DiagramPrimitive> _getPrimitives() {
    switch (diagramType) {
      case DiagramType.beamCrossSection:
        return BeamToDiagramMapper.mapCrossSection(beamState);

      case DiagramType.beamSFD:
        return BeamToDiagramMapper.mapSFD(beamState);

      case DiagramType.beamBMD:
        return BeamToDiagramMapper.mapBMD(beamState);

      case DiagramType.beamStirrupDetail:
        return BeamToDiagramMapper.mapStirrupDetail(beamState);

      case DiagramType.beamComplete:
        return BeamToDiagramMapper.mapComplete(beamState);

      case DiagramType.columnCrossSection:
        return ColumnToDiagramMapper.mapCrossSection(columnState);

      case DiagramType.columnInteraction:
        return ColumnToDiagramMapper.mapInteractionDiagram(columnState);

      case DiagramType.columnSlenderness:
        return ColumnToDiagramMapper.mapSlendernessDiagram(columnState);

      case DiagramType.columnComplete:
        return ColumnToDiagramMapper.mapComplete(columnState);

      case DiagramType.footingPlan:
        return FootingToDiagramMapper.mapPlanView(footingState);

      case DiagramType.footingSection:
        return FootingToDiagramMapper.mapSectionView(footingState);

      case DiagramType.footingPressure:
        return FootingToDiagramMapper.mapSoilPressure(footingState);

      case DiagramType.footingComplete:
        return FootingToDiagramMapper.mapComplete(footingState);

      case DiagramType.slabPlan:
        return SlabToDiagramMapper.mapPlanView(slabState);

      case DiagramType.slabSection:
        return SlabToDiagramMapper.mapSectionView(slabState);

      case DiagramType.slabMoment:
        return SlabToDiagramMapper.mapMomentDiagram(slabState);

      case DiagramType.slabComplete:
        return SlabToDiagramMapper.mapComplete(slabState);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: height ?? 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.architecture_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'No diagram data available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// WIDGET: BeamDiagramCard
/// PURPOSE: Convenience widget for beam diagrams with common styling.
class BeamDiagramCard extends StatelessWidget {
  final DiagramType diagramType;
  final dynamic beamState;
  final String? title;
  final bool expanded;

  const BeamDiagramCard({
    super.key,
    required this.diagramType,
    required this.beamState,
    this.title,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return SbDiagramCard(
      title: title,
      expanded: expanded,
      child: EngineeringDiagramWidget(
        diagramType: diagramType,
        beamState: beamState,
      ),
    );
  }
}

/// WIDGET: ColumnDiagramCard
/// PURPOSE: Convenience widget for column diagrams with common styling.
class ColumnDiagramCard extends StatelessWidget {
  final DiagramType diagramType;
  final dynamic columnState;
  final String? title;

  const ColumnDiagramCard({
    super.key,
    required this.diagramType,
    required this.columnState,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SbDiagramCard(
      title: title,
      expanded: true,
      child: EngineeringDiagramWidget(
        diagramType: diagramType,
        columnState: columnState,
      ),
    );
  }
}

/// WIDGET: FootingDiagramCard
/// PURPOSE: Convenience widget for footing diagrams with common styling.
class FootingDiagramCard extends StatelessWidget {
  final DiagramType diagramType;
  final dynamic footingState;
  final String? title;

  const FootingDiagramCard({
    super.key,
    required this.diagramType,
    required this.footingState,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SbDiagramCard(
      title: title,
      expanded: true,
      child: EngineeringDiagramWidget(
        diagramType: diagramType,
        footingState: footingState,
      ),
    );
  }
}

/// WIDGET: SlabDiagramCard
/// PURPOSE: Convenience widget for slab diagrams with common styling.
class SlabDiagramCard extends StatelessWidget {
  final DiagramType diagramType;
  final dynamic slabState;
  final String? title;

  const SlabDiagramCard({
    super.key,
    required this.diagramType,
    required this.slabState,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SbDiagramCard(
      title: title,
      expanded: true,
      child: EngineeringDiagramWidget(
        diagramType: diagramType,
        slabState: slabState,
      ),
    );
  }
}
