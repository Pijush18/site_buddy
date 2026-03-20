/// FILE HEADER
/// ----------------------------------------------
/// File: site_report_image_generator.dart
/// Feature: core/utils
/// Layer: utilities
///
/// PURPOSE:
/// Rapid execution system translating physical widgets instantly to high-res native images.
///
/// RESPONSIBILITIES:
/// - Finds `RenderRepaintBoundary` nodes wrapping `SiteReportPreviewScreen`.
/// - Renders physical pixels identically scaled (3.0px ratio).
/// - Transmits payload natively to OS contexts directly safely.
/// ----------------------------------------------
library;


import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SiteReportImageGenerator {
  /// METHOD: generateAndShareImage
  /// Takes target rendered bounds bypassing conventional text-sharing limitations natively visually.
  static Future<void> generateAndShareImage(
    GlobalKey boundaryKey,
    String projectName,
  ) async {
    try {
      final boundary =
          boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint("Error: Report Boundary Missing Scope.");
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();

      final safeName = projectName.replaceAll(' ', '_');
      final file = File('${directory.path}/SiteBuddy_Report_$safeName.png');

      await file.writeAsBytes(pngBytes);

      // share_plus deprecated member bypass safely targeted natively.
      // ignore: deprecated_member_use
      final result = await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Site Report ($projectName)');

      if (result.status == ShareResultStatus.success) {
        debugPrint("Successfully shared report image natively.");
      }
    } catch (e) {
      debugPrint("Error sharing image natively: \$e");
    }
  }
}



