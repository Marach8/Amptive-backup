import 'dart:convert';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:flutter/material.dart' show visibleForTesting;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageServiceImpl implements ATLocalStorageService {
  factory FlutterSecureStorageServiceImpl({
    FlutterSecureStorage? mockFlutterSecureStorage,
  }) {
    _instance ??= FlutterSecureStorageServiceImpl._internal(
        prefs: mockFlutterSecureStorage ?? const FlutterSecureStorage(
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device
          )
        ));
    return _instance!;
  }

  FlutterSecureStorageServiceImpl._internal({required this.prefs});

  static FlutterSecureStorageServiceImpl? _instance;

  final FlutterSecureStorage prefs;

  @visibleForTesting
  static void resetInstance() => _instance = null;

  @override
  Future<void> clear() async => await prefs.deleteAll();

  @override
  Future<String?> get(String key) async => await prefs.read(key: key);

  @override
  Future<void> remove(String key) async => await prefs.delete(key: key);

  @override
  Future<void> set(String key, String? data) async =>
      await prefs.write(key: key, value: data.toString());

  @override
  Future<void> setObject<T>(String key, T value) async {
    final String valueString = _encode(value);
    await prefs.write(key: key, value: valueString);
  }

  @override
  Future<T?> getObject<T>(String key) async {
    final String? valueString = await prefs.read(key: key);
    if (valueString != null) {
      return _decode<T>(valueString);
    }
    return null;
  }

  String _encode<T>(T value) {
    if (T == String) {
      return value as String;
    } else if (T == int || T == double || T == bool) {
      return value.toString();
    } else {
      return json.encode(value);
    }
  }

  T _decode<T>(String valueString) {
    if (T == String) {
      return valueString as T;
    } else if (T == int) {
      return int.parse(valueString) as T;
    } else if (T == double) {
      return double.parse(valueString) as T;
    } else if (T == bool) {
      return (valueString.toLowerCase() == "true") as T;
    } else {
      return json.decode(valueString) as T;
    }
  }
}
