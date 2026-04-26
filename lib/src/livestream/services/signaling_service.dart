import 'dart:async';

import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/config_export.dart';

import '../../services/websocket/base_ws_service.dart';
import '../models/livestream_models.dart';

// ── SignalingService ───────────────────────────────────────────────────────

class SignalingService extends BaseWsService {
  SignalingService({
    required String streamId,
    ATLocalStorageService? localStorageService,
    super.maxReconnectAttempts,
  })  : _streamId = streamId,
        _localStorageService =
            localStorageService ?? FlutterSecureStorageServiceImpl(),
        // URL is a placeholder; the real one is built in connect()
        super(logTag: 'SignalingService');

  final String _streamId;
  final ATLocalStorageService _localStorageService;

  final _controller = StreamController<SignalingEvent>.broadcast();

  // ── Public API ─────────────────────────────────────────────────────────

  Stream<SignalingEvent> get events => _controller.stream;

  /// Resolves the auth token, then delegates to [BaseWsService.connect].
  @override
  Future<void> connect({Duration? connectTimeout}) async {
    log('Resolving auth token…');
    final token = await _localStorageService.get(ATStrings.accessToken);

    if (token == null || token.isEmpty) {
      const msg = 'Auth token missing — cannot open signaling connection.';
      log(msg, level: LogLevel.error);
      _emitError(SignalingException(msg));
      throw SignalingException(msg);
    }

    // Stash the token so buildConnectUrl() can use it.
    _resolvedToken = token;
    return super.connect(connectTimeout: connectTimeout);
  }

  @override
  void dispose() {
    log('Disposing SignalingService.');
    _controller.close();
    super.dispose();
  }

  // ── BaseWsService overrides ────────────────────────────────────────────

  String? _resolvedToken;

  @override
  String buildConnectUrl() {
    final String base =
        '${ATEndpoints.wsStream}$_streamId?token=$_resolvedToken';
    return base;
  }

  @override
  void onMessage(Map<String, dynamic> json) {
    final event = _parseEvent(json);
    if (event is UnknownEvent) {
      log('Unrecognised type: "${json['type']}"', level: LogLevel.warn);
    }
    _emitEvent(event);
  }

  @override
  void onConnected() {
    // Send initial join message to server
    log('Sending join message...');
    send({
      'type': 'join',
      'streamId': _streamId,
    });
    log('Signaling connected.', level: LogLevel.info);
  }

  @override
  void onDisconnected() => log('Signaling disconnected.', level: LogLevel.warn);

  @override
  void onMaxRetriesExceeded() {
    const msg = 'Max reconnect attempts reached. Giving up.';
    log(msg, level: LogLevel.error);
    _emitError(SignalingException(msg));
  }

  // ── Outbound helpers ───────────────────────────────────────────────────

  void sendChat(String message) =>
      send({'type': OutboundMessageType.chat, 'content': message});

  void sendReaction(String emoji) =>
      send({'type': OutboundMessageType.reaction, 'content': emoji});

  void sendGift(String giftId, int quantity) => send({
        'type': OutboundMessageType.gift,
        'gift_id': giftId,
        'quantity': quantity,
      });

  void raiseHand() =>
      send({'type': OutboundMessageType.handRaise, 'action': 'raise'});
  void lowerHand() =>
      send({'type': OutboundMessageType.handRaise, 'action': 'lower'});

  void approveHandRaise(String identity) => send({
        'type': OutboundMessageType.handRaise,
        'action': 'approve',
        'identity': identity,
      });

  void sendPing() => send({
        'type': OutboundMessageType.ping,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

  void toggleMedia(String mediaType, bool enabled) => send({
        'type': OutboundMessageType.mediaToggle,
        'mediaType': mediaType,
        'enabled': enabled,
      });

  void toggleScreenShare(bool start) => send({
        'type': OutboundMessageType.screenShare,
        'action': start ? 'start' : 'stop',
      });

  // ── Private helpers ────────────────────────────────────────────────────

  void _emitEvent(SignalingEvent event) {
    if (!_controller.isClosed) _controller.add(event);
  }

  void _emitError(Object error) {
    if (!_controller.isClosed) _controller.addError(error);
  }

  SignalingEvent _parseEvent(Map<String, dynamic> json) {
    final type = json['type'] as String?;

    return switch (type) {
      SignalingEventType.initial =>
        InitialStateEvent(InitialState.fromJson(json)),
      SignalingEventType.streamStarted => StreamStartedEvent(),
      SignalingEventType.streamEnded => StreamEndedEvent(),
      SignalingEventType.error => _parseErrorEvent(json),
      SignalingEventType.pong => PongEvent(json['timestamp'] as int? ?? 0),
      SignalingEventType.participantJoin =>
        ParticipantJoinEvent(LivestreamParticipant.fromJson(json)),
      SignalingEventType.participantLeave => ParticipantLeaveEvent(
          json['identity'] as String? ?? '',
          json['reason'] as String?,
        ),
      SignalingEventType.participantUpdated => ParticipantUpdatedEvent(
          LivestreamParticipant.fromJson(
            json['participant'] as Map<String, dynamic>,
          ),
        ),
      SignalingEventType.chat => ChatEvent(ChatMessage.fromJson(json)),
      SignalingEventType.reaction =>
        ReactionReceivedEvent(Reaction.fromJson(json)),
      SignalingEventType.handRaise => HandRaiseEvent(
          identity: json['user_id'] as String? ?? '',
          action: json['action'] as String? ?? '',
        ),
      SignalingEventType.gift => GiftReceivedEvent(Gift.fromJson(json)),
      SignalingEventType.viewerCount =>
        ViewerCountEvent(json['count'] as int? ?? 0),
      SignalingEventType.participantCount =>
        ParticipantCountEvent(json['count'] as int? ?? 0),
      SignalingEventType.userMuted => UserMutedEvent(
          identity: json['identity'] as String? ?? '',
          muted: json['muted'] as bool? ?? false,
        ),
      SignalingEventType.userBanned => UserBannedEvent(
          identity: json['identity'] as String? ?? '',
          reason: json['reason'] as String?,
        ),
      SignalingEventType.userKicked => UserKickedEvent(
          identity: json['identity'] as String? ?? '',
          reason: json['reason'] as String?,
        ),
      SignalingEventType.mediaStateChanged => MediaStateChangedEvent(
          identity: json['identity'] as String? ?? '',
          mediaType: json['mediaType'] as String? ?? '',
          enabled: json['enabled'] as bool? ?? false,
        ),
      _ => UnknownEvent(json),
    };
  }

  SignalingEvent _parseErrorEvent(Map<String, dynamic> json) => ErrorEvent(
        code: json['code'] as String? ?? 'unknown',
        message: json['message'] as String? ?? 'An error occurred',
        details: json['details'] as String? ?? '',
      );
}

class SignalingException implements Exception {
  const SignalingException(this.message);
  final String message;

  @override
  String toString() => 'SignalingException: $message';
}
