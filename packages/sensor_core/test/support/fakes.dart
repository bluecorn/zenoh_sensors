import 'dart:async';

import 'package:sensor_core/sensor_core.dart';

class FakeSensorService implements SensorService {
  new(this.readings, {this.gyroscope = const Stream.empty()});

  final Stream<Reading> readings;
  final Stream<Reading> gyroscope;

  @override
  Stream<Reading> accelerometer() => readings;
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

class FakeSubscription implements Subscription {
  new(this.keyExpr);

  final String keyExpr;
  final arrivals = StreamController<String>();
  bool isClosed = false;

  @override
  Stream<String> get payloads => arrivals.stream;

  @override
  void close() => isClosed = true;
}

class FakeZenohService implements ZenohService {
  final publications = <FakePublication>[];
  final subscriptions = <FakeSubscription>[];

  @override
  Publication declarePublication(String keyExpr) {
    final publication = FakePublication(keyExpr);
    publications.add(publication);
    return publication;
  }

  @override
  Subscription declareSubscription(String keyExpr) {
    final subscription = FakeSubscription(keyExpr);
    subscriptions.add(subscription);
    return subscription;
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
