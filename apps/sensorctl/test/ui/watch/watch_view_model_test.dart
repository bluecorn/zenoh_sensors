import 'package:riverpod/riverpod.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensorctl/config/providers.dart';
import 'package:sensorctl/ui/watch/watch_view_model.dart';
import 'package:test/test.dart';

void main() {
  test('the view model keeps the latest reading and counts them', () async {
    // A fake: the readings provider, overridden with two readings, so
    // nothing below the view model is built.
    const first = Reading(x: 0, y: 9.776, z: 0.812);
    const second = Reading(x: 0, y: 0, z: 9.81);
    final container = ProviderContainer.test(
      overrides: [
        readingsProvider.overrideWith(
          (ref) => Stream.fromIterable([first, second]),
        ),
      ],
    )..listen(watchViewModelProvider, (_, _) {});

    // Let both readings flow through before reading the state.
    await pumpEventQueue();

    // The code to implement: the view model's state, built from the
    // readings it heard.
    final state = container.read(watchViewModelProvider);

    // The claim: two readings counted, and the second one kept.
    expect(state.count, 2);
    expect(state.latest, second);
  });
}
