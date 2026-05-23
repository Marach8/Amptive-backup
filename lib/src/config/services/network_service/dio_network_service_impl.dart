import 'dart:async';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/network_service/interceptor.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioNetworkServiceImpl implements NetworkService {
  factory DioNetworkServiceImpl({Dio? dio}) {
    _instance ??= DioNetworkServiceImpl._internal(
      dio ?? _createDefaultDio(),
    );
    return _instance!;
  }

  DioNetworkServiceImpl._internal(this._dio);

  static DioNetworkServiceImpl? _instance;
  final Dio _dio;

  @visibleForTesting
  static void resetInstance() => _instance = null;

  static Dio _createDefaultDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ATEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
        contentType: 'application/json',
        validateStatus: (int? code) => code != null && code < 300,
      ),
    );

    dio.interceptors.addAll(<Interceptor>[
      ATInterceptorClass(
        localStorageService: FlutterSecureStorageServiceImpl(),
        authGuardCubit: authGuardCubit,
      ),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
    ]);

    return dio;
  }

  @override
  Future<Response<dynamic>> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _dio.get(uri, queryParameters: queryParameters);

  @override
  Future<Response<dynamic>> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _dio.post(uri, data: data, queryParameters: queryParameters);

  @override
  Future<Response<dynamic>> patch(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _dio.patch(uri, data: data, queryParameters: queryParameters);

  @override
  Future<Response<dynamic>> delete(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _dio.delete(uri, data: data, queryParameters: queryParameters);

  @override
  Future<Response<dynamic>> put(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _dio.put(uri, data: data, queryParameters: queryParameters);

  @override
  Future<Response<dynamic>> formDataRequest(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _dio.post(
        uri,
        data: FormData.fromMap(data),
        options: Options(contentType: 'multipart/form-data'),
      );

  @override
  Future<Response<dynamic>> patchFormDataRequest(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _dio.patch(
        uri,
        data: FormData.fromMap(data),
        options: Options(contentType: 'multipart/form-data'),
      );
}
