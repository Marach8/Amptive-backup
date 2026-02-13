import 'package:amptive/src/features/auth/data/models/user_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';

class RegisterUserCubit extends Cubit<ATAppState<UserData>> {
  RegisterUserCubit({AuthRepo? mockAuthRepo})
      : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        super(const InitialState<UserData>(initialData: UserData()));

  final AuthRepo authRepo;

  // Helper to extract data from any state type
  UserData getCurrentData() {
    if (state is InitialState<UserData>) return (state as InitialState<UserData>).initialData ?? const UserData();
    if (state is LoadingState<UserData>) return (state as LoadingState<UserData>).currentData ?? const UserData();
    if (state is SuccessState<UserData>) return (state as SuccessState<UserData>).newData ?? const UserData();
    if (state is FailureState<UserData>) return (state as FailureState<UserData>).oldData ?? const UserData();
    return const UserData();
  }

  void setEmail(String email) {
    final UserData updatedData = getCurrentData().copyWith(email: email);
    emit(SuccessState<UserData>(newData: updatedData));
  }

  void setPhoneNumber(String phoneNumber) {
    final UserData updatedData = getCurrentData().copyWith(phoneNumber: phoneNumber);
    emit(SuccessState<UserData>(newData: updatedData));
  }

  void setName(String name) {
    final UserData updatedData = getCurrentData().copyWith(name: name);
    emit(SuccessState<UserData>(newData: updatedData));
  }

  void setUsername(String username) {
    final UserData updatedData = getCurrentData().copyWith(username: username);
    emit(SuccessState<UserData>(newData: updatedData));
  }

  void setPassword(String password) {
    final UserData updatedData = getCurrentData().copyWith(password: password);
    emit(SuccessState<UserData>(newData: updatedData));
  }

  void setDob(String dob) {
    final UserData updatedData = getCurrentData().copyWith(dob: dob);
    emit(SuccessState<UserData>(newData: updatedData));
  }

  Future<void> registerUser() async {
    final UserData registerData = getCurrentData();
    print("Email: ${registerData.email}, dob: ${registerData.dob} , password: ${registerData.password}, User: ${registerData.username}, Name: ${registerData.name}  phone: ${registerData.phoneNumber}", );

    if (
         registerData.name.isEmpty ||
        registerData.password.isEmpty ||
        registerData.dob.isEmpty ||
        registerData.username.isEmpty) {
      emit(FailureState<UserData>(
        'Please fill in all fields',
        oldData: registerData,
      ));
      return;
    }

    emit(LoadingState<UserData>(currentData: registerData));

    try {
      final Map<String, String> param = <String, String>{
       if ( registerData.email != null) 'email': registerData.email!,
        if (registerData.phoneNumber != null)'phone_number': registerData.phoneNumber!,
        'name': registerData.name,
        'password': registerData.password,
        'dob': registerData.dob,
        'username': registerData.username,
      };

      final ApiResponse<dynamic> response = await authRepo.registerUser(param: param);

      response.when(
        successful: (Successful<dynamic> data) {
          emit(SuccessState<UserData>(
            newData: registerData,
            message: data.data,
          ));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<UserData>(
            error.error.message,
            oldData: registerData,
          ));
        },
      );
    } catch (e) {
      emit(FailureState<UserData>(
        'Registration failed: $e',
        oldData: registerData,
      ));
    }
  }
}