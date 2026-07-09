import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:amptive/src/features/discover/cubits/recent_searches_cubit.dart';
import 'package:amptive/src/features/discover/data/models/recent_search_entry.dart';
import 'package:amptive/src/features/discover/cubits/search_episodes_cubit.dart';
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
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

RecentSearchEntry _showRecentEntry(HostedShow show) => RecentSearchEntry(
      type: RecentSearchType.show,
      id: show.showId ?? show.title ?? '',
      title: show.title ?? '',
      subtitle: show.category,
      imageUrl: show.coverUrl,
      isPaid: (show.price ?? 0) > 0,
      status: show.isLive == true ? 'live' : show.status,
    );

RecentSearchEntry _eventRecentEntry(HostedEvent event) => RecentSearchEntry(
      type: RecentSearchType.event,
      id: event.eventId ?? event.title ?? '',
      title: event.title ?? '',
      subtitle: event.category,
      imageUrl: event.coverUrl,
      isPaid: (event.price ?? 0) > 0,
      status: event.isLive == true ? 'live' : event.status,
      scheduledFor: event.scheduledFor,
    );

RecentSearchEntry _userRecentEntry(User user) => RecentSearchEntry(
      type: RecentSearchType.user,
      id: user.userId,
      title: user.name ?? user.username ?? '',
      subtitle: user.username,
      imageUrl: user.profilePicture,
    );

HomeFeedItem _feedItemFromShow(HostedShow show) => HomeFeedItem(
      id: show.showId,
      showId: show.showId,
      title: show.title,
      contentType: 'episode',
      status: show.isLive == true ? 'live' : 'scheduled',
      hostId: show.host?.userId,
      hostName: show.host?.username ?? show.host?.name,
      hostProfileImageUrl: show.host?.profilePicture,
      thumbnailUrl: show.coverUrl,
      coverUrl: show.coverUrl,
      showCoverUrl: show.coverUrl,
      showTitle: show.title,
      showType: show.showType,
      price: show.price,
      viewerCount: show.totalViewers,
      goingCount: show.goingCount,
    );

HomeFeedItem _feedItemFromEvent(HostedEvent event,
        {String contentType = 'standalone'}) =>
    HomeFeedItem(
      id: event.eventId,
      title: event.title,
      contentType: contentType,
      status: event.isLive == true ? 'live' : (event.status ?? 'scheduled'),
      hostId: event.host?.userId,
      hostName: event.host?.username ?? event.host?.name,
      hostProfileImageUrl: event.host?.profilePicture,
      thumbnailUrl: event.coverUrl,
      coverUrl: event.coverUrl,
      showCoverUrl: event.coverUrl,
      showTitle: event.title,
      showType: event.showType,
      price: event.price,
      scheduledFor: event.scheduledFor,
      viewerCount: event.viewerCount,
      goingCount: event.goingCount,
    );

void _openProgram(BuildContext context, HomeFeedItem item) {
  // Drop focus so dismissing the detail modal can't re-activate the
  // search box (same fix as the discover cards).
  FocusManager.instance.primaryFocus?.unfocus();
  final bool isLive = item.status?.toLowerCase() == 'live';
  final String route = isLive
      ? item.contentType == 'standalone'
          ? ATRoutes.liveEventDetailed
          : ATRoutes.liveShowDetailed
      : ATRoutes.scheduleDetailed;
  context.pushNamed(route, extra: item);
}

void _openHashtag(BuildContext context, String tagName) {
  FocusManager.instance.primaryFocus?.unfocus();
  context.pushNamed(ATRoutes.SOCIETY_HASHTAG_SCREEN, extra: tagName);
}

/// One search-result row, styled exactly like the recent-searches rows
/// ([P] badge, type label, `• status` segment). Live shows/events get the
/// play badge; everything else gets a chevron.
Widget _resultTile({
  required RecentSearchEntry entry,
  required VoidCallback onTap,
  bool isLive = false,
  String? subtitleOverride,
}) {
  return SearchItemTile(
    leadingImagePath: entry.imageUrl ?? '',
    isCircular: entry.type == RecentSearchType.user,
    title: entry.title,
    subtitle: subtitleOverride ??
        (entry.type == RecentSearchType.user
            ? (entry.subtitle ?? '')
            : entry.typeLabel),
    isPaid: entry.isPaid,
    statusText: entry.statusLabel,
    trailing: isLive
        ? const ATImgLoader(
            imgPath: ATImgStrings.playCircleIcon,
            height: 24,
            width: 24,
          )
        : const Icon(Icons.keyboard_arrow_right),
    onTap: onTap,
  );
}

