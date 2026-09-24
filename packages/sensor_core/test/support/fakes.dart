import 'package:sensor_core/sensor_core.dart';

class FakeSensorService implements SensorService {
  new(this.readings);

  final Stream<Reading> readings;

  @override
  Stream<Reading> accelerometer({
    Duration samplingPeriod = const Duration(milliseconds: 200),
  }) => readings;
}

class FakePublication implements Publication {
  new(this.keyExpr);

  final String keyExpr;
  final puts = <String>[];
  bool isClosed = false;

  @override
  void put(String text) => puts.add(text);

  @override
  void close() => isClosed = true;
}

class FakeZenohService implements ZenohService {
  final publications = <FakePublication>[];

  @override
  Publication declarePublication(String keyExpr) {
    final publication = FakePublication(keyExpr);
    publications.add(publication);
    return publication;
  }

  @override
  SessionSettings get settings => SessionSettings.sensorNode();

  @override
  Future<void> open() async {}

  @override
  String get zid => 'a-fake';

  @override
  List<String> get peerIds => const [];

  @override
  void dispose() {}
}
