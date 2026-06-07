import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
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
      try {
        _channel!.sink.add(jsonEncode(msg));
      } catch (_) {
        _messageQueue.add(msg);
      }
    }
  }

  // ─────────────────────────────────────────────
  // Heartbeat
  // ─────────────────────────────────────────────
  Timer? _heartbeatTimer;
  DateTime _lastPong = DateTime.now();

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _lastPong = DateTime.now();

    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 20),
      (Timer timer) {
        if (!_isConnected || _channel == null) {
          timer.cancel();
          return;
        }

        final Duration sinceLastPong = DateTime.now().difference(_lastPong);

        if (sinceLastPong.inSeconds > 45) {
          log('Heartbeat timeout → reconnecting');
          timer.cancel();
          reconnect(); // calls the overridable public method
          return;
        }

        _sendRaw(<String, dynamic>{
          'type': 'ping',
          'ts': DateTime.now().millisecondsSinceEpoch,
        });
      },
    );
  }

  void _handlePong() => _lastPong = DateTime.now();

  // ─────────────────────────────────────────────
  // Connection
  // ─────────────────────────────────────────────
  int _reconnectAttempt = 0;
  Timer? _reconnectTimer;
  String? _lastUrl;

  @override
  Future<bool> connect({required String wsUrl}) async {
    if (_isConnecting) return false;
    _isConnecting = true;

    _lastUrl = wsUrl;
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
    return connect(wsUrl: _lastUrl!);
  }

  // ─────────────────────────────────────────────
  // Disconnect handlers
  // ─────────────────────────────────────────────
  void _handleDisconnect() {
    if (_isManuallyClosed) return;
    log('Socket disconnected');
    _isConnected = false;
    _connectionController.add(WSConnectionStatus.disconnected);
    _scheduleReconnect();
  }

  void _handleError(Object error) {
    log('Socket error: $error');
    _isConnected = false;
    _connectionController.add(WSConnectionStatus.failed);
    _scheduleReconnect();
  }

  // ─────────────────────────────────────────────
  // Exponential backoff
  // ─────────────────────────────────────────────
  void _scheduleReconnect() {
    if (_isManuallyClosed) return;

    _reconnectTimer?.cancel();
    _reconnectAttempt++;

    // 2<<0=2s, 2<<1=4s, 2<<2=8s, 2<<3=16s, 2<<4=32s → clamped to 30s
    final Duration delay = Duration(
      seconds: (2 << (_reconnectAttempt.clamp(0, 4))).clamp(2, 30),
    );

    log('Scheduled reconnect in ${delay.inSeconds}s (attempt $_reconnectAttempt)');
    _connectionController.add(WSConnectionStatus.reconnecting);

    _reconnectTimer = Timer(delay, reconnect); // uses overridable reconnect
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
    if (!_isConnected || _channel == null) {
      _messageQueue.add(data);
      return;
    }

    try {
      log('this is the data sent as message: $data');
      _channel!.sink.add(jsonEncode(data));
    } catch (e) {
      log('Send error: $e');
      _messageQueue.add(data);
    }
  }

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
    await _cleanupConnection();
    //_connectionController.add(WSConnectionStatus.disconnected);
  }

  @override
  void clearUnread() {
    _unreadCount = 0;
    _unreadCountController.add(_unreadCount);
  }

  @override
  Future<void> dispose() async {
    await disconnect();
    await _connectionController.close();
    await _messageController.close();
    await _unreadCountController.close();
  }
}
