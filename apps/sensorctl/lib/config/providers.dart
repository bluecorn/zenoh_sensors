import 'package:riverpod/riverpod.dart';
import 'package:sensor_core/sensor_core.dart';

final sessionSettingsProvider = Provider<SessionSettings>(
  (ref) => SessionSettings.collectorNode(),
);

final zenohServiceProvider = Provider<ZenohService>((ref) {
  final service = ZenohService(ref.watch(sessionSettingsProvider));
  ref.onDispose(service.dispose);
  return service;
});
