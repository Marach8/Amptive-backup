import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/profile/data/models/request/upgrade_account_data.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpgradeAccountCubit extends Cubit<ATAppState<dynamic>> {
  UpgradeAccountCubit({ProfileRepo? mockProfileRepo})
      : profileRepo = mockProfileRepo ?? ProfileRepoImpl(),
        super(const InitialState<dynamic>());

  final ProfileRepo profileRepo;

  Future<void> upgradeAccount({
    required UpgradeProfileData param
  }) async {
    emit(const LoadingState<dynamic>());

    try {
      final ApiResponse<dynamic> response =
          await profileRepo.upgradeAccount(
      param: param
      );

      response.when(
        successful: (Successful<dynamic> data) {
          emit(SuccessState<dynamic>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<dynamic>(error.error.message));
        },
      );
    } catch (__) {
      emit(const FailureState<dynamic>(
        'Unable to upgrade account'));
    }
  }
}
