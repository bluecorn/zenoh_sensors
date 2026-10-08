import 'package:sensor_node/ui/node/node_view_model.dart';

class FakeNodeViewModel extends NodeViewModel {
  new(this.fixed);

  final NodeState fixed;

  @override
  NodeState build() => fixed;
}
