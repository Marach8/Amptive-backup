import 'dart:async';
import 'dart:convert';
// import 'dart:developer' as developer show log;

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

import '../../config/config_export.dart';

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}

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
  Timer? _heartbeatTimer;

  bool _isDisposed = false;
  int _attempt = 0;
  bool _isManualDisconnect = false;
  bool _isConnected = false;

  // ── Template methods — subclasses override these ───────────────────────

  void onMessage(Map<String, dynamic> message);

  void onConnected() {}

  void onDisconnected() {}

  String buildConnectUrl() => "";

  void onMaxRetriesExceeded() {}

  // ── Public API ─────────────────────────────────────────────────────────

  bool get isConnected => _isConnected;

  bool get isReconnecting => _reconnectTimer?.isActive ?? false;

  Future<void> connect({Duration? connectTimeout}) async {
    if (_isDisposed) {
      log('connect() called on a disposed service — ignoring.',
          level: LogLevel.warn);
      return;
    }

    if (_isConnected) {
      log('Already connected, ignoring.', level: LogLevel.debug);
      return;
    }

    _isManualDisconnect = false;
    _cleanup(closeSink: true);

    final uri = Uri.parse(buildConnectUrl());
    log('Opening WebSocket → $uri');

    try {
      _channel = WebSocketChannel.connect(uri);

      // Add timeout for connection readiness
      final timeout = connectTimeout ?? const Duration(seconds: 10);
      await _channel!.ready.timeout(timeout, onTimeout: () {
        throw TimeoutException(
            'Connection timed out after ${timeout.inSeconds}s');
      });

      _sub = _channel!.stream.listen(
        _onFrame,
        onError: _onSocketError,
        onDone: _onSocketDone,
        cancelOnError: false,
      );

      _attempt = 0;
      _isConnected = true;

      // Start heartbeat with pong verification
      _startHeartbeat();

      log('🟢 WebSocket connected.', level: LogLevel.info);

      // Wait a moment before calling onConnected to ensure stability
      Future.delayed(Duration(milliseconds: 100), () {
        if (_isConnected && !_isDisposed) {
          onConnected();
        }
      });
    } on TimeoutException {
      log('🔴 Connection timed out', level: LogLevel.error);
      _channel = null;
      _scheduleReconnect();
    } on WebSocketChannelException catch (e) {
      log('🔴 Handshake failed: ${e.message}', level: LogLevel.error);
      _channel = null;
      _scheduleReconnect();
    } catch (e) {
      log('🔴 Unexpected connect error: $e', level: LogLevel.error);
      _channel = null;
      _scheduleReconnect();
    }
  }

  void disconnect() {
    log('Disconnecting manually.');
    _isManualDisconnect = true;
    _isConnected = false;
    _cleanup(closeSink: true);
  }

  void dispose() {
    log('Disposing service.');
    _isDisposed = true;
    _isManualDisconnect = true;
    _isConnected = false;
    _heartbeatTimer?.cancel();
    _cleanup(closeSink: true);
  }

  // Queue for messages sent while disconnected
  final List<Map<String, dynamic>> _pendingMessages = [];

  void send(Map<String, dynamic> data) {
    if (_isDisposed) {
      log('send() skipped — service disposed.', level: LogLevel.warn);
      return;
    }

    // Queue message if not connected
    if (!_isConnected || _channel == null) {
      log('Not connected, queuing message: ${data['type']}',
          level: LogLevel.debug);
      _pendingMessages.add(data);
      return;
    }

    try {
      _channel!.sink.add(jsonEncode(data));
    } catch (e) {
      log('Failed to send message: $e', level: LogLevel.error);
      // Queue for retry
      _pendingMessages.add(data);
      _onSocketError(e);
    }
  }

  void _flushPendingMessages() {
    if (_pendingMessages.isEmpty) return;
    log('Flushing ${_pendingMessages.length} pending messages',
        level: LogLevel.debug);
    final messages = List<Map<String, dynamic>>.from(_pendingMessages);
    _pendingMessages.clear();
    for (final data in messages) {
      if (_isConnected && _channel != null) {
        try {
          _channel!.sink.add(jsonEncode(data));
        } catch (_) {
          _pendingMessages.add(data);
        }
      }
    }
  }

  // ── Internal ───────────────────────────────────────────────────────────

  DateTime? _lastPongReceived;

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _lastPongReceived = DateTime.now();

    _heartbeatTimer = Timer.periodic(Duration(seconds: 25), (timer) {
      if (_isConnected && _channel != null && !_isDisposed) {
        // Check if we received pong recently (within 2 heartbeats)
        final timeSincePong =
            DateTime.now().difference(_lastPongReceived ?? DateTime.now());
        if (timeSincePong.inSeconds > 50) {
          log('No pong received for ${timeSincePong.inSeconds}s, reconnecting...',
              level: LogLevel.warn);
          _isConnected = false;
          _cleanup(closeSink: false);
          _scheduleReconnect();
          timer.cancel();
          return;
        }

        try {
          send(<String, dynamic>{
            'type': 'ping',
            'ts': DateTime.now().millisecondsSinceEpoch
          });
        } catch (e) {
          timer.cancel();
        }
      } else if (!_isConnected) {
        timer.cancel();
      }
    });
  }

  void _onFrame(dynamic raw) {
    if (raw is! String) return;

    late Map<String, dynamic> json;
    try {
      json = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }

    // Handle pong responses - update last pong time
    if (json['type'] == 'pong') {
      _lastPongReceived = DateTime.now();
      return;
    }

    // Respond to ping from server
    if (json['type'] == 'ping') {
      send({'type': 'pong', 'ts': DateTime.now().millisecondsSinceEpoch});
      return;
    }

    onMessage(json);
  }

  void _onSocketError(Object error) {
    log('Socket error: $error', level: LogLevel.error);
    if (!_isManualDisconnect && !_isDisposed) {
      _isConnected = false;
      _cleanup(closeSink: false);
      _scheduleReconnect();
    }
  }

  void _onSocketDone() {
    log('Connection closed by server.', level: LogLevel.warn);
    if (!_isManualDisconnect && !_isDisposed) {
      _isConnected = false;
      _cleanup(closeSink: false);
      _scheduleReconnect();
    } else {
      _isConnected = false;
      _cleanup(closeSink: false);
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed || _isManualDisconnect) return;
    if (_reconnectTimer?.isActive ?? false) return;

    onDisconnected();

    if (_attempt >= maxReconnectAttempts) {
      log('Max reconnect attempts reached.', level: LogLevel.error);
      onMaxRetriesExceeded();
      return;
    }

    // Exponential back-off: 2s, 4s, 8s, 16s, 30s
    int delaySeconds = [2, 4, 8, 16, 30][_attempt.clamp(0, 4)];
    final delay = Duration(seconds: delaySeconds);
    _attempt++;

    log('Reconnect attempt $_attempt/$maxReconnectAttempts in ${delay.inSeconds}s…',
        level: LogLevel.warn);

    _reconnectTimer = Timer(delay, () {
      if (!_isDisposed && !_isManualDisconnect) {
        connect().then((_) {
          _flushPendingMessages();
        });
      }
    });
  }

  void _cleanup({required bool closeSink}) {
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _sub?.cancel();
    _sub = null;

    if (closeSink) {
      try {
        _channel?.sink.close(ws_status.normalClosure);
      } catch (_) {}
    }
    _channel = null;
  }

  // ── Logging ────────────────────────────────────────────────────────────

  void log(String message, {LogLevel level = LogLevel.debug}) {
    //developer.log(message, name: _logTag, level: level.value);
  }
}
