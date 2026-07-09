import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/features/discover/cubits/recent_searches_cubit.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/cubits/live_users_cubit.dart';
import 'package:amptive/src/shared/refresh_indicator.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/shared/animated_switcher.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:amptive/src/features/discover/presentation/views/discover_page_view.dart';
import 'package:amptive/src/features/discover/presentation/widgets/discover_search_field.dart';
import 'package:amptive/src/features/discover/presentation/views/recent_searches_page_view.dart';
import 'package:amptive/src/features/discover/presentation/views/search_results_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

class DiscoverTabView extends StatefulWidget {
  const DiscoverTabView({super.key});

  @override
  State<DiscoverTabView> createState() => _DiscoverTabViewState();
}

class _DiscoverTabViewState extends State<DiscoverTabView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<DiscoverTrnstnBlc>(create: (_) => DiscoverTrnstnBlc()),
        BlocProvider<RecentSearchesCubit>(create: (_) => RecentSearchesCubit()),
      ],
      child: SafeArea(
        bottom: false,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notif) {
            context.read<ATNavBarBloc>().ctrlNavVisibility(notif);
            return false;
          },
          child: ATRefreshIndicator(
            // Spinner sits just below the pinned search box ("Discover"
            // title 56 + search box 60), not above the page title.
            indicatorTopOffset: kToolbarHeight + 68,
            onRefresh: () async {
              context.read<LiveUsersCubit>().refreshLiveUsers();
              await context.read<HomeFeedCubit>().refreshHomeFeed();
            },
            child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverPersistentHeader(
                floating: true,
                delegate: _DiscoverTitleHeaderDelegate(vsync: this),
              ),
              SliverPersistentHeader(
                  pinned: true,
                  delegate: ATSliverHDelegate(
                    minExt: 60,
                    maxExt: 60,
                    child: const ATDiscoverSearchField(),
                  )),
              // 10 here + the search field's 10px internal bottom inset
              // = 20px visual gap between the search box and the content —
              // but tighter above the search-results tabs.
              SliverToBoxAdapter(
                child:
                    BlocBuilder<DiscoverTrnstnBlc, (DiscoverPageState, String?)>(
                  builder: (_, (DiscoverPageState, String?) state) {
                    final bool isResults =
                        state.$1 == DiscoverPageState.showSearchResult;
                    return SizedBox(height: isResults ? 0 : 10);
                  },
                ),
              ),
              SliverToBoxAdapter(child:
                  BlocBuilder<DiscoverTrnstnBlc, (DiscoverPageState, String?)>(
                      builder: (_, (DiscoverPageState, String?) state) {
                final DiscoverPageState pageState = state.$1;
                return ATFadingSwitcher(
                  duration:
                      MediaQuery.maybeOf(context)?.disableAnimations ?? false
                          ? 0
                          : 200,
                  child: pageState == DiscoverPageState.showMainPage
                      ? const MainDiscoverView(key: ValueKey<int>(100))
                      : pageState == DiscoverPageState.showRecentSearches
                          ? const RecentSearchesView(key: ValueKey<int>(200))
                          : pageState == DiscoverPageState.showSearchSuggestions
                              // Live flat results while typing; the tabbed
                              // page only opens on keyboard submit.
                              ? LiveSearchResultsView(
                                  key: const ValueKey<int>(300),
                                  searchQuery: state.$2,
                                )
                              : SearchResultsPage(
                                  key: const ValueKey<int>(400),
                                  searchQuery: state.$2,
                                ),
                );
              })),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

class _DiscoverTitleHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _DiscoverTitleHeaderDelegate({required this.vsync});

  // Required by the floating-header snap animation; without it the header
  // throws "vsync must not be null" the moment it snaps.
  @override
  final TickerProvider vsync;

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => kToolbarHeight;

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration =>
      FloatingHeaderSnapConfiguration(
        curve: Curves.easeOutCubic,
        duration: Duration(milliseconds: 200),
      );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double progress = (shrinkOffset / maxExtent).clamp(0, 1);
    final double opacity = (1 - (shrinkOffset / 35)).clamp(0, 1);

    return ColoredBox(
      color: Colors.black,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: <Widget>[
          Positioned(
            top: -(progress * 35),
            left: 15,
            right: 15,
            height: kToolbarHeight,
            child: Opacity(
              opacity: opacity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Discover',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: ATSizes.size26,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _DiscoverTitleHeaderDelegate oldDelegate) =>
      false;
}

enum DiscoverPageState {
  showMainPage,
  showRecentSearches,
  showSearchResult,
  showSearchSuggestions
}

class DiscoverTrnstnBlc extends Cubit<(DiscoverPageState, String?)> {
  DiscoverTrnstnBlc() : super((DiscoverPageState.showMainPage, null));

  void showRecentSearches() =>
      emit((DiscoverPageState.showRecentSearches, state.$2));

  void showSearchResults() =>
      emit((DiscoverPageState.showSearchResult, state.$2));

  void showSearchSuggestions() =>
      emit((DiscoverPageState.showSearchSuggestions, state.$2));

  void reset() => emit((DiscoverPageState.showMainPage, null));

  void updateSearchQuery(String query) => emit((state.$1, query));
}
