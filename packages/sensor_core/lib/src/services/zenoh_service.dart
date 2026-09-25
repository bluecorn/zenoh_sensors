import 'package:sensor_core/src/services/session_settings.dart';
import 'package:zenoh_dart/zenoh.dart';

/// Starts zenoh's own log, printed to standard output: for a program with a
/// terminal. [level] applies unless `RUST_LOG` is set. Once per process,
/// before any session opens.
void initZenohLogging(String level) => Zenoh.initLog(level);

/// Zenoh's own log at [level] as lines, for a program with no terminal to
/// print to, such as an app. Once per process, before any session opens, and
/// never after [initZenohLogging].
Stream<String> zenohLog(String level) =>
    Zenoh.initLogWithSink(minSeverity: LogSeverity.values.byName(level))
        .map((record) => 'zenoh ${record.severity.name}: ${record.message}');

/// A declared publisher on one key expression, as the service hands it out:
/// text in, marked `text/plain` on every put.
class Publication {
  new _(this._publisher);

  final Publisher _publisher;

  /// Puts [text] on the publication's key expression, marked `text/plain`.
  void put(String text) => _publisher.put(text, encoding: Encoding.textPlain);

  /// Undeclares the publisher. Safe to call twice.
  void close() => _publisher.close();
}

/// The owner of the zenoh session. It hands upward only plain Dart values and
/// its own [Publication]s.
class ZenohService {
  /// A service for one role's [settings]. Nothing opens until [open].
  new(this.settings);

  /// Which side of the topology this session is on.
  final SessionSettings settings;

  Session? _session;
  final _publications = <Publication>[];

  /// Opens the session with the settings. When this returns, each connection
  /// they ask for is made, or its first attempt has failed and zenoh keeps
  /// retrying it.
  Future<void> open() async {
    _session = await Session.open(config: _config());
  }

  /// The session's identity: up to thirty-two hexadecimal characters.
  String get zid => _opened.zid.toHexString();

  /// The identities of the peers this session is connected to.
  List<String> get peerIds =>
      _opened.peersZid().map((id) => id.toHexString()).toList();

  /// Declares a publisher on [keyExpr]. The service closes it on [dispose].
  Publication declarePublication(String keyExpr) {
    final publication = Publication._(_opened.declarePublisher(keyExpr));
    _publications.add(publication);
    return publication;
  }

  /// Closes the publications and the session. Safe before [open], and more
  /// than once.
  void dispose() {
    for (final publication in _publications) {
      publication.close();
    }
    _publications.clear();
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
