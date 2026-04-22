import 'dart:async';
import 'dart:convert';
import 'package:amptive/src/config/services/ws_notif_service/ws_notif_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WSConnectionStatus {
  initial,
  connecting,
  connected,
  reconnecting,
  disconnected,
  error,
}



class WSChannelNotifServiceImpl implements WSNotificationService {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;

  int _unreadCount = 0;
  bool _isConnected = false;

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


  @override
  Future<void> connect({required String wsUrl}) async {
    _connectionController.add(WSConnectionStatus.connecting);

    try {
      if(_channel != null) return;

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _subscription = _channel!.stream.listen(
        _onMessage,
        onDone: _onDisconnected,
        onError: _onError,
        cancelOnError: false,
      );

      _isConnected = true;
      _connectionController.add(WSConnectionStatus.connected);
    } catch (e) {
      _connectionController.add(WSConnectionStatus.error);
    }
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;

    await _subscription?.cancel();
    _subscription = null;

    try {
      await _channel?.sink.close();
    } catch (_) {}

    _channel = null;

    _connectionController.add(WSConnectionStatus.disconnected);
  }

  @override
  void sendMessage(Map<String, dynamic> data) {
    if (!_isConnected || _channel == null) return;

    try {
      _channel!.sink.add(jsonEncode(data));
    } catch (_) {
      _connectionController.add(WSConnectionStatus.error);
    }
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


  void _onMessage(dynamic data) {
    try {
      final Map<String, dynamic> parsed = data is String
          ? jsonDecode(data) as Map<String, dynamic>
          : Map<String, dynamic>.from(data);

      _messageController.add(parsed);

      // 👇 increment unread (you can customize filtering here)
      _unreadCount++;
      _unreadCountController.add(_unreadCount);
    } catch (_) {
      // ignore malformed messages
    }
  }

  void _onDisconnected() {
    _isConnected = false;
    _connectionController.add(WSConnectionStatus.disconnected);
  }

  void _onError(Object error) {
    _isConnected = false;
    _connectionController.add(WSConnectionStatus.error);
  }
}
