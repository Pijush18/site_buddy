// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  final stopwatch = Stopwatch()..start();
  final featuresDir = Directory('lib/features');

  if (!featuresDir.existsSync()) {
    print('Error: lib/features directory not found.');
    return;
  }

  final screenFiles = <File>[];
  await for (final entity in featuresDir.list(recursive: true)) {
    if (entity is File &&
        entity.path.endsWith('.dart') &&
        entity.path.contains('/screens/')) {
      final content = await entity.readAsString();
      if (content.contains('StatelessWidget') ||
          content.contains('StatefulWidget') ||
          content.contains('ConsumerWidget') ||
          content.contains('ConsumerStatefulWidget')) {
        screenFiles.add(entity);
      }
    }
  }

  print('\nSiteBuddy UI Police');
  print('===================');
  print('Total screens scanned: ${screenFiles.length}\n');

  final violations = <String, List<Violation>>{};
  final metrics = {
    'Hardcoded Colors': 0,
    'Direct fontSize': 0,
    'Raw Spacing': 0,
    'Direct Buttons': 0,
    'Inline Decorations': 0,
    'Direct Scaffolds': 0,
    'Radius Violations': 0,
    'Shadow Violations': 0,
    'Animation Violations': 0,
    'Form Violations': 0,
    'Missing Width Constraint': 0,
  };

  final rules = [
    Rule(
      'Hardcoded Color',
      RegExp(r'(?<!App|Pdf)Color\s*\(\s*0x'),
      'Hardcoded Colors',
    ),
    Rule(
      'Hardcoded Color',
      RegExp(
        r'(?<!App)Colors\.(?!green|red|orange|blue|grey|transparent|white|black)[a-z]',
      ),
      'Hardcoded Colors',
    ), // Allow some base colors if necessary but prefer roles
    Rule('Direct fontSize', RegExp(r'fontSize\s*:\s*[0-9]'), 'Direct fontSize'),
    Rule(
      'Direct fontWeight',
      RegExp(r'fontWeight\s*:\s*FontWeight\.'),
      'Direct fontSize',
    ),
    Rule(
      'Raw Spacing (SizedBox)',
      RegExp(r'SizedBox\s*\(\s*(height|width)\s*:\s*[0-9]'),
      'Raw Spacing',
    ),
    Rule(
      'Raw Spacing (EdgeInsets)',
      RegExp(r'EdgeInsets\s*\.(all|symmetric|only)\s*\(\s*[0-9]'),
      'Raw Spacing',
    ),
    Rule(
      'Radius Violation',
      RegExp(r'BorderRadius\s*\.\s*circular\s*\(\s*[0-9]'),
      'Radius Violations',
    ),
    Rule('Shadow Violation', RegExp(r'BoxShadow\s*\('), 'Shadow Violations'),
    Rule(
      'Direct Button',
      RegExp(r'\b(ElevatedButton|OutlinedButton|TextButton)\b'),
      'Direct Buttons',
    ),
    Rule('Direct Card', RegExp(r'\bCard\s*\('), 'Inline Decorations'),
    Rule('Direct Scaffold', RegExp(r'\bScaffold\s*\('), 'Direct Scaffolds'),
    Rule(
      'Animation Duration',
      RegExp(r'Duration\s*\(\s*milliseconds\s*:\s*[0-9]'),
      'Animation Violations',
    ),
    Rule('Form Violation', RegExp(r'\bTextFormField\b'), 'Form Violations'),
    // Inline BoxDecoration is fine if it uses tokens, so we'll only flag if it has BoxShadow inside?
    // Actually, rule 13 flags BoxShadow directly.
    // We'll keep BoxDecoration check but maybe relax it if it's becoming too noisy.
    // Rule 13: Shadows must use AppShadows presets.
  ];

  for (final file in screenFiles) {
    final path = file.path;
    final lines = await file.readAsLines();
    final fileViolations = <Violation>[];

    final content = lines.join('\n');
    // Rule: Width Constraint
    if (!content.contains('maxContentWidth') && !content.contains('SbPage')) {
      fileViolations.add(
        Violation(
          0,
          'Missing layout width constraint (AppLayout.maxContentWidth)',
        ),
      );
      metrics['Missing Width Constraint'] =
          (metrics['Missing Width Constraint'] ?? 0) + 1;
    }

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trim().startsWith('//')) continue;

      for (final rule in rules) {
        final matches = rule.pattern.allMatches(line);
        for (final _ in matches) {
          fileViolations.add(Violation(i + 1, rule.name));
          metrics[rule.metricKey] = (metrics[rule.metricKey] ?? 0) + 1;
        }
      }
    }

    if (fileViolations.isNotEmpty) {
      violations[path] = fileViolations;
    }
  }

  // Sorting violations by number of issues for "Top 10"
  final sortedPathsByCount = violations.keys.toList()
    ..sort((a, b) => violations[b]!.length.compareTo(violations[a]!.length));

  // Output all violations per screen
  for (final path in sortedPathsByCount) {
    final vList = violations[path]!;
    print('Screen: ${path.split('/').last.replaceAll('.dart', '')}');
    print('File: $path');
    print('Violations:');
    for (final v in vList) {
      print('  • ${v.type} → line ${v.line == 0 ? "N/A" : v.line}');
    }
    print('');
  }

  print('AGGREGATED METRICS');
  print('------------------');
  metrics.forEach((key, value) {
    print('${key.padRight(25)}: $value');
  });
  print('');

  final totalViolations = metrics.values.reduce((a, b) => a + b);
  final totalRuleViolations =
      totalViolations - (metrics['Missing Width Constraint'] ?? 0);
  final score = _calculateScore(screenFiles.length, totalViolations);

  print('TOP 10 FILES WITH MOST ISSUES');
  print('-----------------------------');
  for (
    var i = 0;
    i < (sortedPathsByCount.length < 10 ? sortedPathsByCount.length : 10);
    i++
  ) {
    final path = sortedPathsByCount[i];
    print(
      '${(i + 1).toString().padRight(2)}: ${path.split('/').last} (${violations[path]!.length} violations)',
    );
  }
  print('');

  print('PROJECT HEALTH SCORE: $score / 100');
  _printRating(score);
  print('Total rule violations: $totalRuleViolations');
  print(
    'Total screens with missing constraints: ${metrics['Missing Width Constraint']}',
  );
  print('Scan completed in ${stopwatch.elapsedMilliseconds}ms');
}

class Rule {
  final String name;
  final RegExp pattern;
  final String metricKey;
  Rule(this.name, this.pattern, this.metricKey);
}

class Violation {
  final int line;
  final String type;
  Violation(this.line, this.type);
}

int _calculateScore(int screens, int totalViolations) {
  if (screens == 0) return 100;
  // Penalty calculation
  final penalty = (totalViolations / screens * 3).round();
  return (100 - penalty).clamp(0, 100);
}

void _printRating(int score) {
  if (score >= 90) {
    print('Rating: Production Ready');
  } else if (score >= 75) {
    print('Rating: Minor Refactor Required');
  } else if (score >= 60) {
    print('Rating: Moderate UI Issues');
  } else {
    print('Rating: Major Governance Violations');
  }
}
