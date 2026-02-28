import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/data/models/request/create_show_model.dart';
import 'package:amptive/src/features/go_live/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateShowCubit extends Cubit<ATAppState<HostedShow>> {
  CreateShowCubit({GoLiveRepo? mockGoLiveRepo})
      : goLiveRepo = mockGoLiveRepo ?? GoLiveRepoImpl(),
        super(const InitialState<HostedShow>());

  final GoLiveRepo goLiveRepo;

  Future<void> createShow({
    required String title,
    required String description,
    required String coverUrl,
    required String category,
    required String showType,
    required double price,
    required List<String> tagIds,
    required List<String> coHostIds,
  }) async {
        emit(const LoadingState<HostedShow>());
    try {
      final CreateShowModel createShowModel = CreateShowModel(
        title: title,
        description: description,
        coverUrl: coverUrl,
        category: category,
        showType: showType,
        price: price,
        tagIds: tagIds,
        coHostIds: coHostIds,
      );

      final ApiResponse<HostedShow> response = await goLiveRepo.createShow(
        createShowModel: createShowModel,
      );
      response.when(
        successful: (Successful<HostedShow> data) {
          emit(SuccessState<HostedShow>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<HostedShow> error) {
          emit(FailureState<HostedShow>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<HostedShow>('Unable to create show: $e'));
    }
  }
}
