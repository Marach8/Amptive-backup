import 'package:amptive/src/features/go_live/data/models/live_session_participant.dart';

abstract class ATAudioStreamingService {
  /// Connect to audio room
  Future<void> connect({
    required String url,
    required String token,
  });

  /// Disconnect from room
  Future<void> disconnect();

  /// Enable/disable microphone
  Future<void> setMicEnabled(bool enabled);

  /// Toggle microphone
  Future<void> toggleMic();

  /// Participants in room
  Stream<List<LiveSessionParticipant>> get participantsStream;

  /// Connection state
  Stream<LiveSessionConnectionStatus> get connectionStateStream;

  /// Active speakers (ids)
  Stream<List<String>> get activeSpeakersStream;

  /// Dispose resources
  Future<void> dispose();
}
