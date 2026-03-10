import 'dart:io';

void main() {
  final targetDirs = [
    'lib/core/widgets',
    'lib/core/ui',
    'lib/features',
  ];

  final skipPatterns = [
    'pdf',
    'diagram',
    'drawing',
    'painter',
    'design_report_service',
    'sb_surface.dart',
  ];

  final files = <File>[];
  for (final dir in targetDirs) {
    if (Directory(dir).existsSync()) {
      for (final entity in Directory(dir).listSync(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          files.add(entity);
        }
      }
    }
  }

  int updatedCount = 0;

  for (final file in files) {
    final path = file.path;
    if (skipPatterns.any((p) => path.contains(p))) continue;

    String content = file.readAsStringSync();
    String newContent = content;

    // We replace exact background color definitions
    newContent = newContent.replaceAllMapped(
      RegExp(r'color:\s*(?:const\s+)?(Colors\.(?:white|grey(?:\[\d+\])?)|Color\(0xFF[0-9A-Fa-f]{6}\))([^A-Za-z0-9_(])'), 
      (match) {
        final val = match.group(1)!;
        final trailing = match.group(2)!;
        if (val.contains('grey')) return 'color: SbSurface.section(context)$trailing';
        if (val.contains('Color(') && !val.contains('FFFFFF')) return 'color: SbSurface.section(context)$trailing';
        return 'color: SbSurface.card(context)$trailing';
      }
    );

    if (newContent != content) {
      if (!newContent.contains("import 'package:site_buddy/core/design_system/sb_surface.dart';")) {
        newContent = "import 'package:site_buddy/core/design_system/sb_surface.dart';\n" + newContent;
      }
      file.writeAsStringSync(newContent);
      updatedCount++;
    }
  }

  print('Modified $updatedCount files.');
}
