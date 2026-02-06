import 'package:dio/dio.dart';

abstract class NetworkService {
  Future<Response<dynamic>> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<dynamic>> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<dynamic>> put(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<dynamic>> patch(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<dynamic>> patchFormDataRequest(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<dynamic>> delete(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<dynamic>> formDataRequest(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
