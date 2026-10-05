import 'package:sensor_core/sensor_core.dart';
import 'package:sensorctl/ui/watch/watch_view.dart';
import 'package:sensorctl/ui/watch/watch_view_model.dart';
import 'package:test/test.dart';

void main() {
  test('before the first reading the line says so', () {
    // The state the program starts with: no reading yet.
    const state = WatchState();

    // The code to implement: the line for that state.
    final line = watchLine(state);

    // The claim: the line says that nothing has arrived.
    expect(line, 'no readings yet');
  });

  test('the line shows the latest reading and the count', () {
    // A state with a reading and a count, made by the test.
    const state = WatchState(
      latest: Reading(x: 0.1, y: 9.776, z: 0.812),
      count: 42,
    );

    // The code to implement: the line for that state.
    final line = watchLine(state);

    // The claim: each value to three decimals, and the count.
    expect(line, 'x   0.100  y   9.776  z   0.812  42 readings');
  });
}
