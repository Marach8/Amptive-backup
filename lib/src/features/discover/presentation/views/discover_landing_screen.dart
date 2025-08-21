import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/shared/animated_switcher.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:amptive/src/features/discover/presentation/views/discover_page_view.dart';
import 'package:amptive/src/features/discover/presentation/widgets/discover_search_field.dart';
import 'package:amptive/src/features/discover/presentation/views/recent_searches_page_view.dart';
import 'package:amptive/src/features/discover/presentation/views/search_results_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DiscoverTabView extends StatefulWidget {
  const DiscoverTabView({super.key});

  @override
  State<DiscoverTabView> createState() => _DiscoverTabViewState();
}

class _DiscoverTabViewState extends State<DiscoverTabView> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscoverTrnstnBlc>(
      create: (_) => DiscoverTrnstnBlc(),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              'Discover',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: ATFontSizes.size23
              )
            ),
            floating: true,
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: ATSliverHDelegate(
              minExt: 60, maxExt: 60, 
              child: const ATDiscoverSearchField(),
            )
          ),
      
          const SliverToBoxAdapter(child: SizedBox(height: 20,)),
      
          SliverToBoxAdapter(
            child: BlocBuilder<DiscoverTrnstnBlc, (DiscoverPageState, String?)>(
              builder: (_, (DiscoverPageState, String?) state) {
                final DiscoverPageState pageState = state.$1;
                return ATFadingSwitcher(
                  child: pageState == DiscoverPageState.showMainPage
                    ? const MainDiscoverView(key: ValueKey<int>(100)) :
                    pageState == DiscoverPageState.showRecentSearches
                    ? const RecentSearchesView(key: ValueKey<int>(200)) :
                      const SearchResultsTabsView(key: ValueKey<int>(300)),
                );
              }
            )
          ),
        ],
      ),
    );
  }
}


enum DiscoverPageState{showMainPage, showRecentSearches, showSearchResult}

class DiscoverTrnstnBlc extends Cubit<(DiscoverPageState, String?)>{
  DiscoverTrnstnBlc(): super((DiscoverPageState.showMainPage, null));

  void showRecentSearches() => emit((DiscoverPageState.showRecentSearches, state.$2));

  void showSearchResults() => emit((DiscoverPageState.showSearchResult, state.$2));

  void reset() => emit((DiscoverPageState.showMainPage, null));
}