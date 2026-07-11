import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

class ATException implements Exception {
  ATException(this.message, {this.code});

  final String message;
  final int? code;

  static ATException resolveException(dynamic err) {
    if (err is SocketException) {
      return InternetConnectException(kInternetConnectionError, 0);
    } else if (err is TimeoutException) {
      return OtherExceptions(err.message ?? kTimeOutError, 0);
    } else if (err is DioException) {
      final List<dynamic>? errors = err.response?.data?['errors'];

      if (errors != null) {
        final List<String> messages = <String>[];

        for (final dynamic error in errors) {
          if (error is Map<String, dynamic>) {
            final String? message = error['message'] as String?;
            if (message != null && message.trim().isNotEmpty) {
              messages.add('• $message');
            }
          }
        }

        if (messages.isNotEmpty) {
          return OtherExceptions(
            messages.join('\n'),
            err.response?.statusCode,
          );
        }
      }

      switch (err.type) {
        case DioExceptionType.cancel:
          return OtherExceptions(
            kRequestCancelledError,
            err.response?.statusCode,
          );

        case DioExceptionType.connectionError:
          return InternetConnectException(
            kInternetConnectionError,
            err.response?.statusCode ?? 0,
          );

        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return InternetConnectException(
            kTimeOutError,
            err.response?.statusCode ?? 0,
          );

        // case DioExceptionType.badResponse:
        // case DioExceptionType.badCertificate:
        // case DioExceptionType.unknown:
        default:
          String? extractMsg(dynamic data) {
            if (data == null) return null;
            if (data is String) return data;
            if (data is Map) {
              return (data['detail'] ?? data['message'] ?? data['error'])
                  ?.toString();
            }
            return data.toString();
          }

          switch (err.response?.statusCode) {
            case 500:
            case 502:
              return InternalServerException(
                msg: kServerError,
                statusCode: err.response?.statusCode,
              );
            case 400:
            case 403:
              return OtherExceptions(
                extractMsg(err.response?.data),
                err.response?.statusCode,
              );
            case 401:
              return UnAuthorizedException(
                statusCode: err.response?.statusCode,
              );
            case 404:
              return OtherExceptions(kUserNotFound, err.response?.statusCode);
            case 413:
              return OtherExceptions(kFileTooLarge, err.response?.statusCode);
            case 409:
              return OtherExceptions(
                extractMsg(err.response?.data),
                err.response?.statusCode,
              );
            default:
              return OtherExceptions(
                extractMsg(err.response?.data),
                err.response?.statusCode,
              );
          }
      }
    } else {
      return OtherExceptions(null, 0);
    }
  }
}

class OtherExceptions implements ATException {
  OtherExceptions(this.msg, this.statusCode);

  final int? statusCode;
  final String? msg;

  @override
  String get message => msg ?? kDefaultError;

  @override
  int? get code => statusCode;
}

class InternetConnectException implements ATException {
  InternetConnectException(this.newMessage, this.statusCode);

  final String newMessage;
  final int statusCode;

  @override
  String get message => newMessage;

  @override
  int? get code => statusCode;
}

class InternalServerException implements ATException {
  InternalServerException({required this.statusCode, this.msg});

  final int? statusCode;
  final String? msg;

  @override
  String get message => msg ?? kServerError;

  @override
  int? get code => statusCode;
}

class UnAuthorizedException implements ATException {
  UnAuthorizedException({required this.statusCode});

  final int? statusCode;

  @override
  String get message => kInvalidCredential;

  @override
  int? get code => statusCode;
}

const String kInternetConnectionError =
    'Connection Error! Please confirm that you are connected to the internet.';
const String kTimeOutError =
    'Connection timeout. Please check your internet connection.';
const String kServerError =
    'Oops! A problem occurred in the server, Please contact admin';
const String kFormatError = 'Unable to process data at this time.';
const String kInvalidCredential = 'Invalid request credential(s)!';
const String kDefaultError =
    'Oops something went wrong! Please try after some time';
const String kBadRequestError = 'Invalid Credential(s)!';
const String kFileTooLarge = 'File too large.';
const String kUserNotFound = 'User does not exist!';
const String kNotFoundError = 'An error occurred, please try again.';
const String kRequestCancelledError = 'Request to server was cancelled.';