/// Flat, tab-less results list shown live while the user types — rows are
/// arranged exactly like the recent-searches list. The full tabbed page
/// ([SearchResultsPage]) only opens on keyboard submit.
class LiveSearchResultsView extends StatelessWidget {
  const LiveSearchResultsView({super.key, this.searchQuery});

  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<SearchUsersCubit>(create: (_) => SearchUsersCubit()),
        BlocProvider<SearchShowsCubit>(create: (_) => SearchShowsCubit()),
        BlocProvider<SearchEventsCubit>(create: (_) => SearchEventsCubit()),
        BlocProvider<SearchEpisodesCubit>(create: (_) => SearchEpisodesCubit()),
        BlocProvider<SearchHashtagsCubit>(create: (_) => SearchHashtagsCubit()),
        // The unified index sometimes finds items the resource-specific
        // indexes miss; its results are merged in as a fallback.
        BlocProvider<UnifiedSearchCubit>(create: (_) => UnifiedSearchCubit()),
      ],
      child: _LiveSearchList(searchQuery: searchQuery),
    );
  }
}

class _LiveSearchList extends StatefulWidget {
  const _LiveSearchList({this.searchQuery});
  final String? searchQuery;

  @override
  State<_LiveSearchList> createState() => _LiveSearchListState();
}

