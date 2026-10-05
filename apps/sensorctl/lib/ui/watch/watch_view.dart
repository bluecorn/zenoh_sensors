import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:sensorctl/ui/watch/watch_view_model.dart';

/// The line `watch` shows for [state]: the latest reading, each value to three
/// decimals, and the count.
String watchLine(WatchState state) => switch (state.latest) {
  null => 'no readings yet',
  final latest =>
    'x ${_fixed(latest.x)}  y ${_fixed(latest.y)}  '
        'z ${_fixed(latest.z)}  ${state.count} readings',
};

/// [value] to three decimals, seven characters wide, so that the columns stay
/// in place when a value turns negative.
String _fixed(double value) => value.toStringAsFixed(3).padLeft(7);

/// The terminal as the view: the line for each state, redrawn in place on a
/// terminal, and printed once for each state when the output is not one.
class WatchView {
  /// A view on [console].
  new(this.console);

  /// The terminal it draws on.
  final Console console;

  /// Says how to stop, and hides the cursor on a terminal.
  void open() {
    stdout.writeln('Press Ctrl-C to stop.');
    if (console.hasTerminal) console.hideCursor();
  }

  /// Shows [state].
  void show(WatchState state) {
    if (console.hasTerminal) {
      console.eraseLine();
      stdout.write('\r${watchLine(state)}');
    } else {
      stdout.writeln(watchLine(state));
    }
  }

  /// Leaves the terminal ready for the next command: the cursor shown, on a
  /// new line.
  void close() {
    if (console.hasTerminal) {
      console.showCursor();
      stdout.writeln();
    }
  }
}
