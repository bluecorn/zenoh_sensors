import 'package:sensor_core/src/domain/reading.dart';

/// The device's motion sensors, as the node reads them.
///
/// The accelerometer reports meters per second squared on three axes, gravity
/// included, so a device lying flat on its back reads about 9.81 on z. The
/// axes are the device's own: x to the right, y towards the top of the screen,
/// z out of the screen.
abstract interface class SensorService {
  /// The accelerometer's readings, as the device delivers them.
  Stream<Reading> accelerometer();
}
