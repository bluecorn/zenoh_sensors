import 'dart:async';

import 'package:sensor_core/src/domain/reading.dart';
import 'package:sensor_core/src/services/sensor_service.dart';
import 'package:sensor_core/src/services/zenoh_service.dart';

/// The node's side of the readings: it owns the key expression and publishes
/// what the sensor delivers.
class SensorNodeRepository {
  /// A repository publishing [sensor]'s readings through [zenoh], on the key
  /// expression of the node called [nodeName].
  new(this.zenoh, this.sensor, {required String nodeName})
    : keyExpr = 'sensor/$nodeName/accel';

  /// The service the readings are published through.
  final ZenohService zenoh;

  /// The sensor the readings come from.
  final SensorService sensor;

  /// The key expression the readings are published on.
  final String keyExpr;

  /// Publishes every reading as `x,y,z` to three decimals, and hands each on.
  /// Listening declares the publication; cancelling closes it.
  Stream<Reading> publish() {
    late final Publication publication;
    late final StreamSubscription<Reading> readings;
    final controller = StreamController<Reading>();
    controller.onListen = () {
      publication = zenoh.declarePublication(keyExpr);
      readings = sensor.accelerometer().listen((reading) {
        publication.put(_asText(reading));
        controller.add(reading);
      }, onDone: controller.close);
    };
    controller.onCancel = () async {
      await readings.cancel();
      publication.close();
    };
    return controller.stream;
  }

  static String _asText(Reading reading) {
    final x = reading.x.toStringAsFixed(3);
    final y = reading.y.toStringAsFixed(3);
    final z = reading.z.toStringAsFixed(3);
    return '$x,$y,$z';
  }
}
