import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:math' hide log;

import 'package:amptive/src/config/services/ws_notif_service/ws_notif_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WSConnectionStatus {
  initial,
  connecting,
  connected,
  reconnecting,
  disconnected,
  failed,
}

class _PendingAckEntry {
  _PendingAckEntry({
    required this.data,
    required this.raw,
    required this.retries,
    required this.timer,
  });

  final Map<String, dynamic> data;
  final String raw;
  int retries;
  Timer timer;
}

class WSChannelNotifServiceImpl implements WSNotificationService {
  factory WSChannelNotifServiceImpl({
    WebSocketChannel? mockChannel,
  }) {
    _instance ??= WSChannelNotifServiceImpl._internal(
      channel: mockChannel,
    );
    return _instance!;
  }

  WSChannelNotifServiceImpl._internal({
    WebSocketChannel? channel,
  }) : _channel = channel;

  static WSChannelNotifServiceImpl? _instance;
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;

  int _unreadCount = 0;
  bool _isConnected = false;
  bool _isManuallyClosed = false;
  bool _isConnecting = false;

  bool get isActive => _isConnecting || _isConnected;

  // ─────────────────────────────────────────────
  // Streams
  // ─────────────────────────────────────────────
  final StreamController<WSConnectionStatus> _connectionController =
      StreamController<WSConnectionStatus>.broadcast();

  final StreamController<dynamic> _messageController =
      StreamController<dynamic>.broadcast();

  final StreamController<int> _unreadCountController =
      StreamController<int>.broadcast();

  @override
  Stream<WSConnectionStatus> get connectionStream =>
      _connectionController.stream;

  @override
  Stream<dynamic> get messageStream => _messageController.stream;

  @override
  Stream<int> get unreadCountStream => _unreadCountController.stream;

  // ─────────────────────────────────────────────
  // Ack retry
  // ─────────────────────────────────────────────
  int _ackIdCounter = 0;
  final Map<String, _PendingAckEntry> _pendingAcks = <String, _PendingAckEntry>{};
  static const int _ackTimeoutMs = 3000;
  static const int _maxAckRetries = 3;

  final StreamController<Map<String, dynamic>> _ackFailedController =
      StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> get ackFailedStream =>
      _ackFailedController.stream;

  // ─────────────────────────────────────────────
  // Queue
  // ─────────────────────────────────────────────
  final List<Map<String, dynamic>> _messageQueue = <Map<String, dynamic>>[];

  void _flushQueue() {
    if (!_isConnected || _channel == null) return;
    log('Flushing ${_messageQueue.length} queued messages');

    final List<Map<String, dynamic>> snapshot =
        List<Map<String, dynamic>>.from(_messageQueue);
    _messageQueue.clear();

    for (final Map<String, dynamic> msg in snapshot) {
      final Object? ackId = msg['_ack_id'];
      if (ackId is String && _pendingAcks.containsKey(ackId)) continue;
      _sendWithAckTracking(msg, jsonEncode(msg));
    }
  }

