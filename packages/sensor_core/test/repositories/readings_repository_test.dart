import 'package:sensor_core/sensor_core.dart';
import 'package:test/test.dart';

import '../support/collector.dart';
import '../support/fakes.dart';

void main() {
  test('a reading the phone publishes reaches the collector', () async {
    // The node's end: its session, from the settings that listen.
    final sensorNode = ZenohService(SessionSettings.sensorNode());
    addTearDown(sensorNode.dispose);
    await sensorNode.open();

    // The laptop's end: a collector's session, from the settings that
    // connect.
    final collectorNode = ZenohService(SessionSettings.collectorNode());
    addTearDown(collectorNode.dispose);
    await collectorNode.open();

    // The code to implement: a repository that receives the phone's
    // readings, collected into a list.
    final repository = ReadingsRepository(collectorNode, nodeName: 'phone');
    final received = <Reading>[];
    final listening = repository.readings().listen(received.add);
    addTearDown(listening.cancel);
    // The declaration travels to the node, so give it time to arrive.
    await Future<void>.delayed(delivery);

    // The node's code publishes one reading from a fake sensor.
    const reading = Reading(x: 0, y: 9.776, z: 0.812);
    final sensor = FakeSensorService(Stream.value(reading));
    final node = SensorNodeRepository(sensorNode, sensor, nodeName: 'phone');
    await node.publish().toList();
    // A put returns before the sample arrives, so give it time to cross.
    await Future<void>.delayed(delivery);

    // The claim: one reading arrives, with the three values it left with.
    final values = received.map((r) => [r.x, r.y, r.z]).toList();
    expect(values, [
      [0, 9.776, 0.812],
    ]);
  });
}
