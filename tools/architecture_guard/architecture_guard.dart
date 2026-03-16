// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final startTime = DateTime.now();
  print('--- SiteBuddy Architecture Map Generator ---');

  final scanner = ArchitectureScanner();
  scanner.scan(Directory('mobile/sitebuddy_flutter/lib'));

  final generator = MapGenerator(scanner);
  generator.generateMarkdown('docs/architecture_map.md');
  generator.generateDot('docs/architecture_graph.dot');
  generator.generateHtml('docs/architecture_map.html');

  final duration = DateTime.now().difference(startTime);
  print('Done! Generated architecture maps in ${duration.inMilliseconds}ms.');
}

class ArchitectureScanner {
  final Map<String, FeatureData> features = {};
  final List<String> coreWidgets = [];
  final List<String> sharedWidgets = [];
  final List<NavigationRoute> routes = [];

  void scan(Directory root) {
    // 1. Detect Features
    final featuresDir = Directory('${root.path}/features');
    if (featuresDir.existsSync()) {
      print('Scanning features...');
      for (final entity in featuresDir.listSync()) {
        if (entity is Directory) {
          final name = entity.path.split('/').last;
          if (name == 'design_common') continue;
          print('  Found feature: $name');
          features[name] = FeatureData(name);
          _scanFeature(entity, features[name]!);
        }
      }
    }

    // 2. Scan Core & Shared Widgets
    print('Scanning widgets...');
    _scanWidgets(Directory('${root.path}/core/widgets'), coreWidgets);
    _scanWidgets(Directory('${root.path}/shared/widgets'), sharedWidgets);

    // 3. Parse Router
    print('Parsing router...');
    _parseRouter(File('${root.path}/app/router.dart'));
  }

  void _scanFeature(Directory featureDir, FeatureData data) {
    final screensDir = Directory('${featureDir.path}/presentation/screens');
    if (screensDir.existsSync()) {
      for (final file in screensDir.listSync(recursive: true)) {
        if (file is File && file.path.endsWith('.dart')) {
          _processScreenFile(file, data);
        }
      }
    }
  }

  void _processScreenFile(File file, FeatureData data) {
    print('    Processing screen: ${file.path}');
    final content = file.readAsStringSync();

    // Detect Screen Classes (Stateless, Stateful, ConsumerWidget, ConsumerStatefulWidget)
    final classRegex = RegExp(r'class\s+([A-Za-z0-9_]+Screen)\s+extends');
    final matches = classRegex.allMatches(content);

    for (final match in matches) {
      final screenName = match.group(1)!;
      final screen = ScreenData(screenName, file.path);

      // Detect Widget Usage
      _detectWidgetUsage(content, screen);

      // Detect Navigation Outgoing (Simplified)
      _detectNavigation(content, screen);

      data.screens.add(screen);
    }
  }

  void _detectWidgetUsage(String content, ScreenData screen) {
    // Detect SiteBuddy components
    final widgetRegex = RegExp(
      r'(Sb[A-Z][A-Za-z0-9]+|App[A-Z][A-Za-z0-9]+|DesignResultCard|ResultTile)',
    );
    final matches = widgetRegex.allMatches(content);
    for (final match in matches) {
      screen.usedWidgets.add(match.group(1)!);
    }
  }

  void _detectNavigation(String content, ScreenData screen) {
    // Match context.go('/path') or context.push('/path')
    final navRegex = RegExp(r'''context\.(go|push)\(['"]([^'"]+)['"]''');
    final matches = navRegex.allMatches(content);
    for (final match in matches) {
      screen.outgoingRoutes.add(match.group(2)!);
    }
  }

  void _scanWidgets(Directory dir, List<String> list) {
    if (!dir.existsSync()) return;
    print('  Scanning widgets in ${dir.path}...');
    for (final file in dir.listSync(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        final content = file.readAsStringSync();
        final classRegex = RegExp(r'class\s+([A-Za-z0-9_]+)\s+extends');
        final matches = classRegex.allMatches(content);
        for (final match in matches) {
          list.add(match.group(1)!);
        }
      }
    }
  }

