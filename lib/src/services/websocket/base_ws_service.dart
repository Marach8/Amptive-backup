import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer show log;

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

import '../../config/config_export.dart';


abstract class BaseWsService {
  BaseWsService({
    this.maxReconnectAttempts = 5,
    String? logTag,
  }) : _logTag = logTag ?? 'BaseWsService';

  final int maxReconnectAttempts;
  final String _logTag;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  Timer? _reconnectTimer;

  bool _isDisposed = false;
  int _attempt = 0;

  // ── Template methods — subclasses override these ───────────────────────

  /// Called with every successfully decoded JSON frame.
  void onMessage(Map<String, dynamic> message);

  /// Called once the WebSocket handshake succeeds.
  void onConnected() {}

  /// Called whenever the connection drops (before a reconnect attempt).
  void onDisconnected() {}

  /// Override to provide custom query parameters on top of [url].
  String buildConnectUrl() => "";

  // ── Public API ─────────────────────────────────────────────────────────

  bool get isConnected => _channel != null;

  /// Connects (or reconnects) to the WebSocket.
  Future<void> connect() async {
    if (_isDisposed) {
      log('connect() called on a disposed service — ignoring.');
      return;
    }

    _cleanup(closeSink: true);

    final uri = Uri.parse(buildConnectUrl());
    log('Opening WebSocket → $uri');

    try {
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;

      _sub = _channel!.stream.listen(
        _onFrame,
        onError: _onSocketError,
        onDone:  _onSocketDone,
        cancelOnError: false,
      );

      _attempt = 0;
      log('WebSocket connected.', level: LogLevel.info);
      onConnected();
    } on WebSocketChannelException catch (e) {
      log('Handshake failed: ${e.message}', level: LogLevel.error);
      _channel = null;
      _scheduleReconnect();
    } catch (e) {
      log('Unexpected connect error: $e', level: LogLevel.error);
      _channel = null;
      _scheduleReconnect();
    }
  }

  void disconnect() {
    log('Disconnecting.');
    _cleanup(closeSink: true);
  }

  void dispose() {
    log('Disposing.');
    _isDisposed = true;
    _cleanup(closeSink: true);
  }

  /// Encodes [data] as JSON and writes it to the sink.
  void send(Map<String, dynamic> data) {
    if (_channel == null || _isDisposed) {
      log('send() skipped — not connected.', level: LogLevel.warn);
      return;
    }
    _channel!.sink.add(jsonEncode(data));
  }

  // ── Internal ───────────────────────────────────────────────────────────

  void _onFrame(dynamic raw) {
    if (raw is! String) {
      log('Non-string frame ignored.', level: LogLevel.warn);
      return;
    }

    late Map<String, dynamic> json;
    try {
      json = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      log('Malformed JSON frame: $raw', level: LogLevel.warn);
      return;
    }

    log('Frame received: json="$json"');
    onMessage(json);
  }

  void _onSocketError(Object error) {
    log('Socket error: $error', level: LogLevel.error);
    _scheduleReconnect();
  }

  void _onSocketDone() {
    log('Connection closed by server.', level: LogLevel.warn);
    _cleanup(closeSink: false); // sink already closed
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_isDisposed || (_reconnectTimer?.isActive ?? false)) return;

    onDisconnected();

    if (_attempt >= maxReconnectAttempts) {
      log('Max reconnect attempts reached.', level: LogLevel.error);
      onMaxRetriesExceeded();
      return;
    }

    // Exponential back-off: 2s, 4s, 8s … capped at 30s
    final delay = Duration(
      milliseconds: (1000 * (1 << (_attempt + 1))).clamp(2000, 30000),
    );
    _attempt++;

    log(
      'Reconnect attempt $_attempt/$maxReconnectAttempts in ${delay.inSeconds}s…',
      level: LogLevel.warn,
    );

    _reconnectTimer = Timer(delay, () {
      if (!_isDisposed) connect();
    });
  }

  /// Override to react when all reconnect attempts are exhausted.
  void onMaxRetriesExceeded() {}

  void _cleanup({required bool closeSink}) {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _sub?.cancel();
    _sub = null;
    if (closeSink) {
      _channel?.sink.close(ws_status.normalClosure);
    }
    _channel = null;
  }

  // ── Logging ────────────────────────────────────────────────────────────

  void log(String message, {LogLevel level = LogLevel.debug}) {
    developer.log(message, name: _logTag, level: level.value);
  }
}