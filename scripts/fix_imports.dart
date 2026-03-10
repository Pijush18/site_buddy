import 'dart:io';

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) return;

  int modifiedCount = 0;
  final entities = libDir.listSync(recursive: true);

  for (var entity in entities) {
    if (entity is File && entity.path.endsWith('.dart')) {
      if (processFile(entity)) {
        modifiedCount++;
        stdout.writeln('Modified: ${entity.path}');
      }
    }
  }
  stdout.writeln('\nTotal files modified: $modifiedCount');
}

bool processFile(File file) {
  final content = file.readAsStringSync();
  final lines = content.split('\n');
  bool changed = false;

  final newLines = lines.map((line) {
    var trimmed = line.trim();
    if ((trimmed.startsWith('import ') || trimmed.startsWith('export ')) &&
        trimmed.endsWith(';')) {
      // Find the path string between quotes
      String? path;
      String? quote;

      if (trimmed.contains("'")) {
        quote = "'";
      } else if (trimmed.contains('"')) {
        quote = '"';
      }

      if (quote != null) {
        final firstQuote = trimmed.indexOf(quote);
        final lastQuote = trimmed.lastIndexOf(quote);
        if (firstQuote != -1 && lastQuote != -1 && firstQuote != lastQuote) {
          path = trimmed.substring(firstQuote + 1, lastQuote);

          if (path.startsWith('./') || path.startsWith('../')) {
            // Resolve path
            final fileDir = file.parent.absolute.path;
            final absoluteImportPath = resolvePath(fileDir, path);

            final separator = Platform.pathSeparator;
            final libSearch = '${separator}lib$separator';
            final libIndex = absoluteImportPath.indexOf(libSearch);

            if (libIndex != -1) {
              final packageRelative = absoluteImportPath
                  .substring(libIndex + libSearch.length)
                  .replaceAll(separator, '/');
              final type = trimmed.startsWith('import') ? 'import' : 'export';
              final suffix = trimmed.substring(lastQuote + 1);
              final newLine =
                  "$type $quote"
                  "package:site_buddy/$packageRelative"
                  "$quote$suffix";

              changed = true;
              return line.replaceFirst(trimmed, newLine);
            }
          }
        }
      }
    }
    return line;
  }).toList();

  if (changed) {
    file.writeAsStringSync(newLines.join('\n'));
    return true;
  }
  return false;
}

String resolvePath(String base, String relative) {
  final baseUri = Uri.file(
    base.endsWith(Platform.pathSeparator)
        ? base
        : '$base${Platform.pathSeparator}',
  );
  return baseUri.resolve(relative).toFilePath();
}