  void _parseRouter(File file) {
    if (!file.existsSync()) return;
    print('  Parsing router file: ${file.path}');
    final content = file.readAsStringSync();

    // Better regex-based multi-line parser for GoRoute
    final routeRegex = RegExp(
      r'''GoRoute\(\s*path:\s*['"]([^'"]+)['"].*?builder:.*?=>.*?([A-Za-z0-9_]+Screen)''',
      dotAll: true,
    );
    final matches = routeRegex.allMatches(content);

    for (final match in matches) {
      routes.add(NavigationRoute(match.group(1)!, match.group(2)!));
    }

    // Also scan for spread routes (aiRoutes, calculatorRoutes etc)
    final spreadRegex = RegExp(r"\.\.\.([A-Za-z0-9_]+Routes)");
    final spreads = spreadRegex.allMatches(content);
    for (final spread in spreads) {
      print('    Detected spread route module: ${spread.group(1)}');
      _scanRouteModule(spread.group(1)!);
    }
  }

  void _scanRouteModule(String moduleName) {
    // Attempt to find the file for the route module
    final fileName = '${moduleName.replaceAll('Routes', '_routes')}.dart';
    final file = File('mobile/sitebuddy_flutter/lib/app/routes/$fileName');
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      final routeRegex = RegExp(
        r'''GoRoute\(\s*path:\s*['"]([^'"]+)['"].*?builder:.*?=>.*?([A-Za-z0-9_]+Screen)''',
        dotAll: true,
      );
      final matches = routeRegex.allMatches(content);
      for (final match in matches) {
        routes.add(NavigationRoute(match.group(1)!, match.group(2)!));
      }
    }
  }
}

class FeatureData {
  final String name;
  final List<ScreenData> screens = [];
  FeatureData(this.name);
}

class ScreenData {
  final String name;
  final String path;
  final Set<String> usedWidgets = {};
  final Set<String> outgoingRoutes = {};
  ScreenData(this.name, this.path);
}

class NavigationRoute {
  final String path;
  final String screen;
  NavigationRoute(this.path, this.screen);
}

class MapGenerator {
  final ArchitectureScanner scanner;
  MapGenerator(this.scanner);

  void generateMarkdown(String path) {
    final buffer = StringBuffer();
    buffer.writeln('# SiteBuddy Architecture Map');
    buffer.writeln('Generated on: ${DateTime.now().toIso8601String()}');
    buffer.writeln('\n## Feature Modules');

    scanner.features.forEach((name, data) {
      if (data.screens.isEmpty) return;
      buffer.writeln('\n### ${name.toUpperCase()}');
      for (final screen in data.screens) {
        buffer.writeln('- **${screen.name}**');
        if (screen.usedWidgets.isNotEmpty) {
          buffer.writeln(
            '  - Components: `${screen.usedWidgets.join("`, `")}`',
          );
        }
        if (screen.outgoingRoutes.isNotEmpty) {
          buffer.writeln(
            '  - Navigates to: ${screen.outgoingRoutes.map((r) => "`$r`").join(", ")}',
          );
        }
      }
    });

    buffer.writeln('\n## Router Entry Points');
    final uniqueRoutes = <String, String>{};
    for (final r in scanner.routes) {
      uniqueRoutes[r.path] = r.screen;
    }

    uniqueRoutes.forEach((path, screen) {
      buffer.writeln('- `$path` → **$screen**');
    });

    File(path).parent.createSync(recursive: true);
    File(path).writeAsStringSync(buffer.toString());
  }

  void generateDot(String path) {
    final buffer = StringBuffer();
    buffer.writeln('digraph SiteBuddy {');
    buffer.writeln('  rankdir=LR;');
    buffer.writeln(
      '  node [shape=box, style=filled, color="#E3F2FD", fontname="Arial"];',
    );
    buffer.writeln('  edge [color="#90CAF9"];');

    scanner.features.forEach((featName, data) {
      buffer.writeln('  subgraph cluster_$featName {');
      buffer.writeln('    label="$featName";');
      buffer.writeln('    style=filled;');
      buffer.writeln('    color="#F5F5F5";');
      for (final screen in data.screens) {
        buffer.writeln('    "${screen.name}";');
      }
      buffer.writeln('  }');
    });

    // Navigation Flow (DOT)
    for (final route in scanner.routes) {
      buffer.writeln(
        '    "ROOT" -> "${route.screen}" [label="${route.path}"];',
      );
    }

    buffer.writeln('}');
    File(path).parent.createSync(recursive: true);
    File(path).writeAsStringSync(buffer.toString());
  }

