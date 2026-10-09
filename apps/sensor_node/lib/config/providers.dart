import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensor_node/data/services/device_sensor_service.dart';

/// Which side of the topology this app is on: the sensor node, which listens
/// on the loopback and connects nowhere.
final sessionSettingsProvider = Provider<SessionSettings>(
  (ref) => const SessionSettings('''
{
  mode: "peer",
  scouting: {
    multicast: { enabled: false },
    gossip: { enabled: false },
  },
  listen: { endpoints: ["tcp/127.0.0.1:7447"] },
}
'''),
);

/// The app's one zenoh service, disposed with the container.
final zenohServiceProvider = Provider<ZenohService>((ref) {
  final service = ZenohService(ref.watch(sessionSettingsProvider));
  ref.onDispose(service.dispose);
  return service;
});

/// The device's sensors, behind the interface the core defines.
final sensorServiceProvider = Provider<SensorService>(
  (ref) => DeviceSensorService(),
);

/// The node's repository: this phone's sensors, each on its own key.
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

/// The readings the node publishes, each with its key, once the session is
/// open.
final readingsProvider = StreamProvider<KeyedReading>((ref) async* {
  await ref.watch(sessionProvider.future);
  yield* ref.watch(sensorNodeRepositoryProvider).publish();
});
