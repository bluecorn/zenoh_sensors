import 'package:sensor_core/sensor_core.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// The shape of the plugin's accelerometer function, so that a test can hand
/// in another.
typedef AccelerometerEvents = Stream<AccelerometerEvent> Function({
  Duration samplingPeriod,
});

/// The device's sensors, read through `sensors_plus`.
class DeviceSensorService implements SensorService {
  /// A service over the plugin's accelerometer, or over what a test hands in.
  new({this._events = accelerometerEventStream});

  final AccelerometerEvents _events;

  @override
  Stream<Reading> accelerometer({
    Duration samplingPeriod = const Duration(milliseconds: 200),
  }) =>
      _events(samplingPeriod: samplingPeriod)
          .map((event) => Reading(x: event.x, y: event.y, z: event.z));
}
