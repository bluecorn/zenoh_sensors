import 'package:sensor_core/sensor_core.dart';
import 'package:zenoh_dart/zenoh.dart';

/// A collector opened with the package directly, as `z_sub` is on the laptop.
/// There is no collector-side service until chapter 3.
Future<Session> openCollector() {
  final config = Config();
  SessionSettings.collectorNode().asJson5.forEach(config.insertJson5);
  return Session.open(config: config);
}

/// Long enough for a sample, or a declaration, to cross the loopback, which
/// takes milliseconds.
const delivery = Duration(milliseconds: 500);
