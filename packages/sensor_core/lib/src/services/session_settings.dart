class SessionSettings {
  const SessionSettings._({
    required this.listenEndpoints,
    required this.connectEndpoints,
  });

  factory SessionSettings.sensorNode() => const SessionSettings._(
    listenEndpoints: [nodeEndpoint],
    connectEndpoints: [],
  );

  factory SessionSettings.collectorNode() => const SessionSettings._(
    listenEndpoints: [],
    connectEndpoints: [nodeEndpoint],
  );

  final List<String> listenEndpoints;
  final List<String> connectEndpoints;
  static const nodeEndpoint = 'tcp/127.0.0.1:7447';

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
