import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowersCubit  extends Cubit<ATAppState<dynamic>>{
  FollowersCubit ({
    ProfileRepo ? mockProfileRepo
  }): profileRepo = mockProfileRepo ?? ProfileRepoImpl(),
  super (const InitialState<dynamic>());

  final ProfileRepo profileRepo;
   dynamic get currentFollowers => switch (state) {
    InitialState<dynamic>(:final dynamic initialData) =>
      initialData,
    LoadingState<dynamic>(:final dynamic currentData) =>
      currentData,
    SuccessState<dynamic>(:final dynamic newData) =>
      newData,
    FailureState<dynamic>(:final dynamic oldData) =>
      oldData,
  };


  Future<void> fetchFollowers () async {
    final dynamic currentData = currentFollowers;
    final bool hasMoreItems = (currentData?['hasMore']);

    emit(LoadingState<dynamic>(currentData: currentData));
    try{
     final int page = ((currentData?['currentPage'] as int?) ?? 0) + 1;

     final ApiResponse<dynamic> response = await profileRepo.fetchFollowers(
      pageNo: page, 
     pageSize: 50
     );

     response.when(
      successful: (Successful<dynamic> data) {
        emit(SuccessState<dynamic>(newData: data.data));
      }, 
      unSuccessful: (Unsuccessful<dynamic> error){
        emit(FailureState<dynamic>(error.error.message));
      });
    } catch (e) {
      emit(FailureState<dynamic>('Unable to fetch followers :$e'));
    }

  }
}
