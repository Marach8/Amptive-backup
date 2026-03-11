import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/profile/data/models/followers_response_model.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowersCubit  extends Cubit<ATAppState<FollowersResponseModel>>{
  FollowersCubit ({
    ProfileRepo ? mockProfileRepo
  }): profileRepo = mockProfileRepo ?? ProfileRepoImpl(),
  super (const InitialState<FollowersResponseModel>());

  final ProfileRepo profileRepo;
   FollowersResponseModel? get currentFollowers => switch (state) {
    InitialState<FollowersResponseModel>(:final FollowersResponseModel? initialData) =>
      initialData,
    LoadingState<FollowersResponseModel>(:final FollowersResponseModel? currentData) =>
      currentData,
    SuccessState<FollowersResponseModel>(:final FollowersResponseModel? newData) =>
      newData,
    FailureState<FollowersResponseModel>(:final FollowersResponseModel? oldData) =>
      oldData,
  };


  Future<void> fetchFollowers () async {
    final bool hasMore = currentFollowers?.hasMore ?? true;
    if (state is LoadingState<FollowersResponseModel> || !hasMore) {
      return;
    }



    emit(LoadingState<FollowersResponseModel>(currentData: currentFollowers));
    try{
     

     final ApiResponse<FollowersResponseModel> response = await profileRepo.fetchFollowers(
      page: (currentFollowers?.page ?? 0) + 1,
     pageSize: 50
     );

     response.when(
      successful: (Successful<FollowersResponseModel> data) {
        emit(SuccessState<FollowersResponseModel>(newData: data.data));
      }, 
      unSuccessful: (Unsuccessful<FollowersResponseModel> error){
        emit(FailureState<FollowersResponseModel>(error.error.message));
      });
    } catch (e) {
      emit(FailureState<FollowersResponseModel>('Unable to fetch followers :$e'));
    }

  }
}
