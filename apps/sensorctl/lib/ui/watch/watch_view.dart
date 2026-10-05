import 'package:sensorctl/ui/watch/watch_view_model.dart';

/// The line `watch` shows for [state]: the latest reading, each value to three
/// decimals, and the count.
String watchLine(WatchState state) => switch (state.latest) {
  null => 'no readings yet',
  final latest =>
    'x ${_fixed(latest.x)}  y ${_fixed(latest.y)}  '
        'z ${_fixed(latest.z)}  ${state.count} readings',
};

/// [value] to three decimals, seven characters wide, so that the columns stay
/// in place when a value turns negative.
String _fixed(double value) => value.toStringAsFixed(3).padLeft(7);
