import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_align_widget.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_switcher.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:amptive/src/features/discover/presentation/views/main_discover_page_view.dart';
import 'package:amptive/src/features/discover/presentation/widgets/discover_search_field.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/recent_searches_widgets/recent_searches_and_tabs_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/recent_searches_widgets/recent_searches_view.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/tab_view_widgets/discover_tab_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';


class ATDiscoverScreen extends StatefulWidget {
  const ATDiscoverScreen({super.key});

  @override
  State<ATDiscoverScreen> createState() => _ATDiscoverScreenState();
}

class _ATDiscoverScreenState extends State<ATDiscoverScreen> {

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: SafeArea(
          child: BlocProvider<DiscoverTrnstnBlc>(
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
          ),
        ),
        resizeToAvoidBottomInset: false,
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