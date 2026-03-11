import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:watcher/watcher.dart';

Future<void> main() async {
  final watcher = DirectoryWatcher('bin');
  Process? serverProcess;

  Future<void> startServer() async {
    serverProcess = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': '3000'},
    );
    serverProcess?.stdout.transform(utf8.decoder).listen((data) {
      print(data);
    });
    serverProcess?.stderr.transform(utf8.decoder).listen((data) {
      print(data);
    });
  }

  Future<void> restartServer() async {
    if (serverProcess != null) {
      serverProcess?.kill();
      serverProcess = null;
    }
    await startServer();
  }

  watcher.events.listen((event) async {
    print('File change detected: ${event.path}');
    await restartServer();
  });

  // Start the server initially
  await startServer();
}