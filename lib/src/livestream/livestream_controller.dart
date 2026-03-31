import 'dart:async';

import './models/livestream_models.dart';
import './services/livestream_api_service.dart';
import './services/media_service.dart';
import './services/signaling_service.dart';

/// [LivestreamController] is the single entry-point for the UI layer.
///
/// It orchestrates the full join flow from the guide:
///
///   1. POST /token → receive JWT + LiveKit URL
///   2. Connect WebSocket → receive initial_state snapshot
///   3. Connect LiveKit room  → attach existing remote audio tracks
///   4. Keep signaling events in sync with local state
///   5. Expose clean action methods: send chat, react, raise hand, etc.
///   6. Graceful tear-down on stream end or explicit dispose
class LivestreamController {
  LivestreamController({
    required this.apiService,
    required this.baseWsUrl,
    required this.userAuthToken,
    this.isHost = false,
    this.contentId,
    this.streamId,
    MediaService? mediaService,
  }) : _media = mediaService ?? MediaService();

  String? streamId;   // this is required by participants to join
  final String? contentId;  // this is required by host to start stream
  final LivestreamApiService apiService;
  final String baseWsUrl;
  final String userAuthToken;
  final bool isHost;
  final MediaService _media;

  SignalingService? _signaling;
  StreamSubscription<SignalingEvent>? _sigSub;

  // ── Observable state ───────────────────────────────────────────────────

  final _stateController =
  StreamController<LivestreamState>.broadcast();
  Stream<LivestreamState> get stateStream => _stateController.stream;

  LivestreamState _state = const LivestreamState();
  LivestreamState get state => _state;

  // ── Join flow ──────────────────────────────────────────────────────────

  /// Full join sequence. Throws [LivestreamApiException] (status 403)
  /// if the stream is not live yet.
  Future<void> join() async {
    // Step 1 — fetch token
    final LivestreamToken tokenData = await apiService.fetchToken(streamId!);

    // Step 2 — connect signaling WebSocket
    _signaling = SignalingService(
      baseWsUrl: baseWsUrl,
      streamId: streamId!,
      authToken: userAuthToken,
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

    // Wire up media events
    _media.onParticipantJoined.listen((p) {
      // LiveKit join is already reflected in signaling; just update speaker UI
    });
    _media.onActiveSpeakers.listen((speakers) {
      final ids = speakers.map((s) => s.identity).toSet();
      final updated = _state.participants.map((p) {
        return p.copyWith(isSpeaker: ids.contains(p.identity));
      }).toList();
      _emit(_state.copyWith(participants: updated));
    });
  }

  // ── Host lifecycle ─────────────────────────────────────────────────────

  Future<void> startStream() async {
    // contentId is required to start stream
    String streamId = await apiService.startStream(contentId!);
    this.streamId = streamId;
  }

  Future<void> endStream() async {
    await apiService.endStream(streamId!);
    // Backend will broadcast stream_ended; _handleSignalingEvent tears down.
  }

  // ── Interaction actions ────────────────────────────────────────────────

  void sendChat(String message) =>
      _signaling?.sendChat(message);

  /// Sends a reaction both over WebSocket (speed) and via REST (persistence).
  void sendReaction(String emoji) {
    _signaling?.sendReaction(emoji);
    apiService.sendReaction(streamId!, emoji).ignore();
  }

  void raiseHand() => _signaling?.raiseHand();
  void lowerHand() => _signaling?.lowerHand();

  /// Host only: approve [identity]'s hand raise.
  void approveHandRaise(String identity) =>
      _signaling?.approveHandRaise(identity);

  Future<void> toggleMute() => _media.toggleMute();

  // ── Signaling event handler ────────────────────────────────────────────

  void _handleSignalingEvent(SignalingEvent event) {
    switch (event) {
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

      case ChatEvent(:final message):
        _emit(_state.copyWith(
          messages: [..._state.messages, message],
        ));

      case ReactionReceivedEvent(:final reaction):
        _emit(_state.copyWith(
          reactions: [..._state.reactions, reaction],
        ));

      case HandRaiseEvent(:final identity, :final action):
        _handleHandRaise(identity, action);

      case ParticipantUpdatedEvent(:final participant):
        final updated = [
          for (final p in _state.participants)
            if (p.identity == participant.identity) participant else p,
        ];
        _emit(_state.copyWith(participants: updated));
        // If this client was promoted, publish audio
        if (participant.isSpeaker) {
          _media.publishAudio();
        }

      case ViewerCountEvent(:final count):
        _emit(_state.copyWith(viewerCount: count));

      case UnknownEvent():
        break;
    }
  }

  void _handleHandRaise(String identity, String action) {
    switch (action) {
      case 'raise':
        if (!_state.handQueue.contains(identity)) {
          _emit(_state.copyWith(
            handQueue: [..._state.handQueue, identity],
          ));
        }
      case 'lower':
        _emit(_state.copyWith(
          handQueue: _state.handQueue.where((i) => i != identity).toList(),
        ));
      case 'approve':
        _emit(_state.copyWith(
          handQueue: _state.handQueue.where((i) => i != identity).toList(),
        ));
    // Promotion is confirmed via a follow-up participant_updated event
    // that sets is_speaker = true and triggers publishAudio().
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  void _emit(LivestreamState next) {
    _state = next;
    if (!_stateController.isClosed) _stateController.add(next);
  }

  Future<void> _tearDown() async {
    await _sigSub?.cancel();
    _signaling?.dispose();
    await _media.disconnect();
  }

  Future<void> dispose() async {
    await _tearDown();
    _stateController.close();
    apiService.dispose();
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
  final String? lastError;

  const LivestreamState({
    this.status = StreamStatus.waiting,
    this.participants = const [],
    this.viewerCount = 0,
    this.handQueue = const [],
    this.messages = const [],
    this.reactions = const [],
    this.lastError,
  });

  LivestreamState copyWith({
    StreamStatus? status,
    List<LivestreamParticipant>? participants,
    int? viewerCount,
    List<String>? handQueue,
    List<ChatMessage>? messages,
    List<ReactionEvent>? reactions,
    String? lastError,
  }) {
    return LivestreamState(
      status: status ?? this.status,
      participants: participants ?? this.participants,
      viewerCount: viewerCount ?? this.viewerCount,
      handQueue: handQueue ?? this.handQueue,
      messages: messages ?? this.messages,
      reactions: reactions ?? this.reactions,
      lastError: lastError ?? this.lastError,
    );
  }
}