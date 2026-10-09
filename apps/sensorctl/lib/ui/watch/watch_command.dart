import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_console/dart_console.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sensorctl/config/providers.dart';
import 'package:sensorctl/ui/watch/watch_view.dart';
import 'package:sensorctl/ui/watch/watch_view_model.dart';

/// `sensorctl watch`: the phone's readings as they arrive, until SIGINT or
/// SIGTERM.
class WatchCommand extends Command<void> {
  @override
  String get name => 'watch';

  @override
  String get description => "Show the phone's readings as they arrive.";

  @override
  Future<void> run() async {
    final path = globalResults?.option('config');
    final container = ProviderContainer(
      overrides: [if (path != null) configPathProvider.overrideWithValue(path)],
      retry: (retryCount, error) => null,
    );
    final view = WatchView(Console())..open();
    final stop = Completer<void>();
    final signals = [
      for (final signal in [ProcessSignal.sigint, ProcessSignal.sigterm])
        signal.watch().listen((_) {
          if (!stop.isCompleted) stop.complete();
        }),
    ];
    try {
      container.listen(
        watchViewModelProvider,
        (_, state) => view.show(state),
        fireImmediately: true,
      );
      await stop.future;
    } finally {
      for (final signal in signals) {
        await signal.cancel();
      }
      view.close();
      container.dispose();
    }
  }
}