  void generateHtml(String path) {
    final buffer = StringBuffer();
    buffer.writeln('''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SiteBuddy Architecture Map</title>
    <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
    <script>
      mermaid.initialize({ 
        startOnLoad: true, 
        theme: 'base',
        themeVariables: {
          primaryColor: '#e3f2fd',
          primaryTextColor: '#2c3e50',
          secondaryColor: '#f5f5f5',
          lineColor: '#90caf9'
        },
        flowchart: { useMaxWidth: true, htmlLabels: true, curve: 'basis' }
      });
    </script>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; padding: 40px; background: #fafafa; color: #2c3e50; }
        .container { max-width: 1400px; margin: auto; background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
        h1 { margin-top: 0; font-weight: 700; border-bottom: 2px solid #eee; padding-bottom: 20px; }
        .stats { display: flex; gap: 20px; margin-bottom: 30px; }
        .stat-card { background: #eee; padding: 10px 20px; border-radius: 8px; font-size: 14px; }
        .mermaid { background: #fff; border: 1px solid #eee; border-radius: 8px; padding: 20px; overflow: auto; margin-bottom: 40px; }
        .legend { font-size: 12px; color: #666; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>SiteBuddy Architecture Map</h1>
        <div class="stats">
            <div class="stat-card"><b>Features:</b> ${scanner.features.length}</div>
            <div class="stat-card"><b>Screens:</b> ${scanner.features.values.fold(0, (prev, f) => prev + f.screens.length)}</div>
            <div class="stat-card"><b>Shared/Core Widgets:</b> ${scanner.sharedWidgets.length + scanner.coreWidgets.length}</div>
        </div>
        
        <h2>Module Hierarchy</h2>
        <div class="mermaid">
graph LR
''');

    // Features -> Screens
    scanner.features.forEach((featName, data) {
      if (data.screens.isEmpty) return;
      final cleanName = featName.replaceAll('_', ' ').toUpperCase();
      buffer.writeln('    subgraph "$cleanName"');
      for (final screen in data.screens) {
        buffer.writeln('    ${screen.name}');
      }
      buffer.writeln('    end');
    });

    buffer.writeln('''
        </div>

        <h2>Interactive Navigation Flow</h2>
        <div class="mermaid">
graph TD
    ROOT(("Start"))
''');

    // Navigation Flow
    final allScreens = scanner.features.values
        .expand((f) => f.screens)
        .map((s) => s.name)
        .toSet();
    final addedEdges = <String>{};

    for (final route in scanner.routes) {
      if (allScreens.contains(route.screen)) {
        final edge = 'ROOT --> ${route.screen}';
        if (!addedEdges.contains(edge)) {
          buffer.writeln('    $edge');
          addedEdges.add(edge);
        }
      }
    }

    // Connect screens based on context.push logic detected
    for (final feature in scanner.features.values) {
      for (final screen in feature.screens) {
        for (final targetRoute in screen.outgoingRoutes) {
          // Find screen for this route
          final targetScreen = scanner.routes
              .firstWhere(
                (r) =>
                    r.path == targetRoute ||
                    r.path == targetRoute.replaceAll('/', ''),
                orElse: () => NavigationRoute('', ''),
              )
              .screen;

          if (targetScreen.isNotEmpty && allScreens.contains(targetScreen)) {
            final edge = '${screen.name} --> $targetScreen';
            if (!addedEdges.contains(edge)) {
              buffer.writeln('    $edge');
              addedEdges.add(edge);
            }
          }
        }
      }
    }

    buffer.writeln('''
        </div>
        <div class="legend">Tip: You can zoom and pan using browser controls. Click and hold to drag if interactive mode is enabled.</div>
    </div>
</body>
</html>
''');
    File(path).parent.createSync(recursive: true);
    File(path).writeAsStringSync(buffer.toString());
  }
}
