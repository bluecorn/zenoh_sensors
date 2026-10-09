import 'package:zenoh_dart/zenoh.dart';

import 'settings.dart';

/// A collector opened with the package directly, as `z_sub` is on the laptop:
/// a witness that does not go through the service it checks.
Future<Session> openCollector() =>
    Session.open(config: Config.fromStr(collectorSettings().json5));

/// Long enough for a sample, or a declaration, to cross the loopback, which
/// takes milliseconds.
const delivery = Duration(milliseconds: 500);
