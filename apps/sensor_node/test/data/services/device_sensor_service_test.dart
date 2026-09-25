import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_node/data/services/device_sensor_service.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  test('an accelerometer event becomes a reading, field for field', () async {
    // A stand-in for the plugin's function: one event, made by the test.
    final event = AccelerometerEvent(0.1, 9.8, 0.2, DateTime(2026, 9, 23, 12));
    final service = DeviceSensorService(
      events: ({samplingPeriod = SensorInterval.normalInterval}) =>
          Stream.value(event),
    );

    // The code to implement: each event mapped to a reading.
    final readings = await service.accelerometer().toList();

    // The claim: one reading, with the event's values on the three axes.
    final fields = readings.map((r) => (r.x, r.y, r.z)).toList();
    expect(fields, [(0.1, 9.8, 0.2)]);
  });
}
