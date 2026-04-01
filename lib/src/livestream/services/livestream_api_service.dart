import 'dart:convert';
import 'dart:developer' as developer show log;

import 'package:amptive/src/config/endpoints.dart';

import '../../config/services/network_service/dio_network_service_impl.dart';
import '../../config/services/network_service/network_service.dart';
import '../models/livestream_models.dart';

/// Handles all REST calls to the Amptive API.
class LivestreamApiService {
  factory LivestreamApiService({
    NetworkService? networkService,
  }) {
    _instance ??= LivestreamApiService._internal(
      networkService: networkService ?? DioNetworkServiceImpl(),
    );
    return _instance!;
  }

  LivestreamApiService._internal({
    required NetworkService networkService,
  }) : _networkService = networkService;

  static LivestreamApiService? _instance;
  final NetworkService _networkService;

  // ── Token ──────────────────────────────────────────────────────────────

  /// Fetches a LiveKit JWT for the current user.
  ///
  /// Throws [LivestreamApiException] with status 403 if the stream is
  /// not yet LIVE (guest guard).
  Future<LivestreamToken> fetchToken(String streamId) async {
    try {
      final res = await _networkService.post(
        ATEndpoints.getStreamTokenEndpoint(streamId),
      );

      return LivestreamToken.fromJson(
        res.data['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      throw LivestreamApiException(
        statusCode: _extractStatusCode(e),
        message: _extractErrorMessage(e),
      );
    }
  }

  // ── Room lifecycle (host only) ─────────────────────────────────────────

  Future<String> startStream(String contentId) async {
    try {
      final res = await _networkService.post(
        ATEndpoints.startStreamEndpoint(contentId),
      );

      final String liveId = res.data['data']['livestream_id'];
      return liveId;
    } catch (e) {
      throw LivestreamApiException(
        statusCode: _extractStatusCode(e),
        message: _extractErrorMessage(e),
      );
    }
  }

  Future<void> endStream(String streamId) async {
    try {
      await _networkService.post(
        ATEndpoints.endStreamEndpoint(streamId),
      );
    } catch (e) {
      throw LivestreamApiException(
        statusCode: _extractStatusCode(e),
        message: _extractErrorMessage(e),
      );
    }
  }

  // ── Reactions (persistent path) ────────────────────────────────────────

  /// POST to /react for persistence.  For fire-and-forget speed, use
  /// [SignalingService.sendReaction] instead (or in addition).
  Future<void> sendReaction(String streamId, String emoji) async {
    try {
      await _networkService.post(
        '/api/v1/livestreams/$streamId/react',
        data: {'emoji': emoji},
      );
    } catch (e) {
      throw LivestreamApiException(
        statusCode: _extractStatusCode(e),
        message: _extractErrorMessage(e),
      );
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  int _extractStatusCode(dynamic error) {
    if (error is Exception) {
      // Try to extract status code from Dio error or other network errors
      final errorString = error.toString();
      final statusCodeMatch =
          RegExp(r'status code: (\d+)').firstMatch(errorString);
      return int.tryParse(statusCodeMatch?.group(1) ?? '') ?? 500;
    }
    return 500;
  }

  String _extractErrorMessage(dynamic error) {
    if (error is Exception) {
      final errorString = error.toString();

      // Try to extract message from various error formats
      final messageMatch =
          RegExp(r'message[:\s]+([^\n]+)').firstMatch(errorString);
      if (messageMatch != null) {
        return messageMatch.group(1)?.trim() ?? errorString;
      }

      // For Dio errors, try to get response data
      if (errorString.contains('DioError')) {
        try {
          final dataMatch =
              RegExp(r'response: ({.*?})').firstMatch(errorString);
          if (dataMatch != null) {
            final dataStr = dataMatch.group(1)!;
            final data = jsonDecode(dataStr) as Map<String, dynamic>;
            return data['message'] as String? ??
                data['detail'] as String? ??
                data['error'] as String? ??
                errorString;
          }
        } catch (_) {
          // Fall back to error string
        }
      }

      return errorString;
    }
    return error.toString();
  }

  static void resetInstance() => _instance = null;
}

class LivestreamApiException implements Exception {
  final int statusCode;
  final String message;

  const LivestreamApiException({
    required this.statusCode,
    required this.message,
  });

  bool get isForbidden => statusCode == 403;

  bool get isNotFound => statusCode == 404;

  @override
  String toString() => 'LivestreamApiException($statusCode): $message';
}
