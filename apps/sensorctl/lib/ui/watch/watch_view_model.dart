import 'package:sensor_core/sensor_core.dart';

/// What `watch` shows: the latest reading, and how many there were.
class WatchState {
  /// A state with [latest] as the newest reading and [count] readings so far.
  const new({this.latest, this.count = 0});

  /// The newest reading, or null before the first.
  final Reading? latest;

  /// How many readings have arrived.
  final int count;
}
