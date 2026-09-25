/// One reading of the accelerometer: meters per second squared on each axis,
/// gravity included.
class Reading {
  /// A reading of [x], [y] and [z].
  const new({required this.x, required this.y, required this.z});

  /// Along the device's x axis, to the right.
  final double x;

  /// Along the device's y axis, towards the top of the screen.
  final double y;

  /// Along the device's z axis, out of the screen.
  final double z;
}
