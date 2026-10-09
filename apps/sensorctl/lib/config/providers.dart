import 'package:riverpod/riverpod.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensorctl/data/services/settings_file_service.dart';

/// The path of the session's configuration file, from the top folder: the
/// development file, unless `--config` names another.
final configPathProvider = Provider<String>(
  (ref) => 'apps/sensorctl/config/development.json5',
);

/// The service that reads the configuration file.
final settingsFileServiceProvider = Provider<SettingsFileService>(
  (ref) => SettingsFileService(),
);

/// Which side of the topology this program is on, as its configuration file
/// says.
final sessionSettingsProvider = Provider<SessionSettings>(
  (ref) => ref
      .watch(settingsFileServiceProvider)
      .read(ref.watch(configPathProvider)),
);

/// The program's one zenoh service, disposed with the container.
final zenohServiceProvider = Provider<ZenohService>((ref) {
  final service = ZenohService(ref.watch(sessionSettingsProvider));
  ref.onDispose(service.dispose);
  return service;
});

/// The collector's repository: the phone's readings, on `sensor/phone/*`.
final readingsRepositoryProvider = Provider<ReadingsRepository>(
  (ref) =>
      ReadingsRepository(ref.watch(zenohServiceProvider), nodeName: 'phone'),
);

/// The session, opened once; what depends on it waits for this.
final sessionProvider = FutureProvider<void>(
  (ref) => ref.watch(zenohServiceProvider).open(),
);

/// The readings that arrive, each with its key, once the session is open.
final readingsProvider = StreamProvider<KeyedReading>((ref) async* {
  await ref.watch(sessionProvider.future);
  yield* ref.watch(readingsRepositoryProvider).readings();
});
