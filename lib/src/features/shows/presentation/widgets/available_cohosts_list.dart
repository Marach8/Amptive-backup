import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/discover/data/models/response/all_users_response_model.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/shows/presentation/widgets/cohost_with_check_icon.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              final List<User> cohosts = usersData?.data ?? <User>[];

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
                return const Center(child: Text('No cohosts available yet'));
              }

              final bool hasMore = usersData?.hasMore ?? false;
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
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text(ATStrings.suggestions,
                            style: context.textTheme.bodySmall
                                ?.copyWith(fontSize: ATSizes.size16)),
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
                    ?.copyWith(fontSize: ATSizes.size16)),
          );
        }

        return const CohostWithCheckIconShimmer();
      },
    );
  }
}
