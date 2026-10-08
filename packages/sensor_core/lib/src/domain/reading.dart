/// One reading of a sensor: its value on each of the device's three axes.
class Reading {
  /// A reading of [x], [y] and [z].
  const new({required this.x, required this.y, required this.z});

  /// On the device's x axis, to the right.
  final double x;

  /// On the device's y axis, towards the top of the screen.
  final double y;

  /// On the device's z axis, out of the screen.
  final double z;
}

/// A reading and the key expression it travels on.
typedef KeyedReading = ({String keyExpr, Reading reading});
