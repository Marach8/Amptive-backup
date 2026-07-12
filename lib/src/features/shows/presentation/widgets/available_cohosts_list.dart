import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/discover/data/models/response/all_users_response_model.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/shows/presentation/widgets/cohost_with_check_icon.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';

class AvailableCohostsList extends StatelessWidget {
  const AvailableCohostsList({
    super.key,
    required this.scrollController,
    required this.selectionMode,
  });

  final ScrollController scrollController;
  final CohostSelectionMode selectionMode;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllUsersCubit, ATAppState<AllUsersResponseModel>>(
        listener: (_, ATAppState<AllUsersResponseModel> state) {
      if (state is FailureState<AllUsersResponseModel>) {
        showAppNotification2(
            context: context,
            text: state.message,
            type: NotificationType.failure);
      }
    }, builder: (_, ATAppState<AllUsersResponseModel> state) {
      return switch (state) {
        InitialState<AllUsersResponseModel>() => const SizedBox.shrink(),
        LoadingState<AllUsersResponseModel>() ||
        FailureState<AllUsersResponseModel>() ||
        SuccessState<AllUsersResponseModel>() =>
          Builder(
            builder: (_) {
              final AllUsersResponseModel? usersData =
                  context.read<AllUsersCubit>().currentUsersData;
              final List<User> allCohostsRaw = usersData?.data ?? <User>[];
              final String? currentUserId = context.read<LocalUserDataCubit>().currentUserData?.userId;
              final List<User> allCohosts = allCohostsRaw.where((User u) => u.userId != currentUserId).toList();

              final bool isSearching =
                  context.read<SearchkeyCubit>().state.trim().isNotEmpty;

              // Suggestions: show up to 10 users that actually have an avatar
              // (skip the no-photo ones for now). Search results are shown as
              // returned.
              final List<User> cohosts = isSearching
                  ? allCohosts
                  : allCohosts
                      .where((User u) =>
                          u.profilePicture?.trim().isNotEmpty ?? false)
                      .take(10)
                      .toList();

              if (cohosts.isEmpty) {
                if (state is LoadingState<AllUsersResponseModel>) {
                  return CohosListInitialLoadingShimmer(
                    scrollController: scrollController,
                  );
                }
                if (state is FailureState<AllUsersResponseModel>) {
                  return Center(
                      child: IconButton(
                    onPressed: () {
                      context.read<AllUsersCubit>().fetchAllUsers();
                    },
                    icon: const Icon(Icons.refresh),
                  ));
                }
                // Quiet inline empty state near the top (title + subtext,
                // like the discover search results) — not a red error drawer.
                final String query = context.read<SearchkeyCubit>().state.trim();
                // Full-width, hard top-left so the text starts flush at the
                // 15px edge — same as the search box, header and list rows.
                return Container(
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Nothing to show here right now.',
                        style: context.textTheme.bodyMedium,
                      ),
                      if (query.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 4),
                        Text(
                          'Anyone matching "$query" will appear here.',
                          style: context.textTheme.labelSmall
                              ?.copyWith(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                );
              }

              // Suggestions are capped at 10 — no "load more". Search results
              // keep their pagination.
              final bool hasMore =
                  isSearching ? (usersData?.hasMore ?? false) : false;
              final int count =
                  hasMore ? cohosts.length + 2 : cohosts.length + 1;

              return BlocBuilder<SelectedCohostsCubit, List<User>>(
                  builder: (_, List<User> selectedCohosts) {
                return ListView.builder(
                  itemCount: count,
                  controller: scrollController,
                  padding: const EdgeInsets.only(right: 10, bottom: 20),
                  itemBuilder: (_, int index) {
                    if (index == 0) {
                      // Only flip to "People" once real search results are
                      // shown — not the instant the query changes (which would
                      // relabel the still-visible suggestions/loading state).
                      final bool showingSearchResults = context
                              .read<SearchkeyCubit>()
                              .state
                              .trim()
                              .isNotEmpty &&
                          state is SuccessState<AllUsersResponseModel>;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text(
                            showingSearchResults
                                ? 'People'
                                : ATStrings.suggestions,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: ATSizes.size16,
                              fontWeight: FontWeight.w600,
                            )),
                      );
                    }

                    final int adjustedIndex = index - 1;
                    if (adjustedIndex < cohosts.length) {
                      final User cohost = cohosts[adjustedIndex];
                      final bool isLastItem = (adjustedIndex == cohosts.length - 1) 
                        && state is! LoadingState<AllUsersResponseModel>;
                      return Padding(
                        padding: EdgeInsets.only(bottom: isLastItem ? 100 : 0),
                        child: CohostWithCheckIconWidget(
                          cohost: cohost,
                          key: ValueKey<String?>(cohost.userId),
                          isSelected: selectedCohosts.contains(cohost),
                          onTap: (bool isSelected) {
                            if (isSelected) {
                              context
                                  .read<SelectedCohostsCubit>()
                                  .removeCohost(cohost);
                            } else {
                              context
                                  .read<SelectedCohostsCubit>()
                                  .addCohost(cohost);
                            }
                          },
                        ),
                      );
                    }

                    if (state is LoadingState<AllUsersResponseModel>) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 100),
                        child: CohostWithCheckIconShimmer(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              });
            },
          )
      };
    });
  }
}

class SelectedCohostsCubit extends Cubit<List<User>> {
  SelectedCohostsCubit({this.initialCohosts})
      : super(initialCohosts ?? <User>[]);

  final List<User>? initialCohosts;

  void addCohost(User cohost) {
    if (state.length == 5) return;

    emit(<User>[...state, cohost]);
  }

  void removeCohost(User cohostToRemove) {
    emit(state.where((User cohost) => cohost.userId != cohostToRemove.userId).toList());
  }
}

class CohosListInitialLoadingShimmer extends StatelessWidget {
  const CohosListInitialLoadingShimmer({
    super.key,
    required this.scrollController,
    this.text,
  });
  final ScrollController scrollController;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 12,
      controller: scrollController,
      padding: const EdgeInsets.only(right: 10, bottom: 20),
      itemBuilder: (_, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Text(text ?? ATStrings.suggestions,
                style: context.textTheme.bodySmall
                    ?.copyWith(
                      fontSize: ATSizes.size16,
                      fontWeight: FontWeight.w600,
                    )),
          );
        }

        return const CohostWithCheckIconShimmer();
      },
    );
  }
}

