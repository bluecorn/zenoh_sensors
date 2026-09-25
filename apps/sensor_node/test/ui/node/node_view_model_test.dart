import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensor_node/config/providers.dart';
import 'package:sensor_node/ui/node/node_view_model.dart';

void main() {
  test('the view model keeps the latest reading and counts them', () async {
    // Stand-in: the readings provider, overridden with two readings, so
    // nothing below the view model is built.
    const first = Reading(x: 0, y: 9.776, z: 0.812);
    const second = Reading(x: 0, y: 0, z: 9.81);
    final container = ProviderContainer.test(
      overrides: [
        readingsProvider.overrideWith(
          (ref) => Stream.fromIterable([first, second]),
        ),
      ],
    )..listen(nodeViewModelProvider, (_, _) {});

    // Let both readings flow through before reading the state.
    await pumpEventQueue();

    // The code to implement: the view model's state, built from the
    // readings it heard.
    final state = container.read(nodeViewModelProvider);

    // The claim: two readings counted, and the second one kept.
    expect(state.count, 2);
    expect(state.latest, second);
  });
}
