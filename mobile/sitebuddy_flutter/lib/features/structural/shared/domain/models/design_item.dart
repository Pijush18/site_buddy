
import 'package:flutter/material.dart';

class DesignItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final dynamic rccSpecs;

  const DesignItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    this.rccSpecs,
  });
}
