import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/features/discover/cubits/recent_searches_cubit.dart';
import 'package:amptive/src/features/discover/data/models/recent_search_entry.dart';
import 'package:amptive/src/features/discover/presentation/views/discover_landing_screen.dart';
import 'package:amptive/src/features/discover/presentation/widgets/search_item_tile.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/other_strings.dart';

class RecentSearchesView extends StatefulWidget {
  const RecentSearchesView({
    super.key,
  });

  @override
  State<RecentSearchesView> createState() => _RecentSearchesViewState();
}

class _RecentSearchesViewState extends State<RecentSearchesView> {
  static const int _collapsedLimit = 5;
  bool _showAll = false;

  void _openEntry(BuildContext context, RecentSearchEntry entry) {
    // Bump the entry back to the top of the list, then open it.
    context.read<RecentSearchesCubit>().add(entry);
    FocusManager.instance.primaryFocus?.unfocus();

    switch (entry.type) {
      case RecentSearchType.hashtag:
        context.pushNamed(ATRoutes.SOCIETY_HASHTAG_SCREEN, extra: entry.title);
      case RecentSearchType.show || RecentSearchType.event:
        final bool isLive = entry.status?.toLowerCase() == 'live';
        final HomeFeedItem item = HomeFeedItem(
          id: entry.id,
          title: entry.title,
          contentType:
              entry.type == RecentSearchType.show ? 'episode' : 'standalone',
          status: isLive ? 'live' : (entry.status ?? 'scheduled'),
          thumbnailUrl: entry.imageUrl,
          coverUrl: entry.imageUrl,
          showCoverUrl: entry.imageUrl,
          showTitle: entry.title,
          showType: entry.isPaid ? 'paid' : 'free',
          scheduledFor: entry.scheduledFor,
        );
        final String route = isLive
            ? entry.type == RecentSearchType.event
                ? ATRoutes.liveEventDetailed
                : ATRoutes.liveShowDetailed
            : ATRoutes.scheduleDetailed;
        context.pushNamed(route, extra: item);
      case RecentSearchType.user:
        // No target-user profile screen exists yet — re-run the search so
        // the person shows up in results.
        final DiscoverTrnstnBlc navBloc = context.read<DiscoverTrnstnBlc>();
        navBloc.updateSearchQuery(entry.title);
        navBloc.showSearchResults();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentSearchesCubit, List<RecentSearchEntry>>(
      builder: (BuildContext context, List<RecentSearchEntry> entries) {
        if (entries.isEmpty) {
          return const SizedBox.shrink();
        }

        final List<RecentSearchEntry> visibleEntries =
            _showAll ? entries : entries.take(_collapsedLimit).toList();
        final bool canToggle = entries.length > _collapsedLimit;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(ATStrings.RECENT_SEARCHES,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const Spacer(),
                  Semantics(
                    button: true,
                    label: 'Clear all recent searches',
                    child: InkWell(
                      onTap: () => context.read<RecentSearchesCubit>().clear(),
                      child: Text(
                        ATStrings.CLEAR,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: ATColors.hexB6B6B6,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ...visibleEntries.map((RecentSearchEntry entry) {
                if (entry.type == RecentSearchType.hashtag) {
                  return HashTagSearchItemTile(
                    title: entry.title,
                    onTap: () => _openEntry(context, entry),
                    onRemove: () =>
                        context.read<RecentSearchesCubit>().remove(entry),
                  );
                }
                return SearchItemTile(
                  leadingImagePath: entry.imageUrl ?? '',
                  title: entry.title,
                  isCircular: entry.type == RecentSearchType.user,
                  subtitle: entry.typeLabel,
                  isPaid: entry.isPaid,
                  statusText: entry.statusLabel,
                  onTap: () => _openEntry(context, entry),
                  onRemove: () =>
                      context.read<RecentSearchesCubit>().remove(entry),
                );
              }),
              if (canToggle)
                SizedBox(
                  height: 44,
                  child: TextButton(
                    onPressed: () => setState(() => _showAll = !_showAll),
                    style: TextButton.styleFrom(
                      foregroundColor: ATColors.hexC2C2C2,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(44, 44),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(_showAll ? 'See less' : 'See more'),
                        const SizedBox(width: 5),
                        Icon(
                          _showAll
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 160),
            ],
          ),
        );
      },
    );
  }
}
