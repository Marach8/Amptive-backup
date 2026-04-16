import 'dart:async';
import 'package:amptive/src/config/services/audio_streaming_service/audio_streaming_service.dart';
import 'package:amptive/src/config/services/audio_streaming_service/live_kit_audio_streaming_impl.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LivestreamCubit1 extends Cubit<LiveStreamState> {
  LivestreamCubit1({
    ATAudioStreamingService? extStreamService,
  })  : streamingService = extStreamService ?? LiveKitAudioStreamingService(),
    super(const LiveStreamState()) {
    _listenToStreams();
  }

  final ATAudioStreamingService streamingService;

  // Individual, explicitly typed StreamSubscriptions for clarity and safety.
  StreamSubscription<LiveSessionConnectionStatus>? _connectionStateSub;
  StreamSubscription<List<LiveSessionParticipant>>? _participantsSub;
  StreamSubscription<List<String>>? _activeSpeakersSub;

  void _listenToStreams() {
    // Listen to connection state changes
    _connectionStateSub = streamingService.connectionStateStream.listen(
      (LiveSessionConnectionStatus connectionStatus) {
        emit(state.copyWith(connectionStatus: connectionStatus));
      }
    );

    // Listen to participant changes
    _participantsSub = streamingService.participantsStream.listen(
      (List<LiveSessionParticipant> participants) {
        emit(state.copyWith(participants: participants));
      }
    );

    // Listen to active speaker changes
    _activeSpeakersSub = streamingService.activeSpeakersStream.listen(
      (List<String> activeSpeakerIds) {
        emit(state.copyWith(activeSpeakerIds: activeSpeakerIds));
      }
    );
  }

  // --- Public methods for the UI to call ---

  Future<void> connect({
    required String roomUrl,
    required String participantToken,
  }) async {
    emit(state.copyWith(
      connectionStatus: LiveSessionConnectionStatus.connecting
    ));
    
    try {
      await streamingService.connect(
        roomUrl: roomUrl, participantToken: participantToken);
      emit(state.copyWith(
        connectionStatus: LiveSessionConnectionStatus.connected
      ));
    } catch (e) {
      emit(state.copyWith(
        connectionStatus: LiveSessionConnectionStatus.disconnected,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> toggleMicrophone() async {
    await streamingService.toggleMic();
    // The state of the microphone should ideally come from a stream as well.
    // For now, we optimistically update the UI.
    emit(state.copyWith(isMicrophoneEnabled: !state.isMicrophoneEnabled));
  }

  Future<void> disconnect() async {
    await streamingService.disconnect();
  }

  @override
  Future<void> close() {
    // Cancel each individual subscription to prevent memory leaks.
    _connectionStateSub?.cancel();
    _participantsSub?.cancel();
    _activeSpeakersSub?.cancel();
    
    // Dispose of the streaming service resources.
    streamingService.dispose();
    
    return super.close();
  }
}
