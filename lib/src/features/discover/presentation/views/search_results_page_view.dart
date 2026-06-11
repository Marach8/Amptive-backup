import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:amptive/src/features/discover/cubits/search_events_cubit.dart';
import 'package:amptive/src/features/discover/cubits/search_hashtags_cubits.dart';
import 'package:amptive/src/features/discover/cubits/search_shows_cubit.dart';
import 'package:amptive/src/features/discover/cubits/search_users_cubit.dart';
import 'package:amptive/src/features/discover/cubits/unified_search_cubit.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/discover/data/models/response/search_events_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_shows_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/search_users_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/unified_search_response_model.dart';
import 'package:amptive/src/features/discover/presentation/widgets/All_resources_tab_shimmers.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key, this.searchQuery});

  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<AllUsersCubit>(create: (_) => AllUsersCubit()),
        BlocProvider<AllHashtagsCubit>(create: (_) => AllHashtagsCubit()),
        BlocProvider<SearchUsersCubit>(create: (_) => SearchUsersCubit()),
        BlocProvider<UnifiedSearchCubit>(create: (_) => UnifiedSearchCubit()),
        BlocProvider<SearchHashtagsCubit>(create: (_) => SearchHashtagsCubit()),
        BlocProvider<SearchShowsCubit>(create: (_) => SearchShowsCubit()),
        BlocProvider<SearchEventsCubit>(create: (_) => SearchEventsCubit()),
      ],
      child: SearchResultsTabsView(searchQuery: searchQuery),
    );
  }
}

class SearchResultsTabsView extends StatefulWidget {
  const SearchResultsTabsView({super.key, this.searchQuery});
  final String? searchQuery;

  @override
  State<SearchResultsTabsView> createState() => _SearchResultsTabsViewState();
}

