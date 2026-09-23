import 'dart:io';

import 'package:riverpod/riverpod.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensorctl/config/providers.dart';

Future<void> main() async {
  initZenohLogging('error');

  final container = ProviderContainer();
  try {
    final service = container.read(zenohServiceProvider);
    await service.open();
    stdout.writeln('sensorctl is ${service.zid}');
    final peers = service.peerIds;
    final noun = peers.length == 1 ? 'peer' : 'peers';
    stdout.writeln('connected to ${peers.length} $noun:');
    for (final peer in peers) {
      stdout.writeln('  $peer');
    }
  } finally {
    container.dispose();
  }
}
