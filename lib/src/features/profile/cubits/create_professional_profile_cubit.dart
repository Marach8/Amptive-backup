import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProfessionalProfileCubit extends Cubit<ATAppState<dynamic>> {
  CreateProfessionalProfileCubit({ProfileRepo? mockProfileRepo})
      : profileRepo = mockProfileRepo ?? ProfileRepoImpl(),
        super(const InitialState<dynamic>());

  final ProfileRepo profileRepo;

  Future<void> createProfessionalProfile({
    required String profileType,
    required String category,
    required String subAmount,
    required String coHostFee,
  }) async {
    emit(const LoadingState<dynamic>());

    try {
      final ApiResponse<dynamic> response =
          await profileRepo.createProfessionalProfile(
        profileType: profileType,
        category: category,
        subAmount: subAmount,
        coHostFee: coHostFee,
      );

      response.when(
        successful: (Successful<dynamic> data) {
          emit(SuccessState<dynamic>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<dynamic>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<dynamic>('Unable to create professional profile: $e'));
    }
  }
}
