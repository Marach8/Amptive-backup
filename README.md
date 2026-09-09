# Amptive-mobile

Amptive is a Flutter/Dart mobile app for live-audio social experiences — host live
audio shows and events, engage with audiences, send gifts, subscribe to creators,
and manage a built-in wallet.

## Overview

The app is organized into feature-first folders under `lib/src/features` (for example
`auth`, `go_live`, `profile`, `wallet`, `discover`, `shows`, `episodes`, `events`) plus
shared layers:

- `lib/src/bloc` — bloc-based state management (authentication, main app, onboarding,
  preferences, profile, wallet).
- `lib/src/services` — network, websocket, notification, auth, and go-live services.
- `lib/src/views` — shared reusable widgets (app bars, buttons, OTP fields, animations).
- `lib/src/config` — routing, themes, API/app-state types, local services, and utils.
- `lib/src/features/<feature>/{cubits,data,presentation}` — per-feature MVVM/Clean-Architecture layout.

Navigation uses `go_router`, state management uses `flutter_bloc`, and dependency
injection uses `get_it`.

## Prerequisites

- Flutter SDK >= 3.19.0 (developed against 3.44.6 / Dart 3.12.2)
- Dart SDK >= 3.1.5
- Android (SDK 21+) and/or iOS device or emulator

Install Flutter:

```bash
# macOS / Linux
git clone https://github.com/flutter/flutter.git
cd flutter
flutter --version

# Windows (PowerShell)
# Ensure C:\Users\<you>\flutter\bin is on your PATH, then:
flutter --version
```

## Install

From the repository root:

```bash
flutter pub get
```

A `pubspec.lock` is committed so installs are reproducible.

## Run

```bash
flutter run
```

To run on a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

## Test

```bash
# Run the full test suite
flutter test

# With coverage (generates coverage/lcov.info)
flutter test --coverage
```

## Analyze & Format

```bash
# Static analysis (fails on infos/errors)
flutter analyze --fatal-infos

# Format check (fails if files are not formatted)
dart format --output=none --set-exit-if-changed lib/ test/
```

## Architecture

The app follows a layered architecture per feature:

```
lib/src/features/<feature>/
├── cubits/        # Bloc/Cubit classes for the feature
├── data/
│   ├── models/    # Request/response DTOs
│   └── repository/ # Repository interfaces + implementations
└── presentation/
    ├── screens/    # Routes / pages
    └── widgets/   # Feature-local widgets
```

Shared infrastructure lives in `lib/src/config` (routing via `go_router`, themes,
`ATAppState` state types, local storage, websocket, audio streaming) and
`lib/src/services` (auth, notification, go-live, websocket, create-show).

State management uses `flutter_bloc` with events and states defined next to each
bloc (for example `lib/src/bloc/authentication/general/auth_bloc.dart`).

## Environment

Copy the example environment file and fill in real values for your environment:

```bash
cp .env.example .env
```

See [.env.example](.env.example) for the list of configuration values the app reads
(API base URL, websocket endpoint, Firebase configuration, and push-notification
keys). Never commit a real `.env` — only `.env.example`.

## CI

A GitHub Actions workflow runs on every push and pull request:

- `flutter pub get`
- `flutter analyze --fatal-infos`
- `dart format --output=none --set-exit-if-changed .`
- `flutter test --coverage`

See [`.github/workflows/ci.yml`](.github/workflows/ci.yml).

## License

Private project — not published to pub.dev (`publish_to: 'none'`).