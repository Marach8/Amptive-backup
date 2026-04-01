import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;


abstract class BaseWsService {
  final String url;
  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  Timer? _reconnectTimer; // Track the timer to prevent duplicates

  bool _isDisposed = false;
  int _attempt = 0;
  double? _lastSeenTs;

  BaseWsService({required this.url});

  // Subclasses implement these
  void onMessage(Map<String, dynamic> message);
  void onConnected();
  void onDisconnected();

  String get _connectUrl => _lastSeenTs != null ? '$url?since=$_lastSeenTs' : url;

  void connect() {
    if (_isDisposed) return;

    // Clean up previous attempts before starting a new one
    _cleanup();

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_connectUrl));

      _sub = _channel!.stream.listen(
            (raw) {
          _attempt = 0; // Reset backoff
          final msg = jsonDecode(raw) as Map<String, dynamic>;

          if (msg['ts'] != null) {
            _lastSeenTs = (msg['ts'] as num).toDouble();
          }
          onMessage(msg);
        },
        onError: (e) => _scheduleReconnect(),
        onDone: () => _scheduleReconnect(),
        cancelOnError: true,
      );

      onConnected();
    } catch (e) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed || _reconnectTimer?.isActive == true) return;

    onDisconnected();

    final delay = Duration(
      milliseconds: (1000 * (1 << _attempt)).clamp(1000, 30000),
    );

    _reconnectTimer = Timer(delay, () {
      _attempt++;
      connect();
    });
  }

  void send(Map<String, dynamic> data) {
    if (_channel != null && !_isDisposed) {
      _channel!.sink.add(jsonEncode(data));
    }
  }

  void _cleanup() {
    _sub?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.goingAway);
  }

  void dispose() {
    _isDisposed = true;
    _cleanup();
  }
}