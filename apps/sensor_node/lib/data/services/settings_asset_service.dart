import 'package:flutter/services.dart';
import 'package:sensor_core/sensor_core.dart';

/// Reads a session's settings from a zenoh configuration file the app ships
/// as an asset under `config/`: the file the build names, or the development
/// file.
class SettingsAssetService {
  /// A service over the app's asset bundle, or over the bundle a test hands
  /// in.
  new({AssetBundle? bundle}) : bundle = bundle ?? rootBundle;

  /// The bundle the assets are read from.
  final AssetBundle bundle;

  /// The settings in the asset `config/<name>.json5`.
  Future<SessionSettings> read(String name) async =>
      SessionSettings(await bundle.loadString('config/$name.json5'));
}
