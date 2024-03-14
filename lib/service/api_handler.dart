import 'dart:convert';

import 'package:amptive/utils/base_api.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

MockClient integrationTestMockClient = MockClient((request) async {
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
    var body = jsonEncode({
      'user': {
        'name': name,
        'email': email,
        'username': username,
        'password': password,
      }
    });

    // todo: call api with registration details
    // http.Response response = await http.post(super.customersPath as Uri,
    //     headers: super.headers, body: body);

    return await Future.delayed(const Duration(seconds: 10), () {
      var temp = RegisterResponse();
      temp.id = 452;
      temp.username = username;
      temp.email = email;
      return temp;
    });
  }

  Future<LoginResponse?> login(String email, String password) async {
    // todo: call api with login details

    return await Future.delayed(const Duration(seconds: 5), () {
      var temp = LoginResponse();
      temp.id = 101;
      temp.username = "James";
      temp.email = email;
      return temp;
    });
  }

  Future<bool> checkEmailExists(String email) async {
    List<String> dummyEmailList = [
      "peter@gmail.com",
      "paul@gmail.com",
      "magnus@gmail.com",
    ];

    return await Future.delayed(const Duration(seconds: 5), () {
      return dummyEmailList.contains(email);
    });

  }
}

class LoginResponse {
  int? id;
  String? username;
  String? email;

  LoginResponse({this.id, this.email, this.username});

  factory LoginResponse.fromResponseBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return LoginResponse(
      id: json['id'],
      email: json['email'],
      username: json['username'],
    );
  }
}

class RegisterResponse {
  int? id;
  String? username;
  String? email;

  RegisterResponse({this.id, this.email, this.username});

  factory RegisterResponse.fromResponseBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return RegisterResponse(
      id: json['id'],
      email: json['email'],
      username: json['username'],
    );
  }
}
