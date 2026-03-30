import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/features/discover/cubits/search_suggestions_cubit.dart';
import 'package:amptive/src/features/discover/discover_export.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchSuggestionsPageView extends StatelessWidget {
  const SearchSuggestionsPageView({super.key, this.searchQuery});
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchSuggestionsCubit>(
      create: (_) => SearchSuggestionsCubit()..searchSuggestions(searchQuery ?? ''),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,),
        child: BlocBuilder<SearchSuggestionsCubit, ATAppState<dynamic>>(
          builder: (BuildContext context, ATAppState<dynamic> state) {
            return switch (state) {
              InitialState<dynamic>() => const SizedBox.shrink(),
              LoadingState<dynamic>() ||
              FailureState<dynamic>() ||
              SuccessState<dynamic>() =>
                Builder(builder: (context) {
                  final dynamic suggestionsData =
                      context.read<SearchSuggestionsCubit>().currentSearchData;
                  final List<String> suggestions =
                      suggestionsData?.suggestions ?? <String>[];
                  final String query = searchQuery ?? '';

                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        // Your original first if block
                        if (query.isNotEmpty)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.search,
                                size: 20, color: ATColors.offWhiteColor),
                            title: Text(query,
                                style: Theme.of(context).textTheme.bodyMedium),
                            onTap: () {
                              final navBloc = context.read<DiscoverTrnstnBlc>();
                              navBloc.updateSearchQuery(query);
                              navBloc.showSearchResults();
                            },
                          ),

                        // Your original nested empty state handling
                        if (suggestions.isEmpty) ...[
                          if (state is LoadingState<dynamic>)
                            const SearchSuggestionsShimmer(),
                            
                          
                           
                           if (state is FailureState<dynamic>)
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: SizedBox.shrink(),
                            ),
                          
                             const SizedBox.shrink(),
                        ],
                        
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 10.h),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: suggestions.length,
                            itemBuilder: (context, index) {
                              final String text = suggestions[index];

                              // Skip exact match
                              if (text.toLowerCase() == query.toLowerCase()) {
                                return const SizedBox.shrink();
                              }

                              final int startIndex = text
                                  .toLowerCase()
                                  .indexOf(query.toLowerCase());

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    children: <InlineSpan>[
                                      if (startIndex == -1 || query.isEmpty)
                                        TextSpan(text: text)
                                      else ...<InlineSpan>[
                                        TextSpan(
                                            text: text.substring(0, startIndex)),
                                        TextSpan(
                                          text: text.substring(startIndex,
                                              startIndex + query.length),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: text.substring(
                                                startIndex + query.length)),
                                      ],
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  final navBloc = context.read<DiscoverTrnstnBlc>();
                                  navBloc.updateSearchQuery(text);
                                  navBloc.showSearchResults();
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  );
                }),
            };
          },
        ),
      ),
    );
  }
}



class SearchSuggestionsShimmer extends StatelessWidget {
  const SearchSuggestionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...List.generate(
            5,
            (index) => const _SuggestionTileShimmer(),
          ),
        ],
      ),
    );
  }
}

class _SuggestionTileShimmer extends StatelessWidget {
  const _SuggestionTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.only(bottom: 16),
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
         return  Row(
          children: <Widget>[
            // Search icon placeholder
            const ATShimmer(
              height: 20,
              width: 20,
              radius: 10,
            ),
            const SizedBox(width: 12),
            
               ATShimmer(
                height: 16,
                width: ATHelperFuncs.getRandomNumber(constraints.maxWidth * 0.9), 
                radius: 3,
              ),
            
          ],
        );
        },
    )
    );
  }
}
