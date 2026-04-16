import 'dart:async';
import 'dart:developer' as developer;

import 'package:livekit_client/src/participant/remote.dart';
import 'package:livekit_client/src/track/remote/audio.dart';

import '../config/config_export.dart';
import './models/livestream_models.dart';
import './services/livestream_api_service.dart';
import './services/media_service.dart';
import './services/signaling_service.dart';

class LivestreamController {
  LivestreamController({
    this.isHost = false,
    this.streamId,
    MediaService? mediaService,
    LivestreamApiService? apiService,
  })  : _media = mediaService ?? MediaService(),
        apiService = apiService ?? LivestreamApiService();

  String? streamId;
  final LivestreamApiService apiService;
  final bool isHost;
  final MediaService _media;

  RemoteAudioTrack? _remoteAudioTrack;

  SignalingService? _signaling;
  StreamSubscription<SignalingEvent>? _sigSub;

  final List<StreamSubscription<dynamic>> _mediaSubs = [];
  bool _tornDown = false;

  // ── Observable state ───────────────────────────────────────────────────

  final _stateController = StreamController<LivestreamState>.broadcast();

  Stream<LivestreamState> get stateStream => _stateController.stream;

  LivestreamState _state = const LivestreamState();

  LivestreamState get state => _state;

  MediaService get mediaService => _media;

  // ── Join flow ──────────────────────────────────────────────────────────

  Future<void> join() async {
    try {
      final LivestreamToken tokenData = await apiService.fetchToken(streamId!);

      _signaling = SignalingService(streamId: streamId!);
      _sigSub = _signaling!.events.listen(
        _handleSignalingEvent,
        onError: (Object e) => _emit(_state.copyWith(lastError: e.toString())),
      );
      await _signaling!.connect();

      await _media.connect(
        url: tokenData.livekitUrl,
        token: tokenData.token,
        isSpeaker: isHost,
      );

      _setupMediaListeners();
    } catch (e) {
      _emit(_state.copyWith(
        status: StreamStatus.error,
        lastError: 'Failed to join stream: $e',
      ));
      rethrow;
    }
  }

  void _setupMediaListeners() {
    _mediaSubs.add(
      _media.onActiveSpeakers.listen((speakers) {
        if (speakers.isEmpty) return;

        final ids = speakers.map((s) => s.identity).toSet();
        final updated = _state.participants
            .map((p) => p.copyWith(isSpeaker: ids.contains(p.identity)))
            .toList();

        final localSid = _media.room?.localParticipant?.sid;
        double? localLevel;
        double? remoteLevel;

        for (final speaker in speakers) {
          if (speaker.sid == localSid) {
            localLevel = speaker.audioLevel;
          } else {
            remoteLevel = speaker.audioLevel;
          }
        }

        _emit(_state.copyWith(
          participants: updated,
          localLevel: localLevel,
          remoteLevel: remoteLevel,
        ));
      }),
    );

    _mediaSubs.add(
      _media.onParticipantJoined.listen((RemoteParticipant participant) {
        _log('Participant joined LiveKit: ${participant.identity}');
      }),
    );

    _mediaSubs.add(
      _media.onParticipantLeft.listen((participant) {
        _handleParticipantLeft(participant.identity);
      }),
    );

    _mediaSubs.add(_media.onRemoteAudioTrack.listen(_handleRemoteTrack));

    _mediaSubs.add(
      _media.onMediaStateChanged.listen((change) {
        _handleMediaStateChange(
            change.identity, change.type.name, change.enabled);
      }),
    );
  }

  // ── Host lifecycle ─────────────────────────────────────────────────────

  Future<void> startStream(String contentId) async {
    try {
      final id = await apiService.startStream(contentId);
      streamId = id;
    } catch (e) {
      _emit(_state.copyWith(lastError: 'Failed to start stream: $e'));
      rethrow;
    }
  }

  Future<void> endStream() async {
    try {
      await apiService.endStream(streamId!);
      await _tearDown();
    } catch (e) {
      _emit(_state.copyWith(lastError: 'Failed to end stream: $e'));
    }
  }

  // ── Interaction actions ────────────────────────────────────────────────

  void sendChat(String message) {
    _signaling?.sendChat(message);
  }

  void sendReaction(String emoji) {
    _signaling?.sendReaction(emoji);
    apiService.sendReaction(streamId!, emoji).catchError((Object e) {
      _log('sendReaction API error: $e', level: LogLevel.warn);
    });
  }

