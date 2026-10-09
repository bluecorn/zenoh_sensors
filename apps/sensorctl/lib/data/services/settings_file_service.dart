import 'dart:io';

import 'package:sensor_core/sensor_core.dart';

/// Reads a session's settings from a zenoh configuration file: the file
/// `--config` names, or the development file sensorctl ships.
class SettingsFileService {
  /// The settings in the file at [path]. A relative path starts at the folder
  /// the program runs in.
  SessionSettings read(String path) =>
      SessionSettings(File(path).readAsStringSync());
}