  // ─────────────────────────────────────────────
  // Heartbeat
  // ─────────────────────────────────────────────
  Timer? _heartbeatTimer;

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _pongTimeoutTimer?.cancel();

    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 25),
      (Timer timer) {
        if (!_isConnected || _channel == null) {
          timer.cancel();
          return;
        }

        _sendRaw(<String, dynamic>{
          'type': 'ping',
          'ts': DateTime.now().millisecondsSinceEpoch,
        });

        _pongTimeoutTimer?.cancel();
        _pongTimeoutTimer = Timer(const Duration(seconds: 15), () {
          log('Ping timeout (15s) — reconnecting');
          if (_isConnected) reconnect();
        });
      },
    );
  }

  void _handlePong() {
    _pongTimeoutTimer?.cancel();
  }

  String _nextAckId() {
    _ackIdCounter++;
    return '${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}-$_ackIdCounter';
  }

  // ─────────────────────────────────────────────
  // Connection
  // ─────────────────────────────────────────────
  int _lastSeqId = 0;
  int _reconnectAttempt = 0;
  static const int maxReconnectAttempts = 20;
  Timer? _reconnectTimer;
  Timer? _pongTimeoutTimer;
  String? _lastUrl;

  @override
  Future<bool> connect({required String wsUrl}) async {
    if (_isConnecting) return false;
    _isConnecting = true;

    _lastUrl = wsUrl.replaceAll(RegExp(r'&?last_seq_id=\d+'), '');
    _isManuallyClosed = false;
    _connectionController.add(WSConnectionStatus.connecting);

    try {
      await _cleanupConnection();

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _subscription = _channel!.stream.listen(
        _onMessage,
        onDone: _handleDisconnect,
        onError: _handleError,
        cancelOnError: false,
      );

      _isConnected = true;
      _reconnectAttempt = 0;

      _connectionController.add(WSConnectionStatus.connected);
      log('WebSocket connected');

      _startHeartbeat();
      _flushQueue();
      _resendPendingAcks();

      return true;
    } catch (e) {
      log('Connect error: $e');
      _scheduleReconnect();
      return false;
    } finally {
      _isConnecting = false;
    }
  }

  /// Public reconnect — override this to inject custom logic
  /// (e.g. re-fetch token, check network, lifecycle resume).
  @override
  Future<bool> reconnect() async {
    if (_lastUrl == null) {
      log('Reconnect failed: no URL stored');
      return false;
    }

    log('Reconnecting');
    _isManuallyClosed = false;

    String url = _lastUrl!;
    if (_lastSeqId > 0) {
      url += '&last_seq_id=$_lastSeqId';
    }
    return connect(wsUrl: url);
  }

  // ─────────────────────────────────────────────
  // Disconnect handlers
  // ─────────────────────────────────────────────
  void _handleDisconnect() {
    if (_isManuallyClosed) return;
    log('Socket disconnected');
    _isConnected = false;
    _cancelPendingAckTimers();
    _connectionController.add(WSConnectionStatus.disconnected);
    _scheduleReconnect();
  }

  void _handleError(Object error) {
    log('Socket error: $error');
    _isConnected = false;
    _cancelPendingAckTimers();
    _connectionController.add(WSConnectionStatus.failed);
    _scheduleReconnect();
  }

  // ─────────────────────────────────────────────
  // Exponential backoff
  // ─────────────────────────────────────────────
  void _scheduleReconnect() {
    if (_isManuallyClosed) return;

    _reconnectTimer?.cancel();

    if (_reconnectAttempt >= maxReconnectAttempts) {
      log('Max reconnect attempts ($maxReconnectAttempts) reached.');
      _clearPendingAcks();
      _isConnected = false;
      _connectionController.add(WSConnectionStatus.failed);
      return;
    }

    _reconnectAttempt++;

    // Full-jitter exponential backoff: delay = random(0, min(30s, 1s * 2^attempt))
    final double maxDelayMs =
        min(1000 * pow(2, _reconnectAttempt), 30000).toDouble();
    final int delayMs = Random().nextDouble() * maxDelayMs ~/ 1;
    final Duration delay = Duration(milliseconds: delayMs);

    log('Scheduled reconnect in ${delay.inSeconds}s (attempt $_reconnectAttempt/$maxReconnectAttempts)'
        ' [jitter 0–${maxDelayMs ~/ 1000}s]');
    _connectionController.add(WSConnectionStatus.reconnecting);

    _reconnectTimer = Timer(delay, reconnect);
  }

  // ─────────────────────────────────────────────
  // Message handling
  // ─────────────────────────────────────────────
  void _onMessage(dynamic data) {
    log('This is the incoming websocket data $data');
    try {
      final Map<String, dynamic> parsed = data is String
          ? jsonDecode(data) as Map<String, dynamic>
          : Map<String, dynamic>.from(data as Map<dynamic, dynamic>);

      // Track server-assigned sequence ID for message replay on reconnect
      final Object? seq = parsed['_seq'];
      if (seq is int) {
        _lastSeqId = max(_lastSeqId, seq);
      }

      // Handle explicit ack from server
      if (parsed['type'] == 'ack' && parsed['_ack_id'] is String) {
        _clearAck(parsed['_ack_id'] as String);
        return;
      }

      // Dedup on echo: if a broadcast carries our _ack_id, the server already
      // processed it — no need to wait for the ack message.
      final Object? echoAckId = parsed['_ack_id'];
      if (echoAckId is String && _pendingAcks.containsKey(echoAckId)) {
        _clearAck(echoAckId);
      }

      if (parsed['type'] == 'pong') {
        _handlePong();
        return;
      }

      if (parsed['type'] == 'ping') {
        _sendRaw(<String, dynamic>{'type': 'pong'});
        return;
      }

      _messageController.add(parsed);

      if (parsed['type'] == 'notification') {
        _unreadCount++;
        _unreadCountController.add(_unreadCount);
      }
    } catch (e) {
      log('Message parse error: $e');
    }
  }

  // ─────────────────────────────────────────────
  // Sending
  // ─────────────────────────────────────────────
  @override
  void sendMessage(Map<String, dynamic> data) {
    final String? type = data['type'] as String?;
    final bool needsAck = type != 'ping';
    if (needsAck) {
      data['_ack_id'] = _nextAckId();
    }

    final String raw = jsonEncode(data);

    if (_isConnected && _channel != null) {
      _sendWithAckTracking(data, raw);
    } else {
      _enqueue(data);
    }
  }

  /// Enqueue a message with dedup for ephemeral types and a max size cap.
  void _enqueue(Map<String, dynamic> data) {
    final String? type = data['type'] as String?;
    if (type == 'reaction' || type == 'ping') {
      _messageQueue.removeWhere(
        (Map<String, dynamic> m) => m['type'] == type,
      );
    }

    _messageQueue.add(data);

    if (_messageQueue.length > 100) {
      _messageQueue.removeAt(0);
    }
  }

  /// Send raw JSON string with ack tracking. If the message has `_ack_id`,
  /// registers a pending ack entry with retry timer.
  void _sendWithAckTracking(Map<String, dynamic> data, String raw) {
    if (!_isConnected || _channel == null) return;

    try {
      _channel!.sink.add(raw);
    } catch (e) {
      log('Send error: $e');
      _enqueue(data);
      return;
    }

    final Object? ackId = data['_ack_id'];
    if (ackId is String && !_pendingAcks.containsKey(ackId)) {
      _pendingAcks[ackId] = _PendingAckEntry(
        data: data,
        raw: raw,
        retries: 0,
        timer: Timer(
          const Duration(milliseconds: _ackTimeoutMs),
          () => _retryAck(ackId),
        ),
      );
    }
  }

  void _clearAck(String ackId) {
    final _PendingAckEntry? entry = _pendingAcks.remove(ackId);
    entry?.timer.cancel();
  }

  void _retryAck(String ackId) {
    final _PendingAckEntry? entry = _pendingAcks[ackId];
    if (entry == null) return;

    if (entry.retries >= _maxAckRetries) {
      _pendingAcks.remove(ackId);
      log('Ack failed after $_maxAckRetries retries: $ackId');
      if (!_ackFailedController.isClosed) {
        _ackFailedController.add(entry.data);
      }
      return;
    }

    entry.retries++;
    if (_isConnected && _channel != null) {
      try {
        _channel!.sink.add(entry.raw);
      } catch (_) {
        _enqueue(entry.data);
      }
      entry.timer = Timer(
        const Duration(milliseconds: _ackTimeoutMs),
        () => _retryAck(ackId),
      );
    }
  }

  void _resendPendingAcks() {
    if (!_isConnected || _channel == null) return;

    final List<MapEntry<String, _PendingAckEntry>> entries =
        List<MapEntry<String, _PendingAckEntry>>.from(_pendingAcks.entries);
    for (final MapEntry<String, _PendingAckEntry> entry in entries) {
      entry.value.timer.cancel();
      try {
        _channel!.sink.add(entry.value.raw);
      } catch (_) {}
      entry.value.timer = Timer(
        const Duration(milliseconds: _ackTimeoutMs),
        () => _retryAck(entry.key),
      );
    }
  }

  void _cancelPendingAckTimers() {
    for (final _PendingAckEntry entry in _pendingAcks.values) {
      entry.timer.cancel();
    }
  }

  void _clearPendingAcks() {
    _cancelPendingAckTimers();
    _pendingAcks.clear();
  }

  /// Internal raw send (bypasses ack tracking — used for ping/pong only).
  void _sendRaw(Map<String, dynamic> data) {
    try {
      _channel?.sink.add(jsonEncode(data));
    } catch (_) {}
  }

  // ─────────────────────────────────────────────
  // Cleanup
  // ─────────────────────────────────────────────
  Future<void> _cleanupConnection() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = null;
    _cancelPendingAckTimers();

    await _subscription?.cancel();
    _subscription = null;

    try {
      await _channel?.sink.close();
    } catch (_) {}

    _channel = null;
    _isConnected = false;
  }

  @override
  Future<void> disconnect() async {
    _isManuallyClosed = true;
    _clearPendingAcks();
    await _cleanupConnection();
  }

  @override
  void clearUnread() {
    _unreadCount = 0;
    _unreadCountController.add(_unreadCount);
  }

  @override
  Future<void> dispose() async {
    _clearPendingAcks();
    await disconnect();
    await _connectionController.close();
    await _messageController.close();
    await _unreadCountController.close();
    await _ackFailedController.close();
  }
}
