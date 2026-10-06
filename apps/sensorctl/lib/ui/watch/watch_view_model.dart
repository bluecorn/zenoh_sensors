import 'package:riverpod/riverpod.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensorctl/config/providers.dart';

/// What `watch` shows: the latest reading, and how many there were.
class WatchState {
  /// A state with [latest] as the newest reading and [count] readings so far.
  const new({this.latest, this.count = 0});

  /// The newest reading, or null before the first.
  final Reading? latest;

  /// How many readings have arrived.
  final int count;
}

/// The view model behind `watch`, which keeps the latest reading and counts the
/// readings.
class WatchViewModel extends Notifier<WatchState> {
  @override
  WatchState build() {
    ref.listen(readingsProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        state = WatchState(latest: value, count: state.count + 1);
      }
    });
    return const WatchState();
  }
}

/// The view model of `watch`.
final watchViewModelProvider = NotifierProvider<WatchViewModel, WatchState>(
  WatchViewModel.new,
);
