import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/livestream_models.dart';

/// Handles all REST calls to the Amptive API.
class LivestreamApiService {
  LivestreamApiService({
    required String baseUrl,
    required String authToken,
    http.Client? client,
  })  : _baseUrl = baseUrl.replaceAll(RegExp(r'/$'), ''),
        _authToken = authToken,
        _client = client ?? http.Client();

  final String _baseUrl;
  final String _authToken;
  final http.Client _client;

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_authToken',
    'Content-Type': 'application/json',
  };

  // ── Token ──────────────────────────────────────────────────────────────

  /// Fetches a LiveKit JWT for the current user.
  ///
  /// Throws [LivestreamApiException] with status 403 if the stream is
  /// not yet LIVE (guest guard).
  Future<LivestreamToken> fetchToken(String streamId) async {
    final res = await _client.post(
      Uri.parse('$_baseUrl/api/v1/livestreams/$streamId/token'),
      headers: _headers,
    );
    _assertOk(res);
    return LivestreamToken.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }

  // ── Room lifecycle (host only) ─────────────────────────────────────────

  Future<String> startStream(String contentId) async {
    final res = await _client.post(
      Uri.parse('$_baseUrl/api/v1/livestreams/$contentId/start'),
      headers: _headers,
    );

    _assertOk(res);

    final Map<String, dynamic> body = jsonDecode(res.body);

    final String liveId = body['data']['livestream_id'];

    return liveId;
  }

  Future<void> endStream(String streamId) async {
    final res = await _client.post(
      Uri.parse('$_baseUrl/api/v1/livestreams/$streamId/end'),
      headers: _headers,
    );
    _assertOk(res);
  }

  // ── Reactions (persistent path) ────────────────────────────────────────

  /// POST to /react for persistence.  For fire-and-forget speed, use
  /// [SignalingService.sendReaction] instead (or in addition).
  Future<void> sendReaction(String streamId, String emoji) async {
    final res = await _client.post(
      Uri.parse('$_baseUrl/api/v1/livestreams/$streamId/react'),
      headers: _headers,
      body: jsonEncode({'emoji': emoji}),
    );
    _assertOk(res);
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  void _assertOk(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw LivestreamApiException(
        statusCode: res.statusCode,
        message: _tryParseErrorMessage(res.body),
      );
    }
  }

  String _tryParseErrorMessage(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['detail'] as String? ??
          json['message'] as String? ??
          body;
    } catch (_) {
      return body;
    }
  }

  void dispose() => _client.close();
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