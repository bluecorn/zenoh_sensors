import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_node/data/services/settings_asset_service.dart';

import '../../support/fakes.dart';

void main() {
  test('the settings are the text of the asset with the name', () async {
    // A fake of the bundle: one asset under config/, with a comment and a
    // key, as a configuration file has.
    const text = '''
// A client of a router.
{ mode: "client" }
''';
    final bundle = FakeAssetBundle({'config/client.json5': text});

    // The code to implement: the asset read by its name.
    final settings = await SettingsAssetService(bundle: bundle).read('client');

    // The claim: the settings hold the asset's text, whole.
    expect(settings.json5, text);
  });
}
