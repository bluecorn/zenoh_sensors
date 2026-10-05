import 'package:sensor_core/src/domain/reading.dart';
import 'package:sensor_core/src/services/zenoh_service.dart';

/// The collector's side of the readings: it owns the key expression and turns
/// what arrives back into readings.
class ReadingsRepository {
  /// A repository receiving, through [zenoh], the readings of the node called
  /// [nodeName].
  new(this.zenoh, {required this.nodeName});

  /// The service the readings arrive through.
  final ZenohService zenoh;

  /// The node's name, the middle segment of its key expressions.
  final String nodeName;

  /// The readings that arrive from the node.
  Stream<Reading> readings() => const Stream.empty();
}
