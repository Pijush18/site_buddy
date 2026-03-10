import 'dart:io';

void main(List<String> args) async {
  print('\\n=========================================');
  print('SiteBuddy UI Consistency Auto-Fixer');
  print('=========================================\\n');

  final featuresDir = Directory('lib/features');
  if (!featuresDir.existsSync()) {
    print('Error: lib/features directory not found.');
    return;
  }

  final files = featuresDir
      .listSync(recursive: true)
      .whereType<File>()
      .where(
        (f) => f.path.endsWith('.dart') && f.path.contains('/presentation/'),
      )
      .toList();

  print('Scanning \${files.length} UI files...\\n');

  int totalFilesModified = 0;
  int spacingReplaced = 0;
  int typographyReplaced = 0;
  int edgeInsetsReplaced = 0;
  int cardsReplaced = 0;
  int shadowsReplaced = 0;
  int iconsReplaced = 0;

  for (final file in files) {
    String content = file.readAsStringSync();
    String originalContent = content;

    // 1. Fix Spacing (SizedBox)
    content = content.replaceAllMapped(
      RegExp(
        r'(?:const\s+)?SizedBox\(\s*(height|width):\s*(\d+(?:\.\d+)?)\s*\)',
      ),
      (m) {
        final isHeight = m.group(1) == 'height';
        final val = double.parse(m.group(2)!);
        spacingReplaced++;

        String token;
        if (val <= 4)
          token = 'AppLayout.xs';
        else if (val <= 8)
          token = 'AppLayout.sm';
        else if (val <= 16)
          token = 'AppLayout.md';
        else if (val <= 24)
          token = 'AppLayout.lg';
        else
          token = 'AppLayout.xl';

        return isHeight
            ? 'SizedBox(height: $token)'
            : 'SizedBox(width: $token)';
      },
    );

    // 2. Fix EdgeInsets
    content = content.replaceAllMapped(
      RegExp(r'EdgeInsets\s*\.(all|symmetric|only)\s*\([^)]*\)'),
      (m) {
        String fullMatch = m.group(0)!;
        String type = m.group(1)!;

        final valMatch = RegExp(r'\d+(?:\.\d+)?').firstMatch(fullMatch);
        if (valMatch != null) {
          final val = double.parse(valMatch.group(0)!);
          if (type == 'all') {
            edgeInsetsReplaced++;
            if (val <= 4) return 'AppLayout.paddingXs';
            if (val <= 8) return 'AppLayout.paddingSm';
            if (val <= 16) return 'AppLayout.paddingMd';
            if (val <= 24) return 'AppLayout.paddingLg';
            return 'AppLayout.paddingXl';
          } else if (type == 'symmetric' &&
              fullMatch.contains('horizontal') &&
              !fullMatch.contains('vertical')) {
            if (val == 16) {
              edgeInsetsReplaced++;
              return 'AppLayout.horizontalMd';
            }
            if (val == 20) {
              edgeInsetsReplaced++;
              return 'AppLayout.screenHorizontal';
            }
          } else if (type == 'symmetric' &&
              fullMatch.contains('vertical') &&
              !fullMatch.contains('horizontal')) {
            if (val == 16) {
              edgeInsetsReplaced++;
              return 'AppLayout.verticalMd';
            }
          }
        }
        return fullMatch;
      },
    );

    // 3. Fix Typography
    content = content.replaceAllMapped(
      RegExp(
        r'fontWeight\s*:\s*(?:isBold\s*\?\s*)?FontWeight\.[a-zA-Z0-9_]+(?:\s*:\s*FontWeight\.[a-zA-Z0-9_]+)?\s*,?',
      ),
      (m) {
        typographyReplaced++;
        return '';
      },
    );
    content = content.replaceAllMapped(
      RegExp(r'fontSize\s*:\s*\d+(?:\.\d+)?\s*,?'),
      (m) {
        typographyReplaced++;
        return '';
      },
    );
    content = content.replaceAll(RegExp(r'\.copyWith\s*\(\s*\)'), '');

    // 4. Fix Cards (Container -> SbCard)
    while (true) {
      int idx = content.indexOf('decoration: BoxDecoration(');
      if (idx == -1) idx = content.indexOf('decoration: const BoxDecoration(');
      if (idx == -1) break;

      int decorStart = content.indexOf('BoxDecoration(', idx);
      int endIdx = _findClosingParen(
        content,
        decorStart + 'BoxDecoration('.length - 1,
      );
      if (endIdx == -1) break;

      int containerIdx = content.lastIndexOf('Container', idx);

      if (containerIdx != -1) {
        String between = content.substring(containerIdx + 9, idx);
        if (between.trim().isEmpty || RegExp(r'^[\s\(,]*$').hasMatch(between)) {
          cardsReplaced++;
          String newStr =
              content.substring(0, containerIdx) + 'SbCard' + between;

          int sliceEnd = endIdx + 1;
          while (sliceEnd < content.length &&
              (content[sliceEnd] == ' ' ||
                  content[sliceEnd] == '\\n' ||
                  content[sliceEnd] == '\\t')) {
            sliceEnd++;
          }
          if (sliceEnd < content.length && content[sliceEnd] == ',') {
            sliceEnd++;
          }

          content = newStr + content.substring(sliceEnd);

          if (!content.contains(
            'package:site_buddy/core/widgets/sb_widgets.dart',
          )) {
            content =
                "import 'package:site_buddy/core/widgets/sb_widgets.dart';\\n" +
                content;
          }
          continue;
        }
      }

      int sliceEnd = endIdx + 1;
      while (sliceEnd < content.length &&
          (content[sliceEnd] == ' ' ||
              content[sliceEnd] == '\\n' ||
              content[sliceEnd] == '\\t')) {
        sliceEnd++;
      }
      if (sliceEnd < content.length && content[sliceEnd] == ',') {
        sliceEnd++;
      }
      content = content.substring(0, idx) + content.substring(sliceEnd);
    }

    // 5. Fix Shadows
    while (true) {
      int idx = content.indexOf('boxShadow: const [');
      if (idx == -1) idx = content.indexOf('boxShadow: [');
      if (idx == -1) break;

      int startBracket = content.indexOf('[', idx);
      int endIdx = -1;
      int count = 0;
      for (int i = startBracket; i < content.length; i++) {
        if (content[i] == '[')
          count++;
        else if (content[i] == ']') {
          count--;
          if (count == 0) {
            endIdx = i;
            break;
          }
        }
      }
      if (endIdx == -1) break;

      shadowsReplaced++;
      int sliceEnd = endIdx + 1;
      while (sliceEnd < content.length &&
          (content[sliceEnd] == ' ' ||
              content[sliceEnd] == '\\n' ||
              content[sliceEnd] == '\\t')) {
        sliceEnd++;
      }
      bool hasComma = false;
      if (sliceEnd < content.length && content[sliceEnd] == ',') {
        sliceEnd++;
        hasComma = true;
      }

      content =
          content.substring(0, idx) +
          'boxShadow: UiElevation.card' +
          (hasComma ? ',' : '') +
          content.substring(sliceEnd);
      if (!content.contains(
        'package:site_buddy/core/constants/ui_elevation.dart',
      )) {
        content =
            "import 'package:site_buddy/core/constants/ui_elevation.dart';\\n" +
            content;
      }
    }

    // 6. Fix Icons
    content = content.replaceAllMapped(
      RegExp(r'[iI]con(?:Size)?\s*:\s*(\d+)'),
      (m) {
        final val = int.parse(m.group(1)!);
        if (val == 20) {
          iconsReplaced++;
          return m.group(0)!.replaceFirst('20', '20 /* AppIcons.button */');
        }
        if (val == 18) {
          iconsReplaced++;
          return m.group(0)!.replaceFirst('18', '18 /* AppIcons.list */');
        }
        return m.group(0)!;
      },
    );

    if (content != originalContent) {
      if (!content.contains('site_buddy/core/theme/app_layout.dart') &&
          content.contains('AppLayout')) {
        content =
            "import 'package:site_buddy/core/theme/app_layout.dart';\\n" +
            content;
      }

      final backupFile = File('\${file.path}.bak');
      backupFile.writeAsStringSync(originalContent);

      file.writeAsStringSync(content);
      totalFilesModified++;
      final fileName = file.path.split('/').last;
      print('Fixed => $fileName');
    }
  }

  print('\\n=========================================');
  print('AUTO-FIX SUMMARY');
  print('=========================================');
  print('Total Files Modified: $totalFilesModified');
  print('Spacing (SizedBox) Fixed: $spacingReplaced');
  print('Spacing (EdgeInsets) Fixed: $edgeInsetsReplaced');
  print('Typography Stripped: $typographyReplaced');
  print('Card Containers Fixed: $cardsReplaced');
  print('Shadow Lists Flattened: $shadowsReplaced');
  print('Icons Tagged: $iconsReplaced');
  print('=========================================\\n');
  print('Backup files (.bak) have been generated for safety.');
  print('Run \\`flutter analyze\\` to verify integrity.');
}

int _findClosingParen(String text, int start) {
  int count = 0;
  for (int i = start; i < text.length; i++) {
    if (text[i] == '(')
      count++;
    else if (text[i] == ')') {
      count--;
      if (count == 0) return i;
    }
  }
  return -1;
}
