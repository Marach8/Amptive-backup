import 'dart:async';
import 'dart:developer' as developer;


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

  // Store ALL subscriptions so they are cancelled on teardown.
  // The original code leaked the two _media subscriptions.
  final List<StreamSubscription<dynamic>> _mediaSubs = [];

  // ── Observable state ───────────────────────────────────────────────────

  final _stateController = StreamController<LivestreamState>.broadcast();

  Stream<LivestreamState> get stateStream => _stateController.stream;

  LivestreamState _state = const LivestreamState();

  LivestreamState get state => _state;

  MediaService get mediaService => _media;

  // ── Join flow ──────────────────────────────────────────────────────────

  Future<void> join() async {
    try {
      // Step 1 — fetch token
      final LivestreamToken tokenData = await apiService.fetchToken(streamId!);

      // Step 2 — connect signaling WebSocket
      _signaling = SignalingService(
        streamId: streamId!,
      );
      _sigSub = _signaling!.events.listen(
        _handleSignalingEvent,
        onError: (Object e) => _emit(_state.copyWith(lastError: e.toString())),
      );
      await _signaling!.connect();

      // Step 3 — connect LiveKit media room
      await _media.connect(
        url: tokenData.livekitUrl,
        token: tokenData.token,
        isSpeaker: isHost,
      );

      // Store media subscriptions so _tearDown can cancel them.
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
        final ids = speakers.map((s) => s.identity).toSet();
        final updated = _state.participants
            .map((p) => p.copyWith(isSpeaker: ids.contains(p.identity)))
            .toList();
        _emit(_state.copyWith(participants: updated));
      }),
    );
    
    // Listen to participant joins/leaves from media service to keep roster in sync
    _mediaSubs.add(
      _media.onParticipantJoined.listen((participant) {
        _handleParticipantJoined(participant as LivestreamParticipant);
      }),
    );
    
    _mediaSubs.add(
      _media.onParticipantLeft.listen((participant) {
        _handleParticipantLeft(participant.identity);
      }),
    );

    _mediaSubs.add(
      _media.onRemoteAudioTrack.listen((RemoteAudioTrack track) {
        _handleRemoteTrack(track);
      }),
    );
    
    // Listen to media state changes
    _mediaSubs.add(
      _media.onMediaStateChanged.listen((change) {
        _handleMediaStateChange(change.identity, change.type.name, change.enabled);
      }),
    );
  }

  // ── Host lifecycle ─────────────────────────────────────────────────────

  Future<void> startStream(String contentId) async {
    try {
      final id = await apiService.startStream(contentId);
      streamId = id;
    } catch (e) {
      _emit(_state.copyWith(
        lastError: 'Failed to start stream: $e',
      ));
      rethrow;
    }
  }

  Future<void> endStream() async {
    try {
      await apiService.endStream(streamId!);
      _tearDown();
    } catch (e) {
      _emit(_state.copyWith(
        lastError: 'Failed to end stream: $e',
      ));
    }
  }

  // ── Interaction actions ────────────────────────────────────────────────

  void sendChat(String message) => _signaling?.sendChat(message);

  void sendReaction(String emoji) {
    _signaling?.sendReaction(emoji);
    apiService.sendReaction(streamId!, emoji).ignore();
  }

  void raiseHand() => _signaling?.raiseHand();

  void lowerHand() => _signaling?.lowerHand();

  void approveHandRaise(String identity) =>
      _signaling?.approveHandRaise(identity);

  Future<void> toggleMute() => _media.toggleMute();

  // ── Signaling event handler ────────────────────────────────────────────

  Future<void> _handleSignalingEvent(SignalingEvent event) async {
    switch (event) {
    // Connection & Stream Events
      case InitialStateEvent(:final state):
        _emit(_state.copyWith(
          status: StreamStatus.live,
          participants: state.participants,
          viewerCount: state.viewerCount,
          handQueue: state.handQueue,
        ));

      case StreamStartedEvent():
        _emit(_state.copyWith(status: StreamStatus.live));

      case StreamEndedEvent():
        _emit(_state.copyWith(status: StreamStatus.ended));
        _tearDown();

      case ErrorEvent(:final code, :final message):
        _emit(_state.copyWith(
          lastError: '[$code] $message',
          status: StreamStatus.error,
        ));

      case PongEvent():
      // Handle ping response if needed for connection health monitoring
        _log('Received pong, connection healthy');

    // Participant Events
      case ParticipantJoinEvent(:final participant):
        _handleParticipantJoined(participant);

      case ParticipantLeaveEvent(:final identity, :final reason):
        _handleParticipantLeft(identity);

      case ParticipantUpdatedEvent(:final participant):
        final updated = [
          for (final p in _state.participants)
            if (p.identity == participant.identity) participant else p,
        ];
        _emit(_state.copyWith(participants: updated));

        // Handle local participant's speaker status change
        if (participant.identity == _media.localParticipant?.identity) {
          if (participant.isSpeaker) {
            // User was promoted to speaker - publish and enable mic
            await _media.setupAndPublishAudio(); // Safe even if already published
            await _media.toggleMicrophone(true);
          } else {
            // User was demoted from speaker - mute mic (optional)
            await _media.toggleMicrophone(false);
          }
        }

      case ParticipantCountEvent(:final count):
      // Use participant count if needed, otherwise keep viewer count
        _emit(_state.copyWith(participantCount: count));

    // Interaction Events
      case ChatEvent(:final message):
        _emit(_state.copyWith(messages: [..._state.messages, message]));

      case ReactionReceivedEvent(:final reaction):
        _emit(_state.copyWith(reactions: [..._state.reactions, reaction]));

      case HandRaiseEvent(:final identity, :final action):
        _handleHandRaise(identity, action);

    // Statistics Events
      case ViewerCountEvent(:final count):
        _emit(_state.copyWith(viewerCount: count));

    // Moderation Events
      case UserMutedEvent(:final identity, :final muted):
        _handleUserMuted(identity, muted);

      case UserBannedEvent(:final identity, :final reason):
        _handleUserBanned(identity, reason);

      case UserKickedEvent(:final identity, :final reason):
        _handleUserKicked(identity, reason);

    // Media Events
      case MediaStateChangedEvent(:final identity, :final mediaType, :final enabled):
        _handleMediaStateChange(identity, mediaType, enabled);

      case UnknownEvent():
      // Log unknown events for debugging but don't break the stream
        _log('Received unknown event type: ${event.runtimeType}', level: LogLevel.warn);
        break;
    }
  }

  // ── Participant event handlers ─────────────────────────────────────────

  void _handleParticipantJoined(LivestreamParticipant participant) {
    if (!_state.participants.any((p) => p.identity == participant.identity)) {
      _emit(_state.copyWith(
        participants: [..._state.participants, participant],
      ));
    }
  }

  void _handleParticipantLeft(String identity) {
    _emit(_state.copyWith(
      participants: _state.participants
          .where((p) => p.identity != identity)
          .toList(),
      handQueue: _state.handQueue.where((id) => id != identity).toList(),
    ));
  }

  // ── Hand raise handlers ────────────────────────────────────────────────

  void _handleHandRaise(String identity, String action) {
    switch (action) {
      case 'raise':
        if (!_state.handQueue.contains(identity)) {
          _emit(_state.copyWith(
            handQueue: [..._state.handQueue, identity],
          ));
        }
        break;
      case 'lower':
      case 'approve':
        _emit(_state.copyWith(
          handQueue: _state.handQueue.where((i) => i != identity).toList(),
        ));
        break;
      default:
        _log('Unknown hand raise action: $action', level: LogLevel.warn);
    }
  }

  // ── Moderation handlers ────────────────────────────────────────────────

  void _handleUserMuted(String identity, bool muted) {
    final updatedParticipants = _state.participants.map((p) {
      if (p.identity == identity) {
        return p.copyWith(isMuted: muted);
      }
      return p;
    }).toList();

    _emit(_state.copyWith(participants: updatedParticipants));
  }

  void _handleUserBanned(String identity, String? reason) {
    _handleParticipantLeft(identity);
    // Optionally show a notification about the ban
    _emit(_state.copyWith(
      lastError: 'User $identity was banned${reason != null ? ': $reason' : ''}',
    ));
  }

  void _handleUserKicked(String identity, String? reason) {
    _handleParticipantLeft(identity);
    // Optionally show a notification about the kick
    if (identity == _media.localParticipant?.identity) {
      _emit(_state.copyWith(
        lastError: 'You were kicked from the stream${reason != null ? ': $reason' : ''}',
        status: StreamStatus.ended,
      ));
      _tearDown();
    }
  }

  // ── Media handlers ─────────────────────────────────────────────────────

  void _handleMediaStateChange(String identity, String mediaType, bool enabled) {
    final updatedParticipants = _state.participants.map((p) {
      if (p.identity == identity) {
        if (mediaType == 'audio') {
          return p.copyWith(isMuted: !enabled);
        }
      }
      return p;
    }).toList();

    _emit(_state.copyWith(participants: updatedParticipants));
  }

  void _handleRemoteTrack(RemoteAudioTrack track) {
    _log('Handling remote audio track - muted: ${track.muted}');

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
    _remoteAudioTrack?.dispose();
    _remoteAudioTrack = null;

    await _sigSub?.cancel();
    for (final StreamSubscription<dynamic> sub in _mediaSubs) {
      await sub.cancel();
    }

    _mediaSubs.clear();
    _signaling?.dispose();
    await _media.disconnect();
  }

  Future<void> dispose() async {
    await _tearDown();
    _stateController.close();
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
  final int participantCount;
  final List<String> handQueue;
  final List<ChatMessage> messages;
  final List<ReactionEvent> reactions;
  final String? lastError;

  const LivestreamState({
    this.status = StreamStatus.waiting,
    this.participants = const [],
    this.viewerCount = 0,
    this.participantCount = 0,
    this.handQueue = const [],
    this.messages = const [],
    this.reactions = const [],
    this.lastError,
  });

  LivestreamState copyWith({
    StreamStatus? status,
    List<LivestreamParticipant>? participants,
    int? viewerCount,
    int? participantCount,
    List<String>? handQueue,
    List<ChatMessage>? messages,
    List<ReactionEvent>? reactions,
    String? lastError,
  }) {
    return LivestreamState(
      status: status ?? this.status,
      participants: participants ?? this.participants,
      viewerCount: viewerCount ?? this.viewerCount,
      participantCount: participantCount ?? this.participantCount,
      handQueue: handQueue ?? this.handQueue,
      messages: messages ?? this.messages,
      reactions: reactions ?? this.reactions,
      lastError: lastError ?? this.lastError,
    );
  }
}
