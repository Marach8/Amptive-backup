import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo_impl.dart';

class ShowDetailCubit extends Cubit<ATAppState<HostedShow>> {
  ShowDetailCubit({
    ShowsRepo? mockShowsRepo,
    required HostedShow initialShow,
  })  : showsRepo = mockShowsRepo ?? ShowsRepoImpl(),
        super(InitialState<HostedShow>(initialData: initialShow));

  final ShowsRepo showsRepo;

  HostedShow? get currentShowDetail => switch (state) {
        InitialState<HostedShow>(:final HostedShow? initialData) => initialData,
        LoadingState<HostedShow>(:final HostedShow? currentData) => currentData,
        SuccessState<HostedShow>(:final HostedShow? newData) => newData,
        FailureState<HostedShow>(:final HostedShow? oldData) => oldData,
      };

  Future<void> fetchShowDetails() async {
    if (state is LoadingState<HostedShow>) return;
    emit(LoadingState<HostedShow>(currentData: currentShowDetail));
    try {
      final ApiResponse<HostedShow> response =
          await showsRepo.fetchShow(showId: currentShowDetail?.showId ?? '');
      response.when(
        successful: (Successful<HostedShow> data) {
          emit(SuccessState<HostedShow>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<HostedShow> error) {
          emit(
            FailureState<HostedShow>(
              error.error.message,
              oldData: currentShowDetail,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        FailureState<HostedShow>(
          'Unable to fetch show: $e',
          oldData: currentShowDetail,
        ),
      );
    }
  }
}
