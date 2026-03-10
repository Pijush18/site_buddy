import 'dart:io';

Future<void> main() async {
  print('Running SiteBuddy Project Guardian...');

  try {
    await runTool('dart', ['tools/ui_police/ui_police.dart']);
    await runTool('dart', ['tools/architecture_guard/architecture_guard.dart']);
    await runTool('dart', ['tools/ui_autofix/ui_autofix.dart', '--dry-run']);

    print('\n✅ All governance checks completed successfully.');
  } catch (e) {
    print('\n❌ Project Guardian failed: $e');
    exit(1);
  }
}

Future<void> runTool(String command, List<String> args) async {
  print('-> Executing: $command ${args.join(" ")}');
  final process = await Process.start(command, args);

  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  final exitCode = await process.exitCode;

  if (exitCode != 0) {
    throw Exception('Tool failed with exit code $exitCode');
  }
}
