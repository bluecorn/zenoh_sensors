import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensor_core/sensor_core.dart';
import 'package:sensor_node/config/providers.dart';

/// What the node's screen shows for one key: the latest reading on it, and how
/// many there were.
class SensorState {
  /// A state with [latest] as the newest reading and [count] readings so far.
  const new({required this.latest, required this.count});

  /// The newest reading on the key.
  final Reading latest;

  /// How many readings the node has published on the key.
  final int count;
}

/// What the node's screen shows: the state of each key.
class NodeState {
  /// A state with [sensors] as the state of each key.
  const new({this.sensors = const {}});

  /// The state of each key the node has published on, in the order the keys
  /// first arrived.
  final Map<String, SensorState> sensors;
}

/// The view model behind the node's screen, which keeps the latest reading and
/// counts the readings, for each key.
class NodeViewModel extends Notifier<NodeState> {
  @override
  NodeState build() {
    ref.listen(readingsProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        final (:keyExpr, :reading) = value;
        final count = state.sensors[keyExpr]?.count ?? 0;
        state = NodeState(
          sensors: {
            ...state.sensors,
            keyExpr: SensorState(latest: reading, count: count + 1),
          },
        );
      }
    });
    return const NodeState();
  }
}

/// The node screen's view model.
final nodeViewModelProvider = NotifierProvider<NodeViewModel, NodeState>(
  NodeViewModel.new,
);
