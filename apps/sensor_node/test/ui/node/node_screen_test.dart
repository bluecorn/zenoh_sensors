import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensor_node/ui/node/node_screen.dart';
import 'package:sensor_node/ui/node/node_view_model.dart';

import '../../support/fakes.dart';

void main() {
  testWidgets('the screen shows a block for each key', (tester) async {
    // A fake: a view model that holds a fixed state, with a reading and a
    // count on each of the phone's two keys.
    const accel = Reading(x: 0.1, y: 9.776, z: 0.812);
    const gyro = Reading(x: 0, y: 0, z: 0.5);
    final container = ProviderContainer.test(
      overrides: [
        nodeViewModelProvider.overrideWith(
          () => FakeNodeViewModel(
            const NodeState(
              sensors: {
                'sensor/phone/accel': SensorState(latest: accel, count: 42),
                'sensor/phone/gyro': SensorState(latest: gyro, count: 7),
              },
            ),
          ),
        ),
      ],
    );

    // The code to implement: the screen, built once from that state, with a
    // block for each key.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: NodeScreen()),
      ),
    );

    // The claim: each key, its reading to three decimals, and its count.
    expect(find.text('sensor/phone/accel'), findsOneWidget);
    expect(find.text('x 0.100'), findsOneWidget);
    expect(find.text('y 9.776'), findsOneWidget);
    expect(find.text('z 0.812'), findsOneWidget);
    expect(find.text('42 readings'), findsOneWidget);
    expect(find.text('sensor/phone/gyro'), findsOneWidget);
    expect(find.text('x 0.000'), findsOneWidget);
    expect(find.text('y 0.000'), findsOneWidget);
    expect(find.text('z 0.500'), findsOneWidget);
    expect(find.text('7 readings'), findsOneWidget);
  });
}
