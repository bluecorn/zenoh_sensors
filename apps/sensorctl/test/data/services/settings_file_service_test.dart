import 'dart:io';

import 'package:sensorctl/data/services/settings_file_service.dart';
import 'package:test/test.dart';

void main() {
  test('the settings are the text of the file at the path', () {
    // A file made by the test, in a folder of its own that goes when the
    // test ends, with a comment and a key, as a configuration file has.
    final folder = Directory.systemTemp.createTempSync('sensorctl');
    addTearDown(() => folder.deleteSync(recursive: true));
    const text = '''
// A client of a router.
{ mode: "client" }
''';
    final file = File('${folder.path}/client.json5')..writeAsStringSync(text);

    // The code to implement: the file read by its path.
    final settings = SettingsFileService().read(file.path);

    // The claim: the settings hold the file's text, whole.
    expect(settings.json5, text);
  });
}
