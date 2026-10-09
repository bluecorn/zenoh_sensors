import 'dart:io';

import 'package:riverpod/riverpod.dart';
import 'package:sensorctl/config/providers.dart';
import 'package:sensorctl/data/services/settings_file_service.dart';
import 'package:test/test.dart';
import 'package:zenoh_dart/zenoh.dart';

void main() {
  test('the development file is a peer that connects to the sensor node', () {
    // The file the program reads with no --config, read as the program reads
    // it and parsed by zenoh.
    final path = ProviderContainer.test().read(configPathProvider);
    final config = Config.fromStr(SettingsFileService().read(path).json5);
    addTearDown(config.dispose);

    // The claim: a peer, which connects to the sensor node on the loopback.
    expect(config.get('mode'), '"peer"');
    expect(config.get('connect/endpoints'), '["tcp/127.0.0.1:7447"]');
  });

  test('every file sensorctl ships is a configuration zenoh accepts', () {
    // The files in the folder the program ships, each read as the program
    // reads it. A folder with no file would pass for the wrong reason.
    final files = Directory('apps/sensorctl/config')
        .listSync()
        .whereType<File>();
    expect(files, isNotEmpty);

    // The claim: zenoh parses each one. A failure names its file.
    for (final file in files) {
      final settings = SettingsFileService().read(file.path);
      expect(
        () => Config.fromStr(settings.json5).dispose(),
        returnsNormally,
        reason: file.path,
      );
    }
  });
}
