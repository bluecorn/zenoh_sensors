import 'package:sensor_core/src/services/session_settings.dart';
import 'package:zenoh_dart/zenoh.dart';

/// Starts zenoh's own log at [level], printed to standard error: for a
/// program with a terminal. Once per process, before any session opens.
void initZenohLogging(String level) => Zenoh.initLog(level);

/// The one class that talks to zenoh. It owns the session and hands plain
/// Dart values upward.
class ZenohService {
  /// A service for one role's [settings]. Nothing opens until [open].
  new(this.settings);

  /// Which side of the topology this session is on.
  final SessionSettings settings;

  Session? _session;

  /// Opens the session with the settings. The connection they ask for has
  /// been made, or has already failed, when this returns.
  Future<void> open() async {
    _session = await Session.open(config: _config());
  }

  /// The session's identity: thirty-two hexadecimal characters.
  String get zid => _opened.zid.toHexString();

  /// The identities of the peers this session is connected to.
  List<String> get peerIds =>
      _opened.peersZid().map((id) => id.toHexString()).toList();

  /// Closes the session. Safe before [open], and more than once.
  void dispose() {
    _session?.close();
    _session = null;
  }

  Config _config() {
    final config = Config();
    settings.asJson5.forEach(config.insertJson5);
    return config;
  }

  Session get _opened {
    final session = _session;
    if (session == null) {
      throw StateError('open() has not been called on this ZenohService');
    }
    return session;
  }
}
