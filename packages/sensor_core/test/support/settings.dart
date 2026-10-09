import 'dart:io';

import 'package:sensor_core/sensor_core.dart';

/// The sensor node's settings, read from its file, as the app reads its own.
SessionSettings sensorNodeSettings() => _read('sensor_node');

/// A collector's settings, read from its file, as sensorctl reads its own.
SessionSettings collectorSettings() => _read('collector');

/// The file called [name] under the core's test configuration. The path is
/// from the top folder, where the tests run.
SessionSettings _read(String name) => SessionSettings(
  File('packages/sensor_core/test/config/$name.json5').readAsStringSync(),
);
