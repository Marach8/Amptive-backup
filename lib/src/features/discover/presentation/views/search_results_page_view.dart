import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/discover/data/models/response/all_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/all_users_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<AllUsersCubit>(create: (_) => AllUsersCubit()),
        BlocProvider<AllHashtagsCubit>(create: (_) => AllHashtagsCubit()),
      ],
      child: const SearchResultsTabsView(),
    );
  }
}

class SearchResultsTabsView extends StatefulWidget {
  const SearchResultsTabsView({super.key});

  @override
  State<SearchResultsTabsView> createState() => _SearchResultsTabsViewState();
}

class _SearchResultsTabsViewState extends State<SearchResultsTabsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ValueNotifier<int> _isTabSelected;
  late ScrollController _hashtagsScrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _isTabSelected = ValueNotifier(0);
    _hashtagsScrollController = ScrollController();
    _hashtagsScrollController.addListener(_onHashtagsScroll);

    _tabController
        .addListener(() => _isTabSelected.value = _tabController.index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllUsersCubit>().fetchAllUsers();
      context.read<AllHashtagsCubit>().fetchHashTags();
    });
  }

  void _onHashtagsScroll() {
    if (_hashtagsScrollController.position.pixels >=
        _hashtagsScrollController.position.maxScrollExtent - 100) {
      context.read<AllHashtagsCubit>().fetchHashTags();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _hashtagsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            splashFactory: NoSplash.splashFactory,
            tabAlignment: TabAlignment.start,
            labelPadding: EdgeInsets.zero,
            indicatorColor: ATColors.transparent,
            padding: const EdgeInsets.only(left: 15),
            isScrollable: true,
            dividerColor: ATColors.hex0D0D0D,
            tabs: <String>['All', 'Shows', 'Events', 'Users', 'Hashtags']
                .asMap()
                .entries
                .map((MapEntry<int, String> tab) {
              return Tab(
                child: ValueListenableBuilder(
                    valueListenable: _isTabSelected,
                    builder: (_, int value, __) {
                      final bool isSelected = tab.key == value;
                      return ATContainer(
                        radius: 20,
                        margin: const EdgeInsets.only(right: 10),
                        color: isSelected
                            ? ATColors.white
                            : ATColors.hex9E9E9E.withOpacity(0.3),
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                        child: Text(
                          tab.value,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: isSelected
                                      ? ATColors.hex0D0D0D
                                      : ATColors.white),
                        ),
                      );
                    }),
              );
            }).toList()),
        ATContainer(
          padding: const EdgeInsets.all(15),
          height: ATHelperFuncs.getScreenHeight(context),
          child: Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Column(
                    children: List<Widget>.generate(
                  10,
                  (_) => SearchItemTile(
                    leadingImagePath: ATImgStrings.weCanDoHardThingsBgImage,
                    title: 'We Can Do Hard Things',
                    trailing: ATContainer(
                      onTap: () {},
                      boxShape: BoxShape.circle,
                      height: 24,
                      width: 24,
                      color: ATColors.hexB6B6B6,
                      child: Icon(
                        Icons.play_arrow,
                        size: 15,
                        color: ATColors.hex0D0D0D,
                      ),
                    ),
                  ),
                )),
                Column(
                    children: List<Widget>.generate(
                  10,
                  (_) => SearchItemTile(
                    leadingImagePath: ATImgStrings.OFFICE_LADIES,
                    isCircular: true,
                    title: 'We Can Do Hard Things',
                    trailing: ATContainer(
                      onTap: () {},
                      boxShape: BoxShape.circle,
                      height: 24,
                      width: 24,
                      color: ATColors.hexB6B6B6,
                      child: Icon(
                        Icons.play_arrow,
                        size: 15,
                        color: ATColors.hex0D0D0D,
                      ),
                    ),
                  ),
                )),
                Column(
                    children: List<Widget>.generate(
                  10,
                  (_) => SearchItemTile(
                    leadingImagePath: ATImgStrings.weCanDoHardThingsBgImage,
                    title: 'We Can Do Hard Things',
                    trailing: ATContainer(
                      onTap: () {},
                      boxShape: BoxShape.circle,
                      height: 24,
                      width: 24,
                      color: ATColors.hexB6B6B6,
                      child: Icon(
                        Icons.play_arrow,
                        size: 15,
                        color: ATColors.hex0D0D0D,
                      ),
                    ),
                  ),
                )),
                BlocConsumer<AllUsersCubit, ATAppState<AllUsersResponseModel>>(
                  listener: (BuildContext context,
                      ATAppState<AllUsersResponseModel> state) {
                    if (state is FailureState<AllUsersResponseModel>) {
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                  builder: (BuildContext context,
                      ATAppState<AllUsersResponseModel> state) {
                    return switch (state) {
                      InitialState<AllUsersResponseModel>() =>
                        const SizedBox.shrink(),
                      LoadingState<AllUsersResponseModel>() ||
                      FailureState<AllUsersResponseModel>() ||
                      SuccessState<AllUsersResponseModel>() =>
                        Builder(
                          builder: (_) {
                            final AllUsersResponseModel? usersData =
                                context.read<AllUsersCubit>().currentUsersData;
                            final List<User> users =
                                usersData?.data ?? <User>[];

                            if (users.isEmpty) {
                              if (state
                                  is LoadingState<AllUsersResponseModel>) {
                                return const _UsersListShimmer();
                              }
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text('No users found'),
                                    TextButton(
                                      onPressed: () => context
                                          .read<AllUsersCubit>()
                                          .fetchAllUsers(),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.all(15),
                              itemCount: users.length,
                              itemBuilder: (BuildContext _, int index) {
                                final User user = users[index];
                                return SearchItemTile(
                                  leadingImagePath: user.profilePicture ?? '',
                                  title: user.name ??
                                      user.username ??
                                      'Unknown User',
                                  trailing:
                                      const Icon(Icons.keyboard_arrow_right),
                                );
                              },
                            );
                          },
                        ),
                    };
                  },
                ),
                BlocConsumer<AllHashtagsCubit,
                    ATAppState<AllHashtagsResponseModel>>(
                  listener: (BuildContext context,
                      ATAppState<AllHashtagsResponseModel> state) {
                    if (state is FailureState<AllHashtagsResponseModel>) {
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                  builder: (BuildContext context,
                      ATAppState<AllHashtagsResponseModel> state) {
                    return switch (state) {
                      InitialState<AllHashtagsResponseModel>() =>
                        const SizedBox.shrink(),
                      LoadingState<AllHashtagsResponseModel>() ||
                      FailureState<AllHashtagsResponseModel>() ||
                      SuccessState<AllHashtagsResponseModel>() =>
                        Builder(
                          builder: (_) {
                            final AllHashtagsResponseModel? hashtagsData =
                                context
                                    .read<AllHashtagsCubit>()
                                    .currentTagsData;
                            final List<HashTag> hashtags =
                                hashtagsData?.hashtags ?? <HashTag>[];

                            if (hashtags.isEmpty) {
                              if (state
                                  is LoadingState<AllHashtagsResponseModel>) {
                                return const _HashtagsListShimmer();
                              }
                              return const Center(
                                  child: Text('No hashtags found'));
                            }

                            return ListView.builder(
                              controller: _hashtagsScrollController,
                              padding: const EdgeInsets.all(15),
                              itemCount: hashtags.length,
                              itemBuilder: (BuildContext _, int index) {
                                final HashTag hashtag = hashtags[index];
                                final bool isLastItem = index == hashtags.length - 1;
                                return Padding(
                                  padding:  EdgeInsets.only(bottom: isLastItem? 200 : 0),
                                  child: _HashtagTile(
                                    hashtag: hashtag,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                    };
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _UsersListShimmer extends StatelessWidget {
  const _UsersListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: 10, // Number of shimmer items to show
      itemBuilder: (_, __) => const _UserTileShimmer(),
    );
  }
}

class _UserTileShimmer extends StatelessWidget {
  const _UserTileShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          ATShimmer(
            height: 50,
            width: 50,
            radius: 25, // Circular
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ATShimmer(
                  height: 14,
                  width: 120,
                  radius: 3,
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    ATShimmer(
                      height: 13,
                      width: 50,
                      radius: 2,
                    ),
                    SizedBox(width: 5),
                    ATShimmer(
                      height: 3,
                      width: 3,
                      radius: 1.5,
                    ),
                    SizedBox(width: 5),
                    ATShimmer(
                      height: 13,
                      width: 80,
                      radius: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          ATShimmer(
            height: 30,
            width: 30,
            radius: 4,
          ),
        ],
      ),
    );
  }
}

class _HashtagTile extends StatelessWidget {
  const _HashtagTile({required this.hashtag});
  final HashTag hashtag;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      radius: 10,
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ATHashtagBadge(badgeSize: 50, hashSize: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  hashtag.displayName?.toLowerCase() ?? '',
                  style: context.textTheme.bodySmall?.copyWith(fontSize: 15),
                ),
                Text(
                  hashtag.name ?? '',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: ATColors.hexC2C2C2,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_right, size: 24),
        ],
      ),
    );
  }
}

class _HashtagsListShimmer extends StatelessWidget {
  const _HashtagsListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: 10,
      itemBuilder: (_, __) => const _HashtagsTileShimmer(),
    );
  }
}

class _HashtagsTileShimmer extends StatelessWidget {
  const _HashtagsTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
        return Row(
          children: <Widget>[
            const ATShimmer(height: 50, width: 50, radius: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ATShimmer(
                      height: 12,
                      width: ATHelperFuncs.getRandomNumber(
                          constraints.maxWidth * 0.5),
                      radius: 4),
                  const SizedBox(height: 8),
                  const ATShimmer(height: 10, width: 70, radius: 2),
                ],
              ),
            ),
            const SizedBox(width: 15),
            const ATShimmer(
              height: 24,
              width: 24,
              radius: 4,
            ),
          ],
        );
      }),
    );
  }
}
