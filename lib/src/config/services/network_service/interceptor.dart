import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/logging/app_logger.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ATInterceptorClass extends Interceptor {
  ATInterceptorClass({
    required this.localStorageService,
    required this.authGuardCubit,
  });

  final ATLocalStorageService localStorageService;
  final AuthGuardCubit authGuardCubit;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains('auth/') && 
      !options.path.contains('logout') && 
      !options.path.contains('set-pin') ) {
      return handler.next(options);
    }

    try {
      final String? token =
          await localStorageService.get(ATStrings.accessToken);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e, st) {
      AppLogger.instance.error('Failed to attach auth token',
          error: e, stackTrace: st, tag: 'ATInterceptor');
    }

    return handler.next(options);
  }


  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final int? statusCode = err.response?.statusCode;
    if (statusCode == 401) {
      authGuardCubit.triggerUnauthenticated();
    }

    return handler.next(err);
  }
}


final AuthGuardCubit authGuardCubit = AuthGuardCubit();
class AuthGuardCubit extends Cubit<bool> {
  AuthGuardCubit() : super(false);

  bool _hasHandledUnAuthentication = false;

  void triggerUnauthenticated() {
    AppLogger.instance.debug(
        'This is the value of hasHandledAuth $_hasHandledUnAuthentication',
        tag: 'AuthGuard');

    if (_hasHandledUnAuthentication) return;

    _hasHandledUnAuthentication = true;
    emit(true);
  }

  void reset() {
    _hasHandledUnAuthentication = false;
    // emit(false);
  }
}