  void sendGift(String giftId, int quantity) {
    _signaling?.sendGift(giftId, quantity);
  }

  void raiseHand() => _signaling?.raiseHand();
  void lowerHand() => _signaling?.lowerHand();
  void approveHandRaise(String identity) =>
      _signaling?.approveHandRaise(identity);
  Future<void> toggleMute() => _media.toggleMute();

  // ── Signaling event handler ────────────────────────────────────────────

  Future<void> _handleSignalingEvent(SignalingEvent event) async {
    switch (event) {
      case InitialStateEvent(:final state):
        _emit(_state.copyWith(
          status: StreamStatus.live,
          participants: state.participants,
          viewerCount: state.viewerCount,
          handQueue: state.handQueue,
          lastError: null,
        ));

      case StreamStartedEvent():
        _emit(_state.copyWith(status: StreamStatus.live, lastError: null));

      case StreamEndedEvent():
        _emit(_state.copyWith(status: StreamStatus.ended));
        await _tearDown();

      case ErrorEvent(:final code, :final message):
        _emit(_state.copyWith(
          lastError: '[$code] $message',
          status: StreamStatus.error,
        ));

      case PongEvent():
        _log('Received pong, connection healthy');

      case ParticipantJoinEvent(:final participant):
        _handleParticipantJoined(participant);

      case ParticipantLeaveEvent(:final identity, :final reason):
        if (reason != null) _log('Participant $identity left. Reason: $reason');
        _handleParticipantLeft(identity);

      case ParticipantUpdatedEvent(:final participant):
        final updated = [
          for (final p in _state.participants)
            if (p.identity == participant.identity) participant else p,
        ];
        _emit(_state.copyWith(participants: updated));

        if (participant.identity == _media.localParticipant?.identity) {
          if (participant.isSpeaker) {
            await _media.setupAndPublishAudio();
            await _media.toggleMicrophone(true);
          } else {
            await _media.toggleMicrophone(false);
          }
        }

      // participantCount is now a computed getter on LivestreamState
      // (participants.length), so we no longer need to manage it here.
      // ParticipantCountEvent maps to viewerCount (server-side total).
      case ParticipantCountEvent(:final count):
        _emit(_state.copyWith(viewerCount: count));

      case ChatEvent(:final message):
        _emit(_state.copyWith(messages: [..._state.messages, message]));

      case ReactionReceivedEvent(:final reaction):
        _emit(_state.copyWith(reactions: [..._state.reactions, reaction]));

      case GiftReceivedEvent(:final gift):
        _emit(_state.copyWith(gifts: [..._state.gifts, gift]));

      case HandRaiseEvent(:final identity, :final action):
        _handleHandRaise(identity, action);

      case ViewerCountEvent(:final count):
        _emit(_state.copyWith(viewerCount: count));

      case UserMutedEvent(:final identity, :final muted):
        _handleUserMuted(identity, muted);

      case UserBannedEvent(:final identity, :final reason):
        _handleUserBanned(identity, reason);

      case UserKickedEvent(:final identity, :final reason):
        _handleUserKicked(identity, reason);

      case MediaStateChangedEvent(
          :final identity,
          :final mediaType,
          :final enabled
        ):
        _handleMediaStateChange(identity, mediaType, enabled);

      case UnknownEvent():
        _log('Received unknown event: ${event.runtimeType}',
            level: LogLevel.warn);
    }
  }

  // ── Participant event handlers ─────────────────────────────────────────

  void _handleParticipantJoined(LivestreamParticipant participant) {
    _log('Participant joined via signaling: ${participant.identity}');
    if (!_state.participants.any((p) => p.identity == participant.identity)) {
      _emit(_state.copyWith(
        participants: [..._state.participants, participant],
      ));
    }
  }

  void _handleParticipantLeft(String identity) {
    // Same: participantCount stays in sync automatically.
    _emit(_state.copyWith(
      participants:
          _state.participants.where((p) => p.identity != identity).toList(),
      handQueue: _state.handQueue.where((id) => id != identity).toList(),
    ));
  }

  // ── Hand raise handlers ────────────────────────────────────────────────

