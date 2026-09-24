import 'package:sensor_core/sensor_core.dart';
import 'package:test/test.dart';
import 'package:zenoh_dart/zenoh.dart';

import '../support/collector.dart';

void main() {
  test('a sensor node and a collector find each other on loopback', () async {
    // The two ends: the sensor node, which listens, and a collector,
    // which connects to it. Each closes when the test ends.
    final sensorNode = ZenohService(SessionSettings.sensorNode());
    final collectorNode = ZenohService(SessionSettings.collectorNode());
    addTearDown(sensorNode.dispose);
    addTearDown(collectorNode.dispose);

    // The code to implement: two sessions opened from the guide's settings.
    // The sensor node opens first, so the collector has something to reach.
    await sensorNode.open();
    await collectorNode.open();

    // The claim: each one's peers hold the other's identity, and the two
    // identities differ.
    expect(collectorNode.peerIds, contains(sensorNode.zid));
    expect(sensorNode.peerIds, contains(collectorNode.zid));
    expect(collectorNode.zid, isNot(sensorNode.zid));
  });

  test('a service has an identity once it is open', () async {
    // The sensor node's end, closed when the test ends.
    final sensorNode = ZenohService(SessionSettings.sensorNode());
    addTearDown(sensorNode.dispose);

    // The code to implement: an identity, once the service is open.
    await sensorNode.open();

    // The claim: the identity is not empty.
    expect(sensorNode.zid, isNotEmpty);
  });

  test('two services have different identities', () async {
    // Two ends, closed when the test ends.
    final sensorNode = ZenohService(SessionSettings.sensorNode());
    final collectorNode = ZenohService(SessionSettings.collectorNode());
    addTearDown(sensorNode.dispose);
    addTearDown(collectorNode.dispose);

    // The code to implement: each open service gets its own identity.
    await sensorNode.open();
    await collectorNode.open();

    // The claim: the two identities differ.
    expect(collectorNode.zid, isNot(sensorNode.zid));
  });

  test('neither side announces itself on the network', () {
    // The code to implement: both sides' settings, read back as data. An
    // absence cannot be watched, so it is checked as the value behind it.
    final sensorSettings = SessionSettings.sensorNode().asJson5;
    final collectorSettings = SessionSettings.collectorNode().asJson5;

    // The claim: every session is a peer that neither scouts nor gossips.
    for (final settings in [sensorSettings, collectorSettings]) {
      expect(settings, containsPair('mode', '"peer"'));
      expect(settings, containsPair('scouting/multicast/enabled', 'false'));
      expect(settings, containsPair('scouting/gossip/enabled', 'false'));
    }
  });

  test('the collector connects to where the sensor node listens', () {
    // The code to implement: the endpoints, read back as data.
    const address = '["tcp/127.0.0.1:7447"]';
    final sensorSettings = SessionSettings.sensorNode().asJson5;
    final collectorSettings = SessionSettings.collectorNode().asJson5;

    // The claim: the sensor node listens at the address and connects to
    // nothing, and the collector listens nowhere and connects to it.
    expect(sensorSettings, containsPair('listen/endpoints', address));
    expect(sensorSettings, containsPair('connect/endpoints', '[]'));
    expect(collectorSettings, containsPair('listen/endpoints', '[]'));
    expect(collectorSettings, containsPair('connect/endpoints', address));
  });

  test('a collector opens even when no sensor node is listening', () async {
    // A collector alone: nothing listens at its address.
    final collectorNode = ZenohService(SessionSettings.collectorNode());
    addTearDown(collectorNode.dispose);

    await collectorNode.open();

    // The claim: the session opens, and finds no one.
    expect(collectorNode.peerIds, isEmpty);
  });

  test('disposing is safe before open, and more than once after', () async {
    // A rule of the pattern: disposing never throws, whatever the state.
    final sensorNode = ZenohService(SessionSettings.sensorNode());
    expect(sensorNode.dispose, returnsNormally);

    await sensorNode.open();
    sensorNode.dispose();

    // The claim: a second dispose after open is safe too.
    expect(sensorNode.dispose, returnsNormally);
  });

  test('asking an unopened service for its identity is an error', () {
    // A rule of the pattern: an unopened service has no identity to give.
    final sensorNode = ZenohService(SessionSettings.sensorNode());

    // The claim: asking throws a StateError.
    expect(() => sensorNode.zid, throwsStateError);
  });

  test('a put through a publication reaches a subscriber as text', () async {
    // The node's end: its session, from the settings that listen.
    final sensorNode = ZenohService(SessionSettings.sensorNode());
    addTearDown(sensorNode.dispose);
    await sensorNode.open();

    // The laptop's end: a plain session that subscribes, as z_sub does.
    final collector = await openCollector();
    addTearDown(collector.close);
    final subscriber = collector.declareSubscriber('sensor/phone/accel');
    addTearDown(subscriber.close);
    final received = <Sample>[];
    subscriber.stream.listen(received.add);

    // The new contract to implement: declare a publication on a key,
    // then put text through it.
    sensorNode
        .declarePublication('sensor/phone/accel')
        .put('0.000,9.776,0.812');
    // A put returns before the sample arrives, so give it time to cross.
    await Future<void>.delayed(delivery);

    // The claim: the text arrives, marked text/plain.
    final payloads = received.map((sample) => sample.payload).toList();
    expect(payloads, ['0.000,9.776,0.812']);
    expect(received.single.encoding, 'text/plain');
  });
}
