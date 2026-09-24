/// One reading of the accelerometer: metres per second squared on each axis,
/// gravity included, and the moment the device took it.
class Reading {
  /// A reading of [x], [y] and [z], taken at [timestamp].
  const new({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  /// Along the device's x axis, to the right.
  final double x;

  /// Along the device's y axis, towards the top of the screen.
  final double y;

  /// Along the device's z axis, out of the screen.
  final double z;

  /// When the device took the reading, on the wall clock.
  final DateTime timestamp;
}
