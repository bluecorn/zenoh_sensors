import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensor_node/config/providers.dart';

/// What the node's screen shows: the latest reading, and how many there were.
class NodeState {
  /// A state with [latest] as the newest reading and [count] readings so far.
  const new({this.latest, this.count = 0});

  /// The newest reading, or null before the first.
  final Reading? latest;

  /// How many readings the node has published.
  final int count;
}

/// Keeps the latest reading and counts them, for the node's screen.
class NodeViewModel extends Notifier<NodeState> {
  @override
  NodeState build() {
    ref.listen(readingsProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        state = NodeState(latest: value, count: state.count + 1);
      }
    });
    return const NodeState();
  }
}

/// The node screen's view model.
final nodeViewModelProvider = NotifierProvider<NodeViewModel, NodeState>(
  NodeViewModel.new,
);
