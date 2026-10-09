import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensorctl/ui/watch/watch_command.dart';

Future<void> main(List<String> arguments) async {
  initZenohLogging('error');

  final runner = CommandRunner<void>(
    'sensorctl',
    'Watch, query and command the zenoh sensor network from a terminal.',
  )..addCommand(WatchCommand());
  runner.argParser.addOption(
    'config',
    help:
        'The zenoh configuration file of the session, in place of the '
        'development file.',
    valueHelp: 'path',
  );
  try {
    await runner.run(arguments);
  } on UsageException catch (error) {
    stderr.writeln(error);
    exitCode = 64;
  }
}
