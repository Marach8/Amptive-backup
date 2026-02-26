import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/home/data/models/follow_creator_response_model.dart';
import 'package:amptive/src/features/home/data/repository/home_repo.dart';
import 'package:amptive/src/features/home/data/repository/home_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowCreatorCubit extends Cubit<ATAppState<FollowResponseModel>>  {
  FollowCreatorCubit ({
    HomeRepo ? mockHomeRepo
  }): homeRepo =mockHomeRepo ?? HomeRepoImpl(),
  super (const InitialState<FollowResponseModel>());

  final HomeRepo homeRepo;

  Future<void> followCreator ({
    required String targetUserId
  }) async {
    emit(const LoadingState<FollowResponseModel>());
    try{
      final ApiResponse<FollowResponseModel> response = await homeRepo.followCreator(targetUserId: targetUserId);

      response.when(
        successful: (Successful<FollowResponseModel> data) {
          emit(SuccessState<FollowResponseModel>(newData: data.data));
        },
         unSuccessful: (Unsuccessful<FollowResponseModel> error) {
          emit(FailureState<FollowResponseModel>(error.error.message)
          );
          
    },
      );
    }catch (e) {
      emit(FailureState<FollowResponseModel>('Unable to follow creator: $e'));
    }
  }
}