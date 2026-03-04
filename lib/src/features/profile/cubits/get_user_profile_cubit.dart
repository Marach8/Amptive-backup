import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo.dart';
import 'package:amptive/src/features/profile/data/repository/profile_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetUserProfileCubit extends Cubit<ATAppState<dynamic>> {
  GetUserProfileCubit({
    ProfileRepo ? mockProfileRepo
  }): profileRepo = mockProfileRepo ?? ProfileRepoImpl(),
  super (const InitialState<dynamic>());

  final ProfileRepo profileRepo;
  

}
