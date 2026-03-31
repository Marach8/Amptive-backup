import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

import '../models/livestream_models.dart';

/// Manages the **Control/Signaling** WebSocket connection to
/// `/ws/stream/{id}`.
///
/// Responsibilities:
///   - Connect / reconnect with exponential back-off
///   - Parse every incoming frame into a typed [SignalingEvent]
///   - Expose a broadcast [Stream<SignalingEvent>] the rest of the app
///     can listen to
///   - Provide send helpers for every outbound message type
class SignalingService {
  SignalingService({
    required String baseWsUrl,
    required String streamId,
    required String authToken,
    this.maxReconnectAttempts = 5,
  })  : _baseWsUrl = baseWsUrl,
        _streamId = streamId,
        _authToken = authToken;

  final String _baseWsUrl;
  final String _streamId;
  final String _authToken;
  final int maxReconnectAttempts;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  final _controller = StreamController<SignalingEvent>.broadcast();
  bool _disposed = false;
  int _reconnectAttempts = 0;

  // ── Public API ─────────────────────────────────────────────────────────

  /// Broadcast stream of typed signaling events.
  Stream<SignalingEvent> get events => _controller.stream;

  bool get isConnected => _channel != null;

  Future<void> connect() async {
    if (_disposed) return;
    final uri = Uri.parse(
      '$_baseWsUrl/ws/stream/$_streamId?token=$_authToken',
    );
    _channel = WebSocketChannel.connect(uri);
    _sub = _channel!.stream.listen(
      _onFrame,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: false,
    );
    _reconnectAttempts = 0;
  }

  void disconnect() {
    _sub?.cancel();
    _channel?.sink.close(ws_status.normalClosure);
    _channel = null;
  }

  void dispose() {
    _disposed = true;
    disconnect();
    _controller.close();
  }

  // ── Outbound helpers ───────────────────────────────────────────────────

  /// Send a chat message.
  void sendChat(String message) =>
      _send({'type': 'chat', 'message': message});

  /// Send a reaction emoji.  Uses the WebSocket path for speed; callers
  /// may also POST to /react if persistence is required.
  void sendReaction(String emoji) =>
      _send({'type': 'reaction', 'emoji': emoji});

  /// Raise or lower the current user's hand.
  void raiseHand() =>
      _send({'type': 'hand_raise', 'action': 'raise'});

  void lowerHand() =>
      _send({'type': 'hand_raise', 'action': 'lower'});

  /// Host approves a participant's hand raise.
  void approveHandRaise(String identity) =>
      _send({'type': 'hand_raise', 'action': 'approve', 'identity': identity});

  // ── Internal ───────────────────────────────────────────────────────────

  void _send(Map<String, dynamic> payload) {
    if (_channel == null) return;
    _channel!.sink.add(jsonEncode(payload));
  }

  void _onFrame(dynamic raw) {
    if (raw is! String) return;
    late Map<String, dynamic> json;
    try {
      json = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }

    final event = _parseEvent(json);
    if (!_controller.isClosed) _controller.add(event);
  }

  SignalingEvent _parseEvent(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    switch (type) {
      case 'initial_state':
        return InitialStateEvent(InitialState.fromJson(json));

      case 'stream_started':
        return StreamStartedEvent();

      case 'stream_ended':
        return StreamEndedEvent();

      case 'chat':
        return ChatEvent(ChatMessage.fromJson(json));

      case 'reaction':
        return ReactionReceivedEvent(ReactionEvent.fromJson(json));

      case 'hand_raise':
        return HandRaiseEvent(
          identity: json['identity'] as String? ?? '',
          action: json['action'] as String? ?? '',
        );

      case 'participant_updated':
        return ParticipantUpdatedEvent(
          LivestreamParticipant.fromJson(
            json['participant'] as Map<String, dynamic>,
          ),
        );

      case 'viewer_count':
        return ViewerCountEvent(json['count'] as int? ?? 0);

      default:
        return UnknownEvent(json);
    }
  }

  void _onError(Object error) {
    // Bubble as a stream error so callers can log; then attempt reconnect.
    if (!_controller.isClosed) {
      _controller.addError(error);
    }
    _scheduleReconnect();
  }

  void _onDone() {
    _channel = null;
    _scheduleReconnect();
  }

  Future<void> _scheduleReconnect() async {
    if (_disposed || _reconnectAttempts >= maxReconnectAttempts) return;
    _reconnectAttempts++;
    final delay = Duration(seconds: 1 << _reconnectAttempts); // 2, 4, 8 …
    await Future<void>.delayed(delay);
    if (!_disposed) await connect();
  }
}