class _LiveSearchListState extends State<_LiveSearchList> {
  String get _query =>
      (widget.searchQuery ?? '').trim().replaceFirst(RegExp(r'^#+'), '');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _runSearches();
    });
  }

  @override
  void didUpdateWidget(covariant _LiveSearchList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      // Defer: firing cubits mid-rebuild throws "setState during build"
      // and the responses never render.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _runSearches();
      });
    }
  }

  void _runSearches() {
    if (_query.isEmpty) return;
    // Shows/events/hashtags match from the very first letter; the users
    // endpoint requires 3+ characters (its cubit guards that itself).
    context.read<SearchShowsCubit>().searchShows(_query);
    context.read<SearchEventsCubit>().searchEvents(_query);
    context.read<SearchEpisodesCubit>().searchEpisodes(_query);
    context.read<SearchHashtagsCubit>().searchHashtags(_query);
    context.read<SearchUsersCubit>().searchUsers(_query);
    context.read<UnifiedSearchCubit>().searchAll(_query);
  }

  @override
  Widget build(BuildContext context) {
    final UnifiedSearchResponseModel? unified =
        context.watch<UnifiedSearchCubit>().currentSearchData;

    // Resource-specific results first, then anything extra the unified
    // index found that they missed (its matching is broader).
    final List<User> users = <User>[
      ...?context.watch<SearchUsersCubit>().currentSearchData?.data,
    ];
    final Set<String> seenUserIds =
        users.map((User user) => user.userId).toSet();
    users.addAll((unified?.users ?? <User>[])
        .where((User u) => seenUserIds.add(u.userId)));

    final List<HostedShow> shows = <HostedShow>[
      ...?context.watch<SearchShowsCubit>().currentSearchData?.shows,
    ];
    final Set<String?> seenShowIds =
        shows.map((HostedShow show) => show.showId).toSet();
    shows.addAll((unified?.shows ?? <HostedShow>[])
        .where((HostedShow s) => seenShowIds.add(s.showId)));

    final List<HostedEvent> events = <HostedEvent>[
      ...?context.watch<SearchEventsCubit>().currentSearchData?.events,
    ];
    final Set<String?> seenEventIds =
        events.map((HostedEvent event) => event.eventId).toSet();
    events.addAll((unified?.events ?? <HostedEvent>[])
        .where((HostedEvent e) => seenEventIds.add(e.eventId)));

    final List<HostedEvent> episodes =
        context.watch<SearchEpisodesCubit>().currentSearchData?.events ??
            <HostedEvent>[];

    final List<HashTag> hashtags = <HashTag>[
      ...?context.watch<SearchHashtagsCubit>().currentSearchData?.hashtags,
    ];
    final Set<String?> seenTagNames =
        hashtags.map((HashTag tag) => tag.name).toSet();
    hashtags.addAll((unified?.hashtags ?? <HashTag>[])
        .where((HashTag t) => seenTagNames.add(t.name)));

    final bool anyLoading = context.watch<SearchShowsCubit>().state
            is LoadingState<SearchShowsResponseModel> ||
        context.watch<SearchEventsCubit>().state
            is LoadingState<SearchEventsResponseModel> ||
        context.watch<SearchEpisodesCubit>().state
            is LoadingState<SearchEventsResponseModel> ||
        context.watch<SearchUsersCubit>().state
            is LoadingState<SearchUsersResponseModel> ||
        context.watch<UnifiedSearchCubit>().state
            is LoadingState<UnifiedSearchResponseModel> ||
        context.watch<SearchHashtagsCubit>().state
            is LoadingState<SearchHashtagsResponseModel>;

    final List<Widget> rows = <Widget>[
      ...users.map((User user) => _resultTile(
            entry: _userRecentEntry(user),
            onTap: () =>
                context.read<RecentSearchesCubit>().add(_userRecentEntry(user)),
          )),
      ...shows.map((HostedShow show) {
        final RecentSearchEntry entry = _showRecentEntry(show);
        return _resultTile(
          entry: entry,
          isLive: show.isLive == true,
          onTap: () {
            context.read<RecentSearchesCubit>().add(entry);
            _openProgram(context, _feedItemFromShow(show));
          },
        );
      }),
      ...events.map((HostedEvent event) {
        final RecentSearchEntry entry = _eventRecentEntry(event);
        return _resultTile(
          entry: entry,
          isLive: event.isLive == true,
          onTap: () {
            context.read<RecentSearchesCubit>().add(entry);
            _openProgram(context, _feedItemFromEvent(event));
          },
        );
      }),
      ...episodes.map((HostedEvent episode) {
        final RecentSearchEntry entry = _eventRecentEntry(episode);
        return _resultTile(
          entry: entry,
          isLive: episode.isLive == true,
          subtitleOverride: 'Episode',
          onTap: () {
            context.read<RecentSearchesCubit>().add(entry);
            _openProgram(
                context, _feedItemFromEvent(episode, contentType: 'episode'));
          },
        );
      }),
      ...hashtags.map((HashTag hashtag) {
        final String tagName = (hashtag.displayName ?? hashtag.name ?? '')
            .replaceFirst(RegExp(r'^#+'), '');
        return HashTagSearchItemTile(
          title: tagName,
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () {
            context.read<RecentSearchesCubit>().add(RecentSearchEntry(
                  type: RecentSearchType.hashtag,
                  id: tagName,
                  title: tagName,
                ));
            _openHashtag(context, tagName);
          },
        );
      }),
    ];

    if (rows.isEmpty) {
      if (anyLoading) return const LiveSearchListShimmer();
      if (_query.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'No results for "$_query"',
            style: context.textTheme.bodySmall
                ?.copyWith(color: ATColors.hexC2C2C2),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ...rows,
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

/// Skeleton rows matching the live-search / recent-searches row layout:
/// 50px artwork, a title bar and a shorter subtitle bar.
class LiveSearchListShimmer extends StatelessWidget {
  const LiveSearchListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: List<Widget>.generate(6, (int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: <Widget>[
                ATShimmer(
                  height: 50,
                  width: 50,
                  radius: index.isEven ? 5 : 25,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      ATShimmer(height: 14, width: 180, radius: 3),
                      SizedBox(height: 6),
                      ATShimmer(height: 12, width: 110, radius: 3),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

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
        BlocProvider<SearchEpisodesCubit>(create: (_) => SearchEpisodesCubit()),
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

    _tabController.addListener(_syncSelectedTab);
    _tabController.animation?.addListener(_syncSelectedTab);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _runSearches();
    });
  }

  @override
  void didUpdateWidget(covariant SearchResultsTabsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      // Defer: firing cubits mid-rebuild throws "setState during build".
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _runSearches();
      });
    }
  }

  void _runSearches() {
    if (_query.isEmpty) return;
    context.read<SearchUsersCubit>().searchUsers(_query);
    context.read<UnifiedSearchCubit>().searchAll(_query);
    context.read<SearchHashtagsCubit>().searchHashtags(_query);
    context.read<SearchShowsCubit>().searchShows(_query);
    context.read<SearchEventsCubit>().searchEvents(_query);
    context.read<SearchEpisodesCubit>().searchEpisodes(_query);
  }

  void _syncSelectedTab() {
    _isTabSelected.value =
        (_tabController.animation?.value ?? _tabController.index.toDouble())
            .round()
            .clamp(0, _tabController.length - 1);
  }

  // Hashtags are stored without the '#', so strip a leading '#'
  // (e.g. '#great' → 'great') or the server finds nothing.
  String get _query =>
      (widget.searchQuery ?? '').trim().replaceFirst(RegExp(r'^#+'), '');

  // void _onHashtagsScroll() {
  //   if (_hashtagsScrollController.position.pixels >=
  //       _hashtagsScrollController.position.maxScrollExtent - 100) {
  //     context.read<AllHashtagsCubit>().fetchHashTags();
  //   }
  // }

  @override
  void dispose() {
    _tabController.removeListener(_syncSelectedTab);
    _tabController.animation?.removeListener(_syncSelectedTab);
    _tabController.dispose();
    _isTabSelected.dispose();
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
            // No frame padding — the leading inset lives on the first pill
            // so the row scrolls edge to edge.
            padding: EdgeInsets.zero,
            isScrollable: true,
            dividerColor: ATColors.hex0D0D0D,
            tabs: <String>['Top', 'Shows', 'Events', 'Users', 'Hashtags']
                .asMap()
                .entries
                .map((MapEntry<int, String> tab) {
              return Tab(
                // 48px tap target (Material minimum; Apple asks 44+).
                height: 48,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: tab.key == 0 ? 15 : 0, right: 10),
                  child: ValueListenableBuilder(
                      valueListenable: _isTabSelected,
                      builder: (_, int value, __) {
                        final bool isSelected = tab.key == value;
                        return ATContainer(
                          radius: 20,
                          duration: 120,
                          curve: Curves.easeOutCubic,
                          color: isSelected
                              ? ATColors.white
                              : ATColors.hex9E9E9E.withValues(alpha: 0.3),
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
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
                ),
              );
            }).toList()),
        ATContainer(
          padding: const EdgeInsets.all(15),
          height: ATHelperFuncs.getScreenHeight(context),
          // Note: no Expanded here — Expanded inside a plain container is
          // an invalid layout and made tab swipes glitch.
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              // No failure listener here: the unified endpoint 500s on some
              // queries, and the All tab falls back to composing results
              // from the resource-specific searches instead.
              BlocBuilder<UnifiedSearchCubit,
                  ATAppState<UnifiedSearchResponseModel>>(
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
                          final UnifiedSearchResponseModel? searchData = context
                              .read<UnifiedSearchCubit>()
                              .currentSearchData;

                          List<dynamic> allResults = <dynamic>[
                            ...?searchData?.shows,
                            ...?searchData?.events,
                            ...?searchData?.hashtags,
                            ...?searchData?.users,
                          ];

                          // The unified endpoint 500s on some queries;
                          // fall back to the resource-specific results
                          // that were fetched in parallel anyway.
                          if (allResults.isEmpty) {
                            allResults = <dynamic>[
                              ...?context
                                  .watch<SearchShowsCubit>()
                                  .currentSearchData
                                  ?.shows,
                              ...?context
                                  .watch<SearchEventsCubit>()
                                  .currentSearchData
                                  ?.events,
                              ...?context
                                  .watch<SearchHashtagsCubit>()
                                  .currentSearchData
                                  ?.hashtags,
                              ...?context
                                  .watch<SearchUsersCubit>()
                                  .currentSearchData
                                  ?.data,
                            ];
                          }

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
                                      .searchAll(_query),
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
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(fontSize: 14)),
                              ],
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: allResults.length,
                            itemBuilder: (BuildContext _, int index) {
                              final dynamic item = allResults[index];
                              // Shows & Events (Rectangular)
                              if (item is HostedShow) {
                                return _resultTile(
                                  entry: _showRecentEntry(item),
                                  isLive: item.isLive == true,
                                  onTap: () {
                                    context
                                        .read<RecentSearchesCubit>()
                                        .add(_showRecentEntry(item));
                                    _openProgram(
                                        context, _feedItemFromShow(item));
                                  },
                                );
                              }

                              if (item is HostedEvent) {
                                return _resultTile(
                                  entry: _eventRecentEntry(item),
                                  isLive: item.isLive == true,
                                  onTap: () {
                                    context
                                        .read<RecentSearchesCubit>()
                                        .add(_eventRecentEntry(item));
                                    _openProgram(
                                        context, _feedItemFromEvent(item));
                                  },
                                );
                              }

                              if (item is User) {
                                return _resultTile(
                                  entry: _userRecentEntry(item),
                                  onTap: () => context
                                      .read<RecentSearchesCubit>()
                                      .add(_userRecentEntry(item)),
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

                          // Merge in unified-search finds — the shows
                          // index sometimes misses items unified matches.
                          final List<HostedShow> shows = <HostedShow>[
                            ...?searchData?.shows,
                          ];
                          final Set<String?> seenShowIds = shows
                              .map((HostedShow show) => show.showId)
                              .toSet();
                          shows.addAll((context
                                      .watch<UnifiedSearchCubit>()
                                      .currentSearchData
                                      ?.shows ??
                                  <HostedShow>[])
                              .where(
                                  (HostedShow s) => seenShowIds.add(s.showId)));

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
                                      .searchShows(_query),
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
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(fontSize: 14)),
                              ],
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: shows.length,
                            itemBuilder: (BuildContext _, int index) {
                              final HostedShow show = shows[index];
                              return _resultTile(
                                entry: _showRecentEntry(show),
                                isLive: show.isLive == true,
                                onTap: () {
                                  context
                                      .read<RecentSearchesCubit>()
                                      .add(_showRecentEntry(show));
                                  _openProgram(
                                      context, _feedItemFromShow(show));
                                },
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

                          // The Events tab covers both standalone events
                          // and episode-type events (created under shows),
                          // plus unified-search finds the events index
                          // sometimes misses.
                          final List<HostedEvent> standaloneEvents =
                              <HostedEvent>[...?searchData?.events];
                          final Set<String?> seenEventIds = standaloneEvents
                              .map((HostedEvent event) => event.eventId)
                              .toSet();
                          standaloneEvents.addAll((context
                                      .watch<UnifiedSearchCubit>()
                                      .currentSearchData
                                      ?.events ??
                                  <HostedEvent>[])
                              .where((HostedEvent e) =>
                                  seenEventIds.add(e.eventId)));
                          final List<HostedEvent> events = <HostedEvent>[
                            ...standaloneEvents,
                            ...?context
                                .watch<SearchEpisodesCubit>()
                                .currentSearchData
                                ?.events,
                          ];

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
                                      .searchEvents(_query),
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
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(fontSize: 14)),
                              ],
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: events.length,
                            itemBuilder: (BuildContext _, int index) {
                              final HostedEvent event = events[index];
                              final bool isEpisode =
                                  index >= standaloneEvents.length;
                              return _resultTile(
                                entry: _eventRecentEntry(event),
                                isLive: event.isLive == true,
                                subtitleOverride: isEpisode ? 'Episode' : null,
                                onTap: () {
                                  context
                                      .read<RecentSearchesCubit>()
                                      .add(_eventRecentEntry(event));
                                  _openProgram(
                                      context,
                                      _feedItemFromEvent(event,
                                          contentType: isEpisode
                                              ? 'episode'
                                              : 'standalone'));
                                },
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
                          final List<User> users = searchData?.data ?? <User>[];

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
                                      .searchUsers(_query),
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
                                    'All users matching "${widget.searchQuery}" will appear here.',
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(fontSize: 14)),
                              ],
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: users.length,
                            itemBuilder: (BuildContext _, int index) {
                              final User user = users[index];
                              return _resultTile(
                                entry: _userRecentEntry(user),
                                onTap: () => context
                                    .read<RecentSearchesCubit>()
                                    .add(_userRecentEntry(user)),
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
                            if (state
                                is LoadingState<SearchHashtagsResponseModel>) {
                              return const HashtagsListShimmer();
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
                                    'All hashtags matching "${widget.searchQuery}" will appear here.',
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(fontSize: 14)),
                              ],
                            );
                          }

                          return ListView.builder(
                            //controller: _hashtagsScrollController,
                            padding: EdgeInsets.zero,
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
            ]
                .map((Widget page) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: page,
                    ))
                .toList(),
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
      onTap: () {
        // Save the bare tag name — the recents row adds the '#' itself,
        // so keeping it here would display '##great'.
        final String tagName = (hashtag.displayName ?? hashtag.name ?? '')
            .replaceFirst(RegExp(r'^#+'), '');
        context.read<RecentSearchesCubit>().add(
              RecentSearchEntry(
                type: RecentSearchType.hashtag,
                id: tagName,
                title: tagName,
              ),
            );
        _openHashtag(context, tagName);
      },
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
                  hashtag.displayName ?? '',
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
