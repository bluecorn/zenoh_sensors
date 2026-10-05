import 'dart:async';

import 'package:sensor_core/src/domain/reading.dart';
import 'package:sensor_core/src/services/zenoh_service.dart';

/// The collector's side of the readings: it owns the key expression and turns
/// what arrives back into readings.
class ReadingsRepository {
  /// A repository receiving, through [zenoh], the readings of the node called
  /// [nodeName].
  new(this.zenoh, {required String nodeName})
    : keyExpr = 'sensor/$nodeName/accel';

  /// The service the readings arrive through.
  final ZenohService zenoh;

  /// The key expression the readings arrive on.
  final String keyExpr;

  /// Every reading that arrives, parsed from `x,y,z`. Listening declares the
  /// subscription; cancelling closes it.
  Stream<Reading> readings() {
    late final Subscription subscription;
    late final StreamSubscription<String> listening;
    final controller = StreamController<Reading>();
    controller.onListen = () {
      subscription = zenoh.declareSubscription(keyExpr);
      listening = subscription.payloads.listen(
        (text) => controller.add(_asReading(text)),
      );
    };
    controller.onCancel = () async {
      await listening.cancel();
      subscription.close();
    };
    return controller.stream;
  }

  static Reading _asReading(String text) {
    final [x, y, z] = text.split(',').map(double.parse).toList();
    return Reading(x: x, y: y, z: z);
  }
}
