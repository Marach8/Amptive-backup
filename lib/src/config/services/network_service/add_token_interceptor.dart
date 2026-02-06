import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class AddTokenInterceptor extends Interceptor {
  AddTokenInterceptor({required this.localStorageService});

  final ATLocalStorageService localStorageService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains('auth/') && !options.path.contains('logout')) {
      return handler.next(options);
    }

    try {
      final String? token = await localStorageService.get(ATStrings.accessToken);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return handler.next(options);
  }
}
