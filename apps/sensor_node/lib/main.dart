import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensor_node/ui/node/node_screen.dart';

void main() {
  zenohLog('error').listen(debugPrint);

  runApp(
    ProviderScope(
      retry: (retryCount, error) => null,
      child: const MaterialApp(home: NodeScreen()),
    ),
  );
}
