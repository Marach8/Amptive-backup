import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';

abstract class ATAudioStreamingService {
  /// Connect to audio room
  Future<void> connect({
    required String roomUrl,
    required String participantToken,
  });

  /// Disconnect from room
  Future<void> disconnect();

  /// Enable/disable microphone
  Future<void> setMicEnabled(bool enabled);

  /// Participants in room
  Stream<List<LiveSessionParticipant>> get participantsStream;

  /// Connection state
  Stream<AudioConnectionStatus> get connectionStateStream;

  /// Active speakers (ids)
  Stream<List<String>> get activeSpeakersStream;

  /// Dispose resources
  Future<void> dispose();
}
