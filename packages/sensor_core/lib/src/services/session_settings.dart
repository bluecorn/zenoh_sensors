/// A session's settings, by role: where it listens and where it connects.
/// The three settings that never vary are in [asJson5] too.
class SessionSettings {
  const new _({required this.listenEndpoints, required this.connectEndpoints});

  /// The sensor node's settings: it listens on the loopback and connects
  /// nowhere.
  factory sensorNode() => const SessionSettings._(
    listenEndpoints: [nodeEndpoint],
    connectEndpoints: [],
  );

  /// A collector's settings: it listens nowhere and connects to the sensor
  /// node.
  factory collectorNode() => const SessionSettings._(
    listenEndpoints: [],
    connectEndpoints: [nodeEndpoint],
  );

  /// Where the sensor node waits: the loopback, port 7447.
  static const nodeEndpoint = 'tcp/127.0.0.1:7447';

  /// The endpoints the session listens on.
  final List<String> listenEndpoints;

  /// The endpoints the session connects to.
  final List<String> connectEndpoints;

  /// The settings as the entries `Config.insertJson5` takes: a key path and a
  /// JSON5 value each.
  Map<String, String> get asJson5 => {
    'mode': '"peer"',
    'scouting/multicast/enabled': 'false',
    'scouting/gossip/enabled': 'false',
    'listen/endpoints': _json5List(listenEndpoints),
    'connect/endpoints': _json5List(connectEndpoints),
  };

  static String _json5List(List<String> items) =>
      '[${items.map((item) => '"$item"').join(', ')}]';
}
