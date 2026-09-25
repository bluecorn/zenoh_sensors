import 'dart:async';

import 'package:sensor_core/sensor_core.dart';
import 'package:test/test.dart';
import 'package:zenoh_dart/zenoh.dart';

import '../support/collector.dart';
import '../support/fakes.dart';

void main() {
  test('a sensor reading reaches a subscriber on sensor/phone/accel', () async {
    // The node's end: its session, from the settings that listen.
    final zenoh = ZenohService(SessionSettings.sensorNode());
    addTearDown(zenoh.dispose);
    await zenoh.open();

    // The laptop's end: a witness that subscribes and keeps what arrives, as
    // z_sub does. A plain session, because ZenohService cannot subscribe yet.
    final collector = await openCollector();
    addTearDown(collector.close);
    final subscriber = collector.declareSubscriber('sensor/**');
    addTearDown(subscriber.close);
    final received = <Sample>[];
    subscriber.stream.listen(received.add);

    // The code to implement: a repository that publishes one reading
    // from a stand-in sensor, through the node's session.
    const reading = Reading(x: 0, y: 9.776, z: 0.812);
    final sensor = FakeSensorService(Stream.value(reading));
    final repository = SensorNodeRepository(zenoh, sensor, nodeName: 'phone');
    final published = await repository.publish().toList();
    // A put returns before the sample arrives, so give it time to cross.
    await Future<void>.delayed(delivery);

    // The claim: one sample, on the exact key, as text, marked text/plain,
    // and the reading handed on for the screen.
    final keys = received.map((sample) => sample.keyExpr).toList();
    expect(keys, ['sensor/phone/accel']);
    expect(received.single.payload, '0.000,9.776,0.812');
    expect(received.single.encoding, 'text/plain');
    expect(published, [reading]);
  });

  test('the phone publishes on sensor/phone/accel', () async {
    // Stand-ins: a service that records what is declared on it, and a
    // sensor with nothing to deliver.
    final zenoh = FakeZenohService();
    final sensor = FakeSensorService(const Stream.empty());

    // The code to implement: the repository declares its publication.
    final repository = SensorNodeRepository(zenoh, sensor, nodeName: 'phone');
    await repository.publish().toList();

    // The claim: one publication, on the phone's key.
    final keys = zenoh.publications.map((p) => p.keyExpr).toList();
    expect(keys, ['sensor/phone/accel']);
  });

  test('a node named sim publishes on sensor/sim/accel', () async {
    // Stand-ins: a service that records what is declared on it, and a
    // sensor with nothing to deliver.
    final zenoh = FakeZenohService();
    final sensor = FakeSensorService(const Stream.empty());

    // The code to implement: the key built from the node's name.
    final repository = SensorNodeRepository(zenoh, sensor, nodeName: 'sim');
    await repository.publish().toList();

    // The claim: one publication, on the sim node's key.
    final keys = zenoh.publications.map((p) => p.keyExpr).toList();
    expect(keys, ['sensor/sim/accel']);
  });

  test('a reading is put as x,y,z to three decimals and handed on', () async {
    // Stand-ins: a service that records what is put through it, and a
    // sensor that delivers one reading.
    final zenoh = FakeZenohService();
    const reading = Reading(x: 0, y: 9.776, z: 0.812);
    final sensor = FakeSensorService(Stream.value(reading));

    // The code to implement: each reading put as text, then handed on.
    final repository = SensorNodeRepository(zenoh, sensor, nodeName: 'phone');
    final published = await repository.publish().toList();

    // The claim: the text put through the publication, and the same reading
    // handed on.
    expect(zenoh.publications.single.puts, ['0.000,9.776,0.812']);
    expect(published, [reading]);
  });

  test('cancelling the stream closes the publication', () async {
    // Stand-ins: a service that records what is closed, and a sensor that
    // stays quiet, as a real one does between readings.
    final zenoh = FakeZenohService();
    final readings = StreamController<Reading>();
    final sensor = FakeSensorService(readings.stream);
    final repository = SensorNodeRepository(zenoh, sensor, nodeName: 'phone');

    // The code to implement: a cancel that closes the publication, even
    // while the sensor is quiet.
    final subscription = repository.publish().listen((_) {});
    await subscription.cancel();

    // The claim: the publication the repository declared is closed.
    expect(zenoh.publications.single.isClosed, isTrue);
  });
}
