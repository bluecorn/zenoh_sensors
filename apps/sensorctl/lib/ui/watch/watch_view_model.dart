import 'package:riverpod/riverpod.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensorctl/config/providers.dart';

/// What `watch` shows for one key: the latest reading on it, and how many
/// there were.
class SensorState {
  /// A state with [latest] as the newest reading and [count] readings so far.
  const new({required this.latest, required this.count});

  /// The newest reading on the key.
  final Reading latest;

  /// How many readings have arrived on the key.
  final int count;
}

/// What `watch` shows: the state of each key.
class WatchState {
  /// A state with [sensors] as the state of each key.
  const new({this.sensors = const {}});

  /// The state of each key a reading has arrived on, in the order the keys
  /// first arrived.
  final Map<String, SensorState> sensors;
}

/// The view model behind `watch`, which keeps the latest reading and counts the
/// readings, for each key.
class WatchViewModel extends Notifier<WatchState> {
  @override
  WatchState build() {
    ref.listen(readingsProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        final (:keyExpr, :reading) = value;
        final count = state.sensors[keyExpr]?.count ?? 0;
        state = WatchState(
          sensors: {
            ...state.sensors,
            keyExpr: SensorState(latest: reading, count: count + 1),
          },
        );
      }
    });
    return const WatchState();
  }
}

/// The view model of `watch`.
final watchViewModelProvider = NotifierProvider<WatchViewModel, WatchState>(
  WatchViewModel.new,
);
