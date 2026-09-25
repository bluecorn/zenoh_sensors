import 'package:sensor_core/sensor_core.dart';
import 'package:sensor_node/ui/node/node_view_model.dart';

class FakeNodeViewModel extends NodeViewModel {
  new(this.fixed);

  final NodeState fixed;

  @override
  NodeState build() => fixed;
}

const aReading = Reading(x: 0.1, y: 9.776, z: 0.812);