  void _handleHandRaise(String identity, String action) {
    switch (action) {
      case 'raise':
        if (!_state.handQueue.contains(identity)) {
          _emit(_state.copyWith(handQueue: [..._state.handQueue, identity]));
        }
      case 'lower':
      case 'approve':
        _emit(_state.copyWith(
          handQueue: _state.handQueue.where((i) => i != identity).toList(),
        ));
      default:
        _log('Unknown hand raise action: $action', level: LogLevel.warn);
    }
  }

  // ── Moderation handlers ────────────────────────────────────────────────

  void _handleUserMuted(String identity, bool muted) {
    final updated = _state.participants
        .map((p) => p.identity == identity ? p.copyWith(isMuted: muted) : p)
        .toList();
    _emit(_state.copyWith(participants: updated));
  }

  void _handleUserBanned(String identity, String? reason) {
    _handleParticipantLeft(identity);
    _emit(_state.copyWith(
      lastError:
          'User $identity was banned${reason != null ? ': $reason' : ''}',
    ));
  }

  void _handleUserKicked(String identity, String? reason) {
    _handleParticipantLeft(identity);
    if (identity == _media.localParticipant?.identity) {
      _emit(_state.copyWith(
        lastError: 'You were kicked${reason != null ? ': $reason' : ''}',
        status: StreamStatus.ended,
      ));
      _tearDown();
    }
  }

  // ── Media handlers ─────────────────────────────────────────────────────

  void _handleMediaStateChange(
      String identity, String mediaType, bool enabled) {
    final updated = _state.participants.map((p) {
      if (p.identity == identity && mediaType == 'audio') {
        return p.copyWith(isMuted: !enabled);
      }
      return p;
    }).toList();
    _emit(_state.copyWith(participants: updated));
  }

  void _handleRemoteTrack(RemoteAudioTrack track) {
    _log('Handling remote audio track — muted: ${track.muted}');
    _remoteAudioTrack?.stop();
    _remoteAudioTrack = track;
    _remoteAudioTrack?.start();
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  void _emit(LivestreamState next) {
    _state = next;
    if (!_stateController.isClosed) _stateController.add(next);
  }

  Future<void> _tearDown() async {
    if (_tornDown) return;
    _tornDown = true;

    _remoteAudioTrack?.stop();
    _remoteAudioTrack = null;

    await _sigSub?.cancel();
    _sigSub = null;

    for (final sub in _mediaSubs) {
      await sub.cancel();
    }
    _mediaSubs.clear();

    _signaling?.dispose();
    _signaling = null;

    await _media.disconnect();
  }

  Future<void> dispose() async {
    await _tearDown();
    await _stateController.close();
  }

  void _log(String message, {LogLevel level = LogLevel.debug}) {
    developer.log(message, name: 'LivestreamController', level: level.value);
  }
}

// ── Immutable state snapshot ───────────────────────────────────────────────

class LivestreamState {
  final StreamStatus status;
  final List<LivestreamParticipant> participants;
  final int viewerCount;
  final List<String> handQueue;
  final List<ChatMessage> messages;
  final List<ReactionEvent> reactions;
  final List<GiftEvent> gifts;
  final String? lastError;
  final double localLevel;
  final double remoteLevel;

  const LivestreamState({
    this.status = StreamStatus.waiting,
    this.participants = const [],
    this.viewerCount = 0,
    this.handQueue = const [],
    this.messages = const [],
    this.reactions = const [],
    this.gifts = const [],
    this.lastError,
    this.localLevel = 0.0,
    this.remoteLevel = 0.0,
  });

  int get participantCount => participants.length;

  LivestreamState copyWith({
    StreamStatus? status,
    List<LivestreamParticipant>? participants,
    int? viewerCount,
    List<String>? handQueue,
    List<ChatMessage>? messages,
    List<ReactionEvent>? reactions,
    List<GiftEvent>? gifts,
    Object? lastError = _kUnset,
    double? localLevel,
    double? remoteLevel,
  }) {
    return LivestreamState(
      status: status ?? this.status,
      participants: participants ?? this.participants,
      viewerCount: viewerCount ?? this.viewerCount,
      handQueue: handQueue ?? this.handQueue,
      messages: messages ?? this.messages,
      reactions: reactions ?? this.reactions,
      gifts: gifts ?? this.gifts,
      lastError: lastError == _kUnset ? this.lastError : lastError as String?,
      localLevel: localLevel ?? this.localLevel,
      remoteLevel: remoteLevel ?? this.remoteLevel,
    );
  }
}

const Object _kUnset = Object();
