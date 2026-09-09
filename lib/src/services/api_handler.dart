import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

MockClient integrationTestMockClient = MockClient((http.Request request) async {
  switch (request.url.toString()) {
    case 'https://staging.company.com/api/customer/123':
      return http.Response('{"customer": "123", "name": "Jane Jimmy"}', 200);
    case 'https://staging.company.com/api/customer/155':
      return http.Response('{"customer": "155", "name": "Gregor"}', 200);
    default:
      return http.Response('{"customer": "155", "name": "Gregor"}', 200);
  }
});

class APIHandler extends BaseAPI {
  Future<RegisterResponse?> register(
      String name, String username, String email, String password) async {
    final String body = jsonEncode(<String, Map<String, String>>{
      'user': <String, String>{
        'name': name,
        'email': email,
        'username': username,
        'password': password,
      }
    });

    // todo: call api with registration details
    // http.Response response = await http.post(super.customersPath as Uri,
    //     headers: super.headers, body: body);

    return await Future.delayed(const Duration(seconds: 5), () {
      final RegisterResponse temp = RegisterResponse();
      temp.id = 452;
      temp.username = username;
      temp.email = email;
      return temp;
    });
  }

  Future<LoginResponse?> login(String email, String password) async {
    // todo: call api with login details

    return await Future.delayed(const Duration(seconds: 3), () {
      final LoginResponse temp = LoginResponse();
      temp.id = 101;
      temp.username = 'James';
      temp.email = email;
      return temp;
    });
  }

  Future<bool> checkEmailExists(String email) async {
    final List<String> dummyEmailList = <String>[
      'peter@gmail.com',
      'paul@gmail.com',
      'magnus@gmail.com',
    ];

    return await Future.delayed(const Duration(seconds: 3), () {
      return dummyEmailList.contains(email);
    });
  }
}

class LoginResponse {
  LoginResponse({this.id, this.email, this.username});

  factory LoginResponse.fromResponseBody(String body) {
    final Map<String, dynamic> json = jsonDecode(body);

    return LoginResponse(
      id: json['id'],
      email: json['email'],
      username: json['username'],
    );
  }
  int? id;
  String? username;
  String? email;
}

class RegisterResponse {
  RegisterResponse({this.id, this.email, this.username});

  factory RegisterResponse.fromResponseBody(String body) {
    final Map<String, dynamic> json = jsonDecode(body);

    return RegisterResponse(
      id: json['id'],
      email: json['email'],
      username: json['username'],
    );
  }
  int? id;
  String? username;
  String? email;
}

class BaseAPI {
  static String base = 'http://localhost:3000';
  static String api = '$base/api/v1';
  String customersPath = '$api/customers';
  String authPath = '$api/auth';

// more routes
  Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  };
}
