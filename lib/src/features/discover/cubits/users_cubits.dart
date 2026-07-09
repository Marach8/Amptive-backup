import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/all_users_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_users_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllUsersCubit extends Cubit<ATAppState<AllUsersResponseModel>> {
  AllUsersCubit({DiscoverRepo? mockDiscoverRepo})
      : discoverRepo = mockDiscoverRepo ?? DiscoverRepoImpl(),
        super(const InitialState<AllUsersResponseModel>());

  final DiscoverRepo discoverRepo;
  List<User> _cachedUsers = <User>[];

  AllUsersResponseModel? get currentUsersData => switch (state) {
        InitialState<AllUsersResponseModel>(
          :final AllUsersResponseModel? initialData
        ) =>
          initialData,
        LoadingState<AllUsersResponseModel>(
          :final AllUsersResponseModel? currentData
        ) =>
          currentData,
        SuccessState<AllUsersResponseModel>(
          :final AllUsersResponseModel? newData
        ) =>
          newData,
        FailureState<AllUsersResponseModel>(
          :final AllUsersResponseModel? oldData
        ) =>
          oldData,
      };

  Future<void> fetchAllUsers() async {
    final bool hasMore = currentUsersData?.hasMore ?? true;
    if (state is LoadingState<AllUsersResponseModel> || !hasMore) {
      return;
    }

    emit(LoadingState<AllUsersResponseModel>(currentData: currentUsersData));

    try {
      final ApiResponse<AllUsersResponseModel> response =
      await discoverRepo.fetchAllUsers(
        page: (currentUsersData?.page ?? 0) + 1, 
        pageSize: 20
      );
      response.when(
        successful: (Successful<AllUsersResponseModel> data) {
          final List<User>? newUsers = data.data?.data;
          final List<User>? currentUsers = currentUsersData?.data;

          final List<User> mergedUsers = <User>[...?currentUsers, ...?newUsers];
          // Cache the full merged set so clearing a search restores every
          // loaded page, not just the last one.
          _cachedUsers = mergedUsers;
          final AllUsersResponseModel? newData = currentUsersData?.copyWith(
            data: mergedUsers,
            page: data.data?.page,
            totalPages: data.data?.totalPages,
            pageSize: data.data?.pageSize,
            message: data.data?.message,
          ) ?? data.data;
          emit(SuccessState<AllUsersResponseModel>(newData: newData));
        },
        unSuccessful: (Unsuccessful<AllUsersResponseModel> error) {
          emit(FailureState<AllUsersResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<AllUsersResponseModel>('Unable to get users: $e'));
    }
  }

  /// Keeps paging until there are at least [target] users with an avatar
  /// (used to fill the cohost "Suggestions" list, which only shows users
  /// who have a photo) or there are no more pages to load.
  Future<void> loadSuggestionsWithAvatars({int target = 10}) async {
    bool hasAvatar(User u) => u.profilePicture?.trim().isNotEmpty ?? false;

    for (int i = 0; i < 8; i++) {
      // Let any in-flight load finish before checking/fetching again.
      if (state is LoadingState<AllUsersResponseModel>) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
      final int avatarCount =
          (currentUsersData?.data ?? const <User>[]).where(hasAvatar).length;
      if (avatarCount >= target) return;
      if (!(currentUsersData?.hasMore ?? true)) return;
      await fetchAllUsers();
    }
  }


  Future<void> searchUsers(String query) async {
    final String q = query.trim();

    // Cleared search — restore the full loaded list.
    if (q.isEmpty) {
      emit(SuccessState<AllUsersResponseModel>(
        newData: currentUsersData?.copyWith(data: _cachedUsers),
      ));
      return;
    }

    // The user-search API requires at least 3 characters; keep showing the
    // current list until then rather than firing partial queries.
    if (q.length < 3) return;

    emit(LoadingState<AllUsersResponseModel>(currentData: currentUsersData));

    try {
      // Query the backend so any user in the DB is found — not just the
      // handful already paged into memory.
      final ApiResponse<SearchUsersResponseModel> response =
          await discoverRepo.searchUsers(
        query: q,
        page: 1,
        pageSize: 50,
        sortBy: 'relevance',
      );
      response.when(
        successful: (Successful<SearchUsersResponseModel> data) {
          final List<User> users = data.data?.data ?? <User>[];
          // Empty results are a normal state, not an error — emit success
          // with an empty list so the UI shows an inline empty message
          // instead of a red error drawer.
          emit(SuccessState<AllUsersResponseModel>(
            newData: currentUsersData?.copyWith(data: users),
          ));
        },
        unSuccessful: (Unsuccessful<SearchUsersResponseModel> error) {
          emit(FailureState<AllUsersResponseModel>(error.error.message,
              oldData: currentUsersData));
        },
      );
    } catch (e) {
      emit(FailureState<AllUsersResponseModel>('Search failed: $e',
          oldData: currentUsersData));
    }
  }

  void resetSearch() => emit(SuccessState<AllUsersResponseModel>(
    newData: currentUsersData?.copyWith(
      data: _cachedUsers,
    ),
  ));
}