class _SearchResultsTabsViewState extends State<SearchResultsTabsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ValueNotifier<int> _isTabSelected;
  //late ScrollController _hashtagsScrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _isTabSelected = ValueNotifier(0);
    //_hashtagsScrollController = ScrollController();
    //_hashtagsScrollController.addListener(_onHashtagsScroll);

    _tabController
        .addListener(() => _isTabSelected.value = _tabController.index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String query = widget.searchQuery ?? '';
      if (query.isNotEmpty) {
        context.read<SearchUsersCubit>().searchUsers(query);
        context.read<UnifiedSearchCubit>().searchAll(query);
        context.read<SearchHashtagsCubit>().searchHashtags(query);
        context.read<SearchShowsCubit>().searchShows(query);
        context.read<SearchEventsCubit>().searchEvents(query);
      }
    });
  }

  // void _onHashtagsScroll() {
  //   if (_hashtagsScrollController.position.pixels >=
  //       _hashtagsScrollController.position.maxScrollExtent - 100) {
  //     context.read<AllHashtagsCubit>().fetchHashTags();
  //   }
  // }

  @override
  void dispose() {
    _tabController.dispose();
    // _hashtagsScrollController.dispose();
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
            indicator: const BoxDecoration(),
            indicatorColor: ATColors.transparent,
            padding: const EdgeInsets.only(left: 15),
            isScrollable: true,
            dividerColor: ATColors.hex0D0D0D,
            tabs: <String>['All', 'Shows', 'Events', 'Users', 'Hashtags']
                .asMap()
                .entries
                .map((MapEntry<int, String> tab) {
              return Tab(
                child: ValueListenableBuilder<int>(
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
                BlocConsumer<UnifiedSearchCubit,
                    ATAppState<UnifiedSearchResponseModel>>(
                  listener: (BuildContext context,
                      ATAppState<UnifiedSearchResponseModel> state) {
                    if (state is FailureState<UnifiedSearchResponseModel>) {
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                  builder: (BuildContext context,
                      ATAppState<UnifiedSearchResponseModel> state) {
                    return switch (state) {
                      InitialState<UnifiedSearchResponseModel>() =>
                        const SizedBox.shrink(),
                      LoadingState<UnifiedSearchResponseModel>() ||
                      FailureState<UnifiedSearchResponseModel>() ||
                      SuccessState<UnifiedSearchResponseModel>() =>
                        Builder(
                          builder: (_) {
                            final UnifiedSearchResponseModel? searchData =
                                context
                                    .read<UnifiedSearchCubit>()
                                    .currentSearchData;

                            final List<dynamic> allResults = <dynamic>[
                              ...?searchData?.shows,
                              ...?searchData?.events,
                              ...?searchData?.hashtags,
                              ...?searchData?.users,
                            ];

                            if (allResults.isEmpty) {
                              if (state
                                  is LoadingState<UnifiedSearchResponseModel>) {
                                return const UnifiedSearchShimmer();
                              }

                              if (state
                                  is FailureState<UnifiedSearchResponseModel>) {
                                return Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () => context
                                        .read<UnifiedSearchCubit>()
                                        .searchAll(widget.searchQuery ?? ''),
                                  ),
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Nothing to show here right now.',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  Text(
                                      'All shows and events created under "${widget.searchQuery}" will appear here.',
                                      style: context.textTheme.labelSmall),
                                ],
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.all(15),
                              itemCount: allResults.length,
                              itemBuilder: (BuildContext _, int index) {
                                final dynamic item = allResults[index];
                                // Shows & Events (Rectangular)
                                if (item is HostedShow) {
                                  return SearchItemTile(
                                    leadingImagePath: item.coverUrl ?? '',
                                    title: item.title ?? '',
                                    subtitle: item.host?.username ?? '',
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
                                  );
                                }

                                if (item is User) {
                                  return SearchItemTile(
                                    leadingImagePath: item.profilePicture ?? '',
                                    isCircular: true,
                                    title: item.name ?? 'Unknown User',
                                    subtitle: item.username ?? '',
                                    trailing: const Icon(
                                      Icons.keyboard_arrow_right,
                                    ),
                                  );
                                }

                                if (item is HashTag) {
                                  return _HashtagTile(
                                    hashtag: item,
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            );
                          },
                        ),
                    };
                  },
                ),
                BlocConsumer<SearchShowsCubit,
                    ATAppState<SearchShowsResponseModel>>(
                  listener: (BuildContext context,
                      ATAppState<SearchShowsResponseModel> state) {
                    if (state is FailureState<SearchShowsResponseModel>) {
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                  builder: (BuildContext context,
                      ATAppState<SearchShowsResponseModel> state) {
                    return switch (state) {
                      InitialState<SearchShowsResponseModel>() =>
                        const SizedBox.shrink(),
                      LoadingState<SearchShowsResponseModel>() ||
                      FailureState<SearchShowsResponseModel>() ||
                      SuccessState<SearchShowsResponseModel>() =>
                        Builder(
                          builder: (_) {
                            final SearchShowsResponseModel? searchData = context
                                .read<SearchShowsCubit>()
                                .currentSearchData;

                            final List<HostedShow> shows =
                                searchData?.shows ?? <HostedShow>[];

                            if (shows.isEmpty) {
                              if (state
                                  is LoadingState<SearchShowsResponseModel>) {
                                return const ShowsListShimmer();
                              }

                              if (state
                                  is FailureState<SearchShowsResponseModel>) {
                                return Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () => context
                                        .read<SearchShowsCubit>()
                                        .searchShows(widget.searchQuery ?? ''),
                                  ),
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Nothing to show here right now.',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  Text(
                                      'All shows created under "${widget.searchQuery}" will appear here.',
                                      style: context.textTheme.labelSmall),
                                ],
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.all(15),
                              itemCount: shows.length,
                              itemBuilder: (BuildContext _, int index) {
                                final HostedShow show = shows[index];
                                return SearchItemTile(
                                  leadingImagePath: show.coverUrl ?? '',
                                  isCircular: false,
                                  title: show.title ?? '',
                                  subtitle: show.category ?? 'Unknown Category',
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
                                );
                              },
                            );
                          },
                        ),
                    };
                  },
                ),
                BlocConsumer<SearchEventsCubit,
                    ATAppState<SearchEventsResponseModel>>(
                  listener: (BuildContext context,
                      ATAppState<SearchEventsResponseModel> state) {
                    if (state is FailureState<SearchEventsResponseModel>) {
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                  builder: (BuildContext context,
                      ATAppState<SearchEventsResponseModel> state) {
                    return switch (state) {
                      InitialState<SearchEventsResponseModel>() =>
                        const SizedBox.shrink(),
                      LoadingState<SearchEventsResponseModel>() ||
                      FailureState<SearchEventsResponseModel>() ||
                      SuccessState<SearchEventsResponseModel>() =>
                        Builder(
                          builder: (_) {
                            final SearchEventsResponseModel? searchData = context
                                .read<SearchEventsCubit>()
                                .currentSearchData;

                            final List<HostedEvent> events =
                                searchData?.events ?? <HostedEvent>[];

                            if (events.isEmpty) {
                              if (state
                                  is LoadingState<SearchShowsResponseModel>) {
                                return const ShowsListShimmer();
                              }

                              if (state
                                  is FailureState<SearchEventsResponseModel>) {
                                return Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () => context
                                        .read<SearchEventsCubit>()
                                        .searchEvents(widget.searchQuery ?? ''),
                                  ),
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Nothing to show here right now.',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  Text(
                                      'All events created under "${widget.searchQuery}" will appear here.',
                                      style: context.textTheme.labelSmall),
                                ],
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.all(15),
                              itemCount: events.length,
                              itemBuilder: (BuildContext _, int index) {
                                final HostedEvent event = events[index];
                                return SearchItemTile(
                                  leadingImagePath: event.coverUrl ?? '',
                                  isCircular: false,
                                  title: event.title ?? '',
                                  subtitle: event.category ?? 'Unknown Category',
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
                                );
                              },
                            );
                          },
                        ),
                    };
                  },
                ),
                BlocConsumer<SearchUsersCubit,
                    ATAppState<SearchUsersResponseModel>>(
                  listener: (BuildContext context,
                      ATAppState<SearchUsersResponseModel> state) {
                    if (state is FailureState<SearchUsersResponseModel>) {
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                  builder: (BuildContext context,
                      ATAppState<SearchUsersResponseModel> state) {
                    return switch (state) {
                      InitialState<SearchUsersResponseModel>() =>
                        const SizedBox.shrink(),
                      LoadingState<SearchUsersResponseModel>() ||
                      FailureState<SearchUsersResponseModel>() ||
                      SuccessState<SearchUsersResponseModel>() =>
                        Builder(
                          builder: (_) {
                            final SearchUsersResponseModel? searchData = context
                                .read<SearchUsersCubit>()
                                .currentSearchData;
                            final List<User> users =
                                searchData?.data ?? <User>[];

                            if (users.isEmpty) {
                              if (state
                                  is LoadingState<SearchUsersResponseModel>) {
                                return const UsersListShimmer();
                              }

                              if (state
                                  is FailureState<SearchUsersResponseModel>) {
                                return Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () => context
                                        .read<SearchUsersCubit>()
                                        .searchUsers(widget.searchQuery ?? ''),
                                  ),
                                );
                              }

                              return const Center(
                                child: Text('No users found'),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.all(15),
                              itemCount: users.length,
                              itemBuilder: (BuildContext _, int index) {
                                final User user = users[index];
                                return SearchItemTile(
                                  leadingImagePath: user.profilePicture ?? '',
                                  title: user.name ?? 'Unknown User',
                                  subtitle: user.username ?? 'Unknown Username',
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
                BlocConsumer<SearchHashtagsCubit,
                    ATAppState<SearchHashtagsResponseModel>>(
                  listener: (BuildContext context,
                      ATAppState<SearchHashtagsResponseModel> state) {
                    if (state is FailureState<SearchHashtagsResponseModel>) {
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                  builder: (BuildContext context,
                      ATAppState<SearchHashtagsResponseModel> state) {
                    return switch (state) {
                      InitialState<SearchHashtagsResponseModel>() =>
                        const SizedBox.shrink(),
                      LoadingState<SearchHashtagsResponseModel>() ||
                      FailureState<SearchHashtagsResponseModel>() ||
                      SuccessState<SearchHashtagsResponseModel>() =>
                        Builder(
                          builder: (_) {
                            final SearchHashtagsResponseModel? hashtagsData =
                                context
                                    .read<SearchHashtagsCubit>()
                                    .currentSearchData;
                            final List<HashTag> hashtags =
                                hashtagsData?.hashtags ?? <HashTag>[];

                            if (hashtags.isEmpty) {
                              if (state is LoadingState<
                                  SearchHashtagsResponseModel>) {
                                return const HashtagsListShimmer();
                              }
                              return const Center(
                                  child: Text('No hashtags found'));
                            }

                            return ListView.builder(
                              //controller: _hashtagsScrollController,
                              padding: const EdgeInsets.all(15),
                              itemCount: hashtags.length,
                              itemBuilder: (BuildContext _, int index) {
                                final HashTag hashtag = hashtags[index];
                                final bool isLastItem =
                                    index == hashtags.length - 1;
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: isLastItem ? 200 : 0),
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

