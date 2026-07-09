import 'dart:convert';

import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';

class ATInterceptorClass extends Interceptor {
  ATInterceptorClass({
    required this.localStorageService,
    required this.authGuardCubit,
  });

  final ATLocalStorageService localStorageService;
  final AuthGuardCubit authGuardCubit;

  /// In-flight token refresh shared across requests. The backend rotates
  /// refresh tokens (each refresh revokes the previous one), so concurrent
  /// 401s must funnel through a single refresh call — parallel refreshes
  /// revoke each other's tokens and log the user out.
  Future<bool?>? _ongoingRefresh;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains('auth/') && !options.path.contains('logout') && !options.path.contains('set-pin') ) {
      return handler.next(options);
    }

    try {
      String? token = await localStorageService.get(ATStrings.accessToken);

      // Access tokens only live ~15 minutes; renew proactively just before
      // expiry so requests never take the 401 → refresh → retry round trip.
      if (token != null && token.isNotEmpty && _isExpiringSoon(token)) {
        final bool? refreshed = await (_ongoingRefresh ??=
            _refreshTokens(options.baseUrl)
                .whenComplete(() => _ongoingRefresh = null));

        // The refresh token is dead — don't fire a doomed request that will
        // 401. Clear the session and bounce to login immediately.
        if (refreshed == false) {
          await _clearTokens();
          authGuardCubit.triggerUnauthenticated();
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Session expired',
              type: DioExceptionType.cancel,
            ),
          );
        }

        token = await localStorageService.get(ATStrings.accessToken);
      }

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return handler.next(options);
  }

  /// True when the JWT's expiry is within the next 60 seconds (or already
  /// past). Returns false for anything that doesn't parse as a JWT.
  bool _isExpiringSoon(String token) {
    try {
      final List<String> parts = token.split('.');
      if (parts.length != 3) return false;
      final String payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final num? exp = (jsonDecode(payload) as Map<String, dynamic>)['exp'];
      if (exp == null) return false;
      final DateTime expiry =
          DateTime.fromMillisecondsSinceEpoch((exp * 1000).round());
      return expiry
          .subtract(const Duration(seconds: 60))
          .isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final int? statusCode = err.response?.statusCode;
    if (statusCode != 401) {
      return handler.next(err);
    }

    // Prevent infinite loop if the refresh endpoint itself returns 401
    if (err.requestOptions.path.contains('auth/refresh')) {
      authGuardCubit.triggerUnauthenticated();
      return handler.next(err);
    }

    // If another request already rotated the tokens while this one was in
    // flight, retry with the current token instead of refreshing again.
    final Object? tokenUsed = err.requestOptions.headers['Authorization'];
    String? currentToken;
    try {
      currentToken = await localStorageService.get(ATStrings.accessToken);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (currentToken != null &&
        currentToken.isNotEmpty &&
        tokenUsed != 'Bearer $currentToken') {
      try {
        return handler.resolve(await _retry(err.requestOptions, currentToken));
      } on DioException catch (retryError) {
        return handler.next(retryError);
      }
    }

    // Single-flight: the first 401 starts the refresh, concurrent 401s
    // await the same future.
    final bool? refreshed = await (_ongoingRefresh ??=
        _refreshTokens(err.requestOptions.baseUrl)
            .whenComplete(() => _ongoingRefresh = null));

    if (refreshed == true) {
      try {
        final String? newToken =
            await localStorageService.get(ATStrings.accessToken);
        if (newToken != null && newToken.isNotEmpty) {
          return handler.resolve(await _retry(err.requestOptions, newToken));
        }
      } on DioException catch (retryError) {
        return handler.next(retryError);
      } catch (e) {
        debugPrint(e.toString());
      }
      return handler.next(err);
    }

    // Only a definitive rejection of the refresh token ends the session.
    // Transient failures (timeout, offline) surface the original error so
    // the UI can retry without logging the user out.
    if (refreshed == false) {
      // The refresh token is dead (revoked/expired) — clear it so later
      // requests fail fast to login instead of re-running the doomed
      // refresh cycle on every burst of 401s.
      await _clearTokens();
      authGuardCubit.triggerUnauthenticated();
    }
    return handler.next(err);
  }

  Future<void> _clearTokens() async {
    try {
      await localStorageService.remove(ATStrings.accessToken);
      await localStorageService.remove(ATStrings.refreshToken);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Returns true when tokens were rotated, false when the refresh token was
  /// definitively rejected (or absent), and null on transient failures.
  Future<bool?> _refreshTokens(String baseUrl) async {
    String? refreshToken;
    try {
      refreshToken = await localStorageService.get(ATStrings.refreshToken);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final Dio tokenDio = Dio(BaseOptions(
        baseUrl: baseUrl,
        contentType: 'application/json',
      ));
      final Response<dynamic> response = await tokenDio.post(
        '/api/v1/auth/refresh',
        data: <String, dynamic>{'refresh_token': refreshToken},
      );

      final Map<String, dynamic> responseData = response.data is Map ? response.data : {};
      final String? newAccessToken = responseData['access_token'] ?? responseData['data']?['access_token'];
      final String? newRefreshToken = responseData['refresh_token'] ?? responseData['data']?['refresh_token'];
      if (newAccessToken == null || newRefreshToken == null) {
        debugPrint('REFRESH TOKEN FAILED: Missing tokens in response. Data: ${response.data}');
        return false;
      }

      await localStorageService.set(ATStrings.accessToken, newAccessToken);
      await localStorageService.set(ATStrings.refreshToken, newRefreshToken);
      return true;
    } on DioException catch (e) {
      debugPrint('REFRESH TOKEN FAILED: $e');
      debugPrint('REFRESH ERROR RESPONSE: ${e.response?.data}');
      final int? code = e.response?.statusCode;
      if (code == 400 || code == 401 || code == 403) {
        return false;
      }
      return null;
    } catch (e) {
      debugPrint('REFRESH TOKEN FAILED: $e');
      return null;
    }
  }

  Future<Response<dynamic>> _retry(
    RequestOptions options,
    String accessToken,
  ) {
    options.headers['Authorization'] = 'Bearer $accessToken';
    final Dio retryDio = Dio(BaseOptions(baseUrl: options.baseUrl));
    return retryDio.fetch(options);
  }
}


final AuthGuardCubit authGuardCubit = AuthGuardCubit();
class AuthGuardCubit extends Cubit<bool> {
  AuthGuardCubit() : super(false);

  bool _hasHandledUnAuthentication = false;

  void triggerUnauthenticated() {
    if (_hasHandledUnAuthentication) return;

    _hasHandledUnAuthentication = true;
    emit(true);
  }

  void reset() {
    _hasHandledUnAuthentication = false;
    emit(false);
  }
}
