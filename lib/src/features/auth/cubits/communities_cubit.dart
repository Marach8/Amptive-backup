import 'package:amptive/src/features/auth/data/models/response/communities_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';

class CommunitiesCubit extends Cubit<ATAppState<CommunitiesResponseModel>> {
  CommunitiesCubit({
    AuthRepo? mockAuthRepo,
  }) : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        super(const InitialState<CommunitiesResponseModel>());

  final AuthRepo authRepo;

  CommunitiesResponseModel? get currentCommunities => switch (state) {
    InitialState<CommunitiesResponseModel>(
      :final CommunitiesResponseModel? initialData) => initialData,
    LoadingState<CommunitiesResponseModel>(
      :final CommunitiesResponseModel? currentData) => currentData,
    SuccessState<CommunitiesResponseModel>(
      :final CommunitiesResponseModel? newData) => newData,
    FailureState<CommunitiesResponseModel>(
      :final CommunitiesResponseModel? oldData) => oldData,
  };

  Future<void> fetchCommunities() async {
    emit(const LoadingState<CommunitiesResponseModel>());
    try {
      final ApiResponse<CommunitiesResponseModel> response = await authRepo.fetchCommunities();
      response.when(
        successful: (Successful<CommunitiesResponseModel> data) {
          emit(SuccessState<CommunitiesResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<CommunitiesResponseModel> error) {
          emit(
            FailureState<CommunitiesResponseModel>(error.error.message),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<CommunitiesResponseModel>('Unable to get communities: $e'),
      );
    }
  }
}
