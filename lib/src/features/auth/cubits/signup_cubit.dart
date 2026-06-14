import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/features/auth/data/models/response/auth_success_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';

enum SignupStage {
  stage1("We are creating your account"),
  stage2("Join or create live audio events"),
  stage3("Subscribe and support creators"),
  stage4("We are creating your account");

  const SignupStage(this.value);
  final String value;
}

class SignupCubit extends Cubit<ATAppState<SignupStage>> {
  SignupCubit({
    AuthRepo? mockAuthRepo,
    ATLocalStorageService? mockLocalStorageService,
  })  : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        localStorageService =
            mockLocalStorageService ?? FlutterSecureStorageServiceImpl(),
        super(const InitialState<SignupStage>());

  final AuthRepo authRepo;
  final ATLocalStorageService localStorageService;
  bool _cancelStagesFuture = false;

  Future<void> signupUser({
    required RegistrationData param,
  }) async {
    _cancelStagesFuture = false;

    try {
      await Future.wait(<Future<void>>[
        _runSignupStages(),
        _performSignup(param),
      ], eagerError: true);

      emit(const SuccessState<SignupStage>());
    } catch (e) {
      _cancelStagesFuture = true;
      emit(
        FailureState<SignupStage>(e.toString()),
      );
    }
  }

  Future<void> _runSignupStages() async {
    const List<SignupStage> stages = SignupStage.values;

    for (int i = 0; i < stages.length; i++) {
      if (_cancelStagesFuture) return;

      emit(
        LoadingState<SignupStage>(currentData: stages[i]),
      );

      if (i < stages.length - 1) {
        await Future<void>.delayed(
          const Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> _performSignup(RegistrationData param) async {
    final ApiResponse<SignUpResponseModel> response =
        await authRepo.registerUser(param: param);

    await response.when(
      successful: (Successful<SignUpResponseModel> data) async {
        final SignUpResponseModel? responseModel = data.data;

        final String? accessToken = responseModel?.accessToken;
        final String? userName = responseModel?.user?.username;
        final String? email = responseModel?.user?.email;
        final String? name = responseModel?.user?.name;
        final String? userId = responseModel?.user?.id;
        final String? dob = responseModel?.user?.dob;
        final String? phoneNumber = responseModel?.user?.phoneNumber;
        final String? pictureUrl = responseModel?.user?.pictureUrl;

        if (accessToken != null) {
          await localStorageService.set(
            ATStrings.accessToken, accessToken,
          );
        }

        final ProfileData cachedUserData =
          ProfileData(
            userId: userId,
            email: email,
            username: userName,
            name: name,
            dob: dob,
            profilePhoto: pictureUrl,
            phoneNumber: phoneNumber,
          );

        await localStorageService.setObject(
          ATStrings.cachedUserData,
          cachedUserData.toLocalStorageJson(),
        );

        await localStorageService.set(
          ATStrings.isExistingUser, 'true',
        );
      },
      unSuccessful: (Unsuccessful<SignUpResponseModel> error) {
        throw error.error.message;
      },
    );
  }
}
