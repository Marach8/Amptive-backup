import 'package:amptive/src/models/user_model.dart';

import 'api_handler.dart';

class AuthenticationService {


  final APIHandler _apiHandler = APIHandler();

  Future<AmptiveUser?> registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final RegisterResponse? res =
          await _apiHandler.register(name, username, email, password);

      if (res != null) {
        return AmptiveUser(
          id: res.id,
          email: res.email ?? '',
          username: res.username ?? '',
          profilePicture: null, name: ''
        );
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<AmptiveUser?> login(
    String email,
    String password,
  ) async {
    try {
      final LoginResponse? res = await _apiHandler.login(email, password);

      if (res != null) {
        return AmptiveUser(
          id: res.id,
          email: res.email ?? '',
          username: res.username ?? '',
          profilePicture: null, name: '',
        );
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Future<Response> getUserProfileData() async {
  //   //GET USER PROFILE DATA
  // }

  Future<void> logout() async {
    //IMPLEMENT USER LOGOUT
  }

  Future<bool> checkUniqueEmail(String email) async {
    bool exist = await _apiHandler.checkEmailExists(email);
    return exist;
  }

  Future<void> sendOTP(String email) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<bool> checkUniqueUsername(String usr) async {
    await Future.delayed(const Duration(seconds: 3));
    return usr == "peter";
  }

}
