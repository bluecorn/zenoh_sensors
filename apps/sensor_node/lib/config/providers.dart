import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensor_node/data/services/device_sensor_service.dart';

/// Which side of the topology this app is on: the sensor node.
final sessionSettingsProvider = Provider<SessionSettings>(
  (ref) => SessionSettings.sensorNode(),
);

/// The app's one zenoh session, disposed with the container.
final zenohServiceProvider = Provider<ZenohService>((ref) {
  final service = ZenohService(ref.watch(sessionSettingsProvider));
  ref.onDispose(service.dispose);
  return service;
});

/// The device's sensors, behind the interface the core defines.
final sensorServiceProvider = Provider<SensorService>(
  (ref) => DeviceSensorService(),
);

/// The node's repository: this phone's readings, on `sensor/phone/accel`.
final sensorNodeRepositoryProvider = Provider<SensorNodeRepository>(
  (ref) => SensorNodeRepository(
    ref.watch(zenohServiceProvider),
    ref.watch(sensorServiceProvider),
    nodeName: 'phone',
  ),
);

/// The session, opened once; what depends on it waits for this.
final sessionProvider = FutureProvider<void>(
  (ref) => ref.watch(zenohServiceProvider).open(),
);

/// The readings the node publishes, once the session is open.
final readingsProvider = StreamProvider<Reading>((ref) async* {
  await ref.watch(sessionProvider.future);
  yield* ref.watch(sensorNodeRepositoryProvider).publish();
});
