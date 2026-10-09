/// A session's settings: the text of its zenoh configuration file, in JSON5.
/// The file holds the keys that differ from zenoh's defaults, among them
/// where the session listens and where it connects, and its mode.
class SessionSettings {
  /// Settings read from a configuration file, whose text is [json5].
  const new(this.json5);

  /// The text of the session's configuration file, in JSON5.
  final String json5;
}
