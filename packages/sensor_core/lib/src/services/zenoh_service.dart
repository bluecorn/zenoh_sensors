import 'package:zenoh_dart/zenoh_unstable.dart';

import 'session_settings.dart';

void initZenohLogging(String level) => Zenoh.initLog(level);

class ZenohService {
  ZenohService(this.settings);

  final SessionSettings settings;

  Session? _session;

  Future<void> open() async {
    _session = await Session.open(config: _config());
  }

  String get zid => _opened.zid.toHexString();

  List<String> get peerIds => _opened.peersZid().map((id) => id.toHexString()).toList();

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
