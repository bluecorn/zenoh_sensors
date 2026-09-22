# zenoh_sensors

The project built by hand while following [zenoh in Dart and Flutter](https://github.com/bluecorn/zenoh-dart-flutter-guide),
a guide that teaches [zenoh](https://zenoh.io) through two programs that talk to each other: a command-line collector
on the laptop and, later, a sensor node on an Android phone. This repository is the guide's project as its author
followed his own chapters, chapter by chapter; it stands where the last published chapter ends.

## What is here

```
zenoh_sensors/
├── apps/
│   └── sensorctl/        the command-line program — the collector
└── packages/
    └── sensor_core/      the zenoh data layer both programs share: ZenohService, SessionSettings, and their tests
```

The top folder is a pub workspace: one `pubspec.yaml` resolves every package below it, and everything is run from
here, never from inside a package.

## Running it

The toolchain is [fvm](https://fvm.app) with the Flutter SDK the `.fvmrc` names (3.47.2 or newer). From the top folder:

```sh
fvm dart pub get
fvm dart test packages/sensor_core      # the service's tests: two zenoh sessions in one process, on the loopback
fvm dart run sensorctl:sensorctl        # opens a session and says who it found
```

`sensorctl` connects to `tcp/127.0.0.1:7447`; start something that listens there first, such as the package's
`z_sub` example from `apps/sensorctl/example/`, as the guide's chapters do.

## Licence

Apache License 2.0 — see [LICENSE](LICENSE).
