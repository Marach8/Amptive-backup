import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/discover/presentation/views/discover_page_view.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'hashtag_heading_row.dart';
import 'render_trending_hashtag.dart';
import 'top_creator_widget.dart';

enum CommunityFeedMode { all, shows, events }

void _openCommunityItem(BuildContext context, HomeFeedItem item) {
  FocusManager.instance.primaryFocus?.unfocus();
  final bool isLive = item.status?.toLowerCase() == 'live';
  final String route = isLive
      ? item.contentType == 'standalone'
          ? ATRoutes.liveEventDetailed
          : ATRoutes.liveShowDetailed
      : ATRoutes.scheduleDetailed;
  context.pushNamed(route, extra: item);
}

class SocietyAllTabView extends StatelessWidget {
  const SocietyAllTabView({
    super.key,
    this.communityId,
    required this.communityName,
  });

  final String? communityId;
  final String communityName;

  @override
  Widget build(BuildContext context) => CommunityFeedSections(
        communityName: communityName,
        mode: CommunityFeedMode.all,
      );
}

class CommunityFeedSections extends StatelessWidget {
  const CommunityFeedSections({
    super.key,
    required this.communityName,
    required this.mode,
  });

  final String communityName;
  final CommunityFeedMode mode;

  bool _sameCommunity(HomeFeedItem item) =>
      item.communityName?.trim().toLowerCase() ==
      communityName.trim().toLowerCase();

  bool _isShow(HomeFeedItem item) => item.contentType == 'episode';
  bool _isEvent(HomeFeedItem item) => item.contentType == 'standalone';
  bool _isPaid(HomeFeedItem item) =>
      item.showType?.toLowerCase() == 'paid' || (item.price ?? 0) > 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeFeedCubit, ATAppState<HomeFeedResponseModel>>(
      builder: (BuildContext context, ATAppState<HomeFeedResponseModel> state) {
        final List<HomeFeedItem> allItems =
            context.read<HomeFeedCubit>().currentHomeFeedData?.homeFeedItems ??
                <HomeFeedItem>[];
        final List<HomeFeedItem> communityItems =
            allItems.where(_sameCommunity).toList();

        if (communityItems.isEmpty) {
          if (state is InitialState<HomeFeedResponseModel> ||
              state is LoadingState<HomeFeedResponseModel>) {
            // Same spinner as the "view all communities" screen — not a
            // skeleton.
            return const SizedBox(
              height: 180,
              child: Center(
                child: CupertinoActivityIndicator(
                  radius: 14,
                  color: Colors.white,
                ),
              ),
            );
          }
          if (state is FailureState<HomeFeedResponseModel>) {
            return Center(
              child: IconButton(
                onPressed: () => context.read<HomeFeedCubit>().fetchHomeFeed(),
                icon: const Icon(Icons.refresh),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 80),
            child: Text(
              'Nothing has been published in $communityName yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ATColors.hexC2C2C2,
                  ),
            ),
          );
        }

        final List<HomeFeedItem> shows = communityItems.where(_isShow).toList();
        final List<HomeFeedItem> events =
            communityItems.where(_isEvent).toList();

        // A tab whose own category is empty gets a proper empty state
        // instead of a blank page.
        final List<HomeFeedItem> modeItems = switch (mode) {
          CommunityFeedMode.all => communityItems,
          CommunityFeedMode.shows => shows,
          CommunityFeedMode.events => events,
        };
        if (modeItems.isEmpty) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 80),
            child: Text(
              mode == CommunityFeedMode.shows
                  ? 'No shows in $communityName yet.'
                  : 'No events in $communityName yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ATColors.hexC2C2C2,
                  ),
            ),
          );
        }

        final List<Widget> sections = <Widget>[];

        void addCards(String title, List<HomeFeedItem> items) {
          if (items.isEmpty) return;
          if (sections.isNotEmpty) {
            sections.add(const SeparatorDivider());
            sections.add(const SizedBox(height: 35));
          }
          sections.add(HastagHeadingRow(
            title: title,
            viewAllOnpressed: () => context.pushNamed(
              ATRoutes.TRENDING_SOCIETY_SCREEN,
              extra: <String, dynamic>{'title': title, 'items': items},
            ),
          ));
          sections.add(const SizedBox(height: 10));
          sections.add(_CommunityContentRow(items: items));
        }

        if (mode == CommunityFeedMode.all) {
          final List<HomeFeedItem> trending = List<HomeFeedItem>.from(
            communityItems,
          )..sort((HomeFeedItem a, HomeFeedItem b) =>
              (b.score ?? 0).compareTo(a.score ?? 0));
          addCards(ATStrings.TRENDING, trending);
          addCards(ATStrings.PAID_SHOWS, shows.where(_isPaid).toList());
          addCards(ATStrings.FREE_SHOWS,
              shows.where((HomeFeedItem item) => !_isPaid(item)).toList());

          if (sections.isNotEmpty) {
            sections.add(const SeparatorDivider());
            sections.add(const SizedBox(height: 35));
          }
          sections.add(_CommunityCreators(items: communityItems));

          addCards(ATStrings.PAID_EVENTS, events.where(_isPaid).toList());
          addCards(ATStrings.FREE_EVENTS,
              events.where((HomeFeedItem item) => !_isPaid(item)).toList());
        } else if (mode == CommunityFeedMode.shows) {
          addCards(ATStrings.TRENDING, shows);
          addCards(ATStrings.PAID_SHOWS, shows.where(_isPaid).toList());
          addCards(ATStrings.FREE_SHOWS,
              shows.where((HomeFeedItem item) => !_isPaid(item)).toList());
        } else {
          addCards(ATStrings.TRENDING, events);
          addCards(ATStrings.PAID_EVENTS, events.where(_isPaid).toList());
          addCards(ATStrings.FREE_EVENTS,
              events.where((HomeFeedItem item) => !_isPaid(item)).toList());
        }

        sections.add(const SizedBox(height: 50));
        return Column(children: sections);
      },
    );
  }
}

