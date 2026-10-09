import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_node/config/providers.dart';
import 'package:zenoh_dart/zenoh.dart';

void main() {
  test(
    'each file the app ships is accepted, and development listens on loopback',
    () {
      // The files in the folder the app ships, read from disk, because a test
      // run from the top folder has no asset bundle of the app. A folder with
      // no file would pass for the wrong reason.
      final folder = Directory('apps/sensor_node/config');
      final files = folder.listSync().whereType<File>();
      expect(files, isNotEmpty);

      // The claim: zenoh parses each one. A failure names its file.
      for (final file in files) {
        expect(
          () => Config.fromStr(file.readAsStringSync()).dispose(),
          returnsNormally,
          reason: file.path,
        );
      }

      // The file the app reads with no define, parsed by zenoh.
      final name = ProviderContainer.test().read(configNameProvider);
      final text = File('${folder.path}/$name.json5').readAsStringSync();
      final config = Config.fromStr(text);
      addTearDown(config.dispose);

      // The claim: a peer, which listens on the loopback.
      expect(config.get('mode'), '"peer"');
      expect(config.get('listen/endpoints'), '["tcp/127.0.0.1:7447"]');
    },
  );
}
