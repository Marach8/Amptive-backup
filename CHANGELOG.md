# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Centralized `AppLogger` facade under `lib/src/config/utils/logging/app_logger.dart`
  to replace ad-hoc `debugPrint`/`print` calls across the codebase.
- GitHub Actions CI workflow (`.github/workflows/ci.yml`) running `flutter pub get`,
  `flutter analyze --fatal-infos`, `dart format` check, and `flutter test --coverage`
  on every push and pull request.
- `dependabot.yml` for automated dependency updates (pub + GitHub actions).
- `.env.example` documenting the environment configuration consumed by the app.
- Test suite under `test/`:
  - `test/bloc/otp_auth_bloc_test.dart` — covers `AmptiveOtpCountDownStartEvent`
    and `AmptiveOTPCounterState` transitions.
  - `test/bloc/auth_bloc_test.dart` — covers `ProfilePictureAddedEvent` and
    `EditDOBAuthState` transitions.
  - `test/widgets/otp_screen_test.dart` — pumps `ATOTPScreen` and asserts the
    resend button and OTP text fields render.
  - `test/widget_test.dart` — smoke test for the `AmptiveApp` root widget.
- `bloc_test` dev dependency for bloc state-transition testing.

### Changed

- Hardened `analysis_options.yaml` with additional lints (`avoid_print`,
  `directives_ordering`, `prefer_const_declarations`, etc.).
- Replaced `debugPrint`/`print` calls with `AppLogger` across services and
  widgets (`otp_service.dart`, `authentication_service.dart`,
  `push_notification_service.dart`, `interceptor.dart`, `logging_nav_observer.dart`,
  `select_payment_method_dialog.dart`, `notif_types_widgets.dart`,
  `go_live_onboarding_screen.dart`).
- Wrapped network calls in `otp_service.dart` with try/catch that logs via
  `AppLogger` and surfaces typed failure states.

### Documentation

- Rewrote `README.md` with Overview, Prerequisites, Install, Run, Test,
  Analyze & Format, Architecture, and Environment sections.