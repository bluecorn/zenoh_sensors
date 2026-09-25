import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_node/ui/node/node_screen.dart';
import 'package:sensor_node/ui/node/node_view_model.dart';

import '../../support/fakes.dart';

void main() {
  testWidgets('the screen shows the latest reading and the count', (
    tester,
  ) async {
    // Stand-in: a view model that holds a fixed state.
    final container = ProviderContainer.test(
      overrides: [
        nodeViewModelProvider.overrideWith(
          () => FakeNodeViewModel(const NodeState(latest: aReading, count: 42)),
        ),
      ],
    );

    // The code to implement: the screen, built once from that state.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: NodeScreen()),
      ),
    );

    // The claim: the reading to three decimals, and the count.
    expect(find.text('x 0.100'), findsOneWidget);
    expect(find.text('y 9.776'), findsOneWidget);
    expect(find.text('z 0.812'), findsOneWidget);
    expect(find.text('42 readings'), findsOneWidget);
  });
}
