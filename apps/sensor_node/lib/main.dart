import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensor_node/ui/node/node_screen.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(WakelockPlus.enable());
  zenohLog('error').listen(debugPrint);

  runApp(
    ProviderScope(
      retry: (retryCount, error) => null,
      child: const MaterialApp(home: NodeScreen()),
    ),
  );
}
