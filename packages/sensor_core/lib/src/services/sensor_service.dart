import 'package:sensor_core/src/domain/reading.dart';

/// The device's motion sensors, as the node reads them.
///
/// The accelerometer reports metres per second squared on three axes, gravity
/// included, so a device lying flat on its back reads about 9.81 on z. The
/// axes are the device's own: x to the right, y towards the top of the screen,
/// z out of the screen. The sampling period is a request, not a promise: the
/// device delivers at the fastest rate any program on it has asked for.
abstract interface class SensorService {
  /// The accelerometer's readings, asked for one every [samplingPeriod]; the
  /// device may deliver them more often.
  Stream<Reading> accelerometer({
    Duration samplingPeriod = const Duration(milliseconds: 200),
  });
}
