import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensor_node/ui/node/node_view_model.dart';

/// The node's one screen: the latest reading to three decimals, and the count.
class NodeScreen extends ConsumerWidget {
  /// The screen; it watches [nodeViewModelProvider].
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final node = ref.watch(nodeViewModelProvider);
    final latest = node.latest;
    return Scaffold(
      body: Center(
        child: DefaultTextStyle.merge(
          style: Theme.of(context).textTheme.headlineSmall,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('x ${_fixed(latest?.x)}'),
              Text('y ${_fixed(latest?.y)}'),
              Text('z ${_fixed(latest?.z)}'),
              Text('${node.count} readings'),
            ],
          ),
        ),
      ),
    );
  }

  static String _fixed(double? value) => (value ?? 0).toStringAsFixed(3);
}
