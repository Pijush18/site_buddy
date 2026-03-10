/// FILE HEADER
/// ----------------------------------------------
/// File: design_item.dart
/// Feature: design
/// Layer: domain/entities
///
/// PURPOSE:
/// Represents a structural design category and its associated RCC specifications.
/// ----------------------------------------------
library;


import 'package:flutter/material.dart';

/// CLASS: DesignItem
/// PURPOSE: Domain entity for structural design categories.
class DesignItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<RccSpec> rccSpecs;

  const DesignItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.rccSpecs,
  });
}

/// CLASS: RccSpec
/// PURPOSE: Represents a single RCC specification (e.g., Concrete Grade, Steel).
class RccSpec {
  final String label;
  final String value;

  const RccSpec({required this.label, required this.value});
}
