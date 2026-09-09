/// Centralized logging facade for the Amptive app.
///
/// All debug/output calls throughout the codebase should go through
/// [AppLogger] instead of `debugPrint` / `print`. This keeps log output
/// consistent, allows the log level to be configured at runtime, and makes
/// logs easy to redirect (e.g. to a crash reporter or remote logging service).
///
/// Usage:
/// ```dart
/// AppLogger.instance.info('User logged in', tag: 'Auth');
/// AppLogger.instance.error('Failed to verify OTP', error: e, stackTrace: st);
/// ```
library;
import 'dart:developer' as dev;

/// Log severity levels, ordered from most to least severe.
enum AppLogLevel {
  error,
  warning,
  info,
  debug,
  verbose,
}

/// A thin wrapper around `dart:developer`'s `log` so that log calls can be
/// filtered, tagged, and later redirected without touching call sites.
class AppLogger {
  AppLogger._();

  static final AppLogger _instance = AppLogger._();

  /// The single shared logger instance.
  static AppLogger get instance => _instance;

  AppLogLevel _level = AppLogLevel.debug;
  String _tag = 'Amptive';

  /// Configure the minimum severity that will be emitted.
  void setLevel(AppLogLevel level) => _level = level;

  /// Set the tag prepended to every message.
  void setTag(String tag) => _tag = tag;

  bool _enabled(AppLogLevel level) =>
      level.index >= _level.index;

  void _log(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
    AppLogLevel level = AppLogLevel.verbose,
  }) {
    if (!_enabled(level)) {
      return;
    }
    final String prefix = tag == null ? _tag : '$_tag:$tag';
    dev.log(
      message,
      name: prefix,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an error-level message.
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) =>
      _log(
        message,
        error: error,
        stackTrace: stackTrace,
        tag: tag,
        level: AppLogLevel.error,
      );

  /// Log a warning-level message.
  void warning(String message, {String? tag}) =>
      _log(message, tag: tag, level: AppLogLevel.warning);

  /// Log an info-level message.
  void info(String message, {String? tag}) =>
      _log(message, tag: tag, level: AppLogLevel.info);

  /// Log a debug-level message.
  void debug(String message, {String? tag}) =>
      _log(message, tag: tag, level: AppLogLevel.debug);

  /// Log a verbose-level message.
  void verbose(String message, {String? tag}) =>
      _log(message, tag: tag, level: AppLogLevel.verbose);
}