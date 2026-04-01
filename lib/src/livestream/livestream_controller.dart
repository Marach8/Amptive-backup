import 'dart:async';

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

  // ── Join flow ──────────────────────────────────────────────────────────

  Future<void> join() async {
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
    _mediaSubs.add(
      _media.onActiveSpeakers.listen((speakers) {
        final ids = speakers.map((s) => s.identity).toSet();
        final updated = _state.participants
            .map((p) => p.copyWith(isSpeaker: ids.contains(p.identity)))
            .toList();
        _emit(_state.copyWith(participants: updated));
      }),
    );

    // onParticipantJoined: signaling already handles roster updates,
    // but we still need to store the sub so teardown can cancel it.
    _mediaSubs.add(_media.onParticipantJoined.listen((_) {}));
  }

  // ── Host lifecycle ─────────────────────────────────────────────────────

  Future<void> startStream(String contentId) async {
    final id = await apiService.startStream(contentId);
    streamId = id;
  }

  Future<void> endStream() async {
    await apiService.endStream(streamId!);
    // Backend broadcasts stream_ended → _handleSignalingEvent tears down.
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
        _emit(_state.copyWith(messages: [..._state.messages, message]));

      case ReactionReceivedEvent(:final reaction):
        _emit(_state.copyWith(reactions: [..._state.reactions, reaction]));

      case HandRaiseEvent(:final identity, :final action):
        _handleHandRaise(identity, action);

      case ParticipantUpdatedEvent(:final participant):
        final updated = [
          for (final p in _state.participants)
            if (p.identity == participant.identity) participant else p,
        ];
        _emit(_state.copyWith(participants: updated));
        if (participant.isSpeaker) _media.publishAudio();

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
      // Both lower and approve remove from the queue.
      // Actual speaker promotion arrives via participant_updated.
      case 'approve':
        _emit(_state.copyWith(
          handQueue: _state.handQueue.where((i) => i != identity).toList(),
        ));
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  void _emit(LivestreamState next) {
    _state = next;
    if (!_stateController.isClosed) _stateController.add(next);
  }

  Future<void> _tearDown() async {
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