class _CommunityContentRow extends StatelessWidget {
  const _CommunityContentRow({required this.items});

  final List<HomeFeedItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 15),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final HomeFeedItem item = items[index];
          final bool isLive = item.status?.toLowerCase() == 'live';
          return RenderTrendingHashTag(
            trendingPicture: item.thumbnailUrl ??
                item.coverUrl ??
                item.showCoverUrl ??
                ATImgStrings.createShowPlaceholder,
            title: item.title ?? item.showTitle,
            creatorName: item.hostName ?? 'Creator',
            creatorAvatar:
                item.hostProfileImageUrl ?? ATImgStrings.noAvatarImage,
            statusLabel: isLive ? 'LIVE' : 'Scheduled',
            isPaid:
                item.showType?.toLowerCase() == 'paid' || (item.price ?? 0) > 0,
            onTap: () => _openCommunityItem(context, item),
          );
        },
      ),
    );
  }
}

class _CommunityCreators extends StatelessWidget {
  const _CommunityCreators({required this.items});

  final List<HomeFeedItem> items;

  @override
  Widget build(BuildContext context) {
    final Map<String, HomeFeedItem> creators = <String, HomeFeedItem>{};
    for (final HomeFeedItem item in items) {
      final String key = item.hostId ?? item.hostName ?? '';
      if (key.isNotEmpty) creators.putIfAbsent(key, () => item);
    }
    if (creators.isEmpty) return const SizedBox.shrink();

    final List<HomeFeedItem> creatorItems = creators.values.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            ATStrings.POPULAR_CREATORS,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: creatorItems.length,
            itemBuilder: (BuildContext context, int index) {
              final HomeFeedItem creator = creatorItems[index];
              return TopCreatorWidget(
                picture:
                    creator.hostProfileImageUrl ?? ATImgStrings.noAvatarImage,
                creatorName: creator.hostName ?? 'Creator',
                onTap: () => _openCommunityItem(context, creator),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SeparatorDivider extends StatelessWidget {
  const SeparatorDivider({super.key});

  @override
  Widget build(BuildContext context) =>
      Divider(indent: 15, endIndent: 15, color: ATColors.hex252525);
}
