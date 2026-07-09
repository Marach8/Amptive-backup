import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/cubits/communities_cubit.dart';
import 'package:amptive/src/features/discover/cubits/trending_hashtags_cubit.dart';
import 'package:amptive/src/features/discover/data/mock_trending_hashtags.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/features/discover/data/models/response/trending_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/discover_export.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/cubits/live_users_cubit.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/home/data/models/response/live_users_response_model.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_actions_modal.dart';
import 'package:amptive/src/features/discover/presentation/widgets/preferred_community_trend_row.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nested/nested.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/full_discover_view_widgets/discover_categories_title.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/full_discover_view_widgets/more_to_discover_title.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';

typedef _MockFeedCard = ({
  String avatar,
  String creator,
  String image,
  bool isPaid,
  String status,
  String title,
  HomeFeedItem? source,
});

typedef _TopCreatorEntry = ({
  String id,
  String image,
  String name,
  HomeFeedItem program,
});

const List<_MockFeedCard> _mockTrendingCards = <_MockFeedCard>[
  (
    avatar: ATImgStrings.jpeg1,
    creator: 'glendonnoyle',
    image: ATImgStrings.weCanDoHardThingsBgImage,
    isPaid: true,
    status: 'LIVE',
    title: "Don't forget who you are",
    source: null,
  ),
  (
    avatar: ATImgStrings.jpeg2,
    creator: 'ankria22',
    image: ATImgStrings.OFFICE_LADIES,
    isPaid: false,
    status: 'LIVE',
    title: 'The conversation everyone is having',
    source: null,
  ),
  (
    avatar: ATImgStrings.jpeg3,
    creator: 'mayaelise',
    image: ATImgStrings.ENDLESS_THREAD,
    isPaid: true,
    status: '15 JUL',
    title: 'A story worth hearing live',
    source: null,
  ),
  (
    avatar: ATImgStrings.MAN_PHOTO,
    creator: 'chineduoko',
    image: ATImgStrings.JOE_POMP_SHOW,
    isPaid: false,
    status: 'MON',
    title: 'Inside the moment',
    source: null,
  ),
  (
    avatar: ATImgStrings.leftAvatar,
    creator: 'lensbyada',
    image: ATImgStrings.CRIMINAL,
    isPaid: false,
    status: 'LIVE',
    title: 'What happens next?',
    source: null,
  ),
];

String _discoverStatusFor(HomeFeedItem item) {
  if (item.status?.toLowerCase() == 'live') return 'LIVE';
  final DateTime? scheduled = DateTime.tryParse(item.scheduledFor ?? '');
  if (scheduled == null) return 'SCHEDULED';
  return DateFormat.MMMd().format(scheduled).toUpperCase();
}

List<_MockFeedCard> _mixedDiscoverCards(List<HomeFeedItem> apiItems) {
  final List<HomeFeedItem> usableItems = apiItems.where((HomeFeedItem item) {
    return (item.title?.trim().isNotEmpty ?? false) &&
        (item.contentType == 'episode' || item.contentType == 'standalone');
  }).toList();
  final List<_MockFeedCard> result = <_MockFeedCard>[];
  int apiIndex = 0;

  for (int index = 0; index < _mockTrendingCards.length; index++) {
    if (index.isEven && apiIndex < usableItems.length) {
      final HomeFeedItem item = usableItems[apiIndex++];
      final _MockFeedCard fallback = _mockTrendingCards[index];
      result.add((
        avatar: item.hostProfileImageUrl?.trim().isNotEmpty == true
            ? item.hostProfileImageUrl!
            : fallback.avatar,
        creator: item.hostName?.trim().isNotEmpty == true
            ? item.hostName!
            : fallback.creator,
        image: item.thumbnailUrl?.trim().isNotEmpty == true
            ? item.thumbnailUrl!
            : item.showCoverUrl?.trim().isNotEmpty == true
                ? item.showCoverUrl!
                : item.coverUrl?.trim().isNotEmpty == true
                    ? item.coverUrl!
                    : fallback.image,
        isPaid: (item.price ?? 0) > 0,
        status: _discoverStatusFor(item),
        title: item.title!,
        source: item,
      ));
    } else {
      result.add(_mockTrendingCards[index]);
    }
  }
  return result;
}

void _openDiscoverCard(BuildContext context, _MockFeedCard card) {
  // Drop any lingering focus (e.g. the search field) before pushing the
  // modal, otherwise the framework restores it — cursor, keyboard and all —
  // when the modal is drag-dismissed.
  FocusManager.instance.primaryFocus?.unfocus();
  final HomeFeedItem? item = card.source;
  final bool isLive = card.status == 'LIVE';
  final String route = isLive
      ? item?.contentType == 'standalone'
          ? ATRoutes.liveEventDetailed
          : ATRoutes.liveShowDetailed
      : ATRoutes.scheduleDetailed;
  context.pushNamed(route, extra: item);
}

void _openHomeFeedItem(BuildContext context, HomeFeedItem item) {
  FocusManager.instance.primaryFocus?.unfocus();
  final bool isLive = item.status?.toLowerCase() == 'live';
  final String route = isLive
      ? item.contentType == 'standalone'
          ? ATRoutes.liveEventDetailed
          : ATRoutes.liveShowDetailed
      : ATRoutes.scheduleDetailed;
  context.pushNamed(route, extra: item);
}

HomeFeedItem _mockCommunityFeedItem(
  _MockFeedCard card,
  String communityName,
  int index,
) {
  final bool isLive = card.status == 'LIVE';
  return HomeFeedItem(
    id: 'discover_${communityName.toLowerCase()}_$index',
    title: card.title,
    contentType: index.isEven ? 'episode' : 'standalone',
    status: isLive ? 'live' : 'scheduled',
    hostId: 'discover_${card.creator}',
    hostName: card.creator,
    hostProfileImageUrl: card.avatar,
    thumbnailUrl: card.image,
    coverUrl: card.image,
    showCoverUrl: card.image,
    showTitle: card.title,
    showType: card.isPaid ? 'paid' : 'free',
    price: card.isPaid ? 5 : 0,
    scheduledFor: isLive ? null : '2026-07-15T18:00:00Z',
    communityName: communityName,
    viewerCount: isLive ? 124 : null,
    goingCount: isLive ? null : 42,
    requesterFollowsHost: false,
    requesterIsGoing: false,
    avatarUrls: <String>[card.avatar],
  );
}

/// Snaps a horizontal list to fixed-extent item boundaries, like the paged
/// chart carousels in Spotify / Apple Music.
class _SnapScrollPhysics extends ScrollPhysics {
  const _SnapScrollPhysics({required this.snapExtent, super.parent});

  final double snapExtent;

  @override
  _SnapScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      _SnapScrollPhysics(snapExtent: snapExtent, parent: buildParent(ancestor));

  double _targetPixels(
    ScrollMetrics position,
    Tolerance tolerance,
    double velocity,
  ) {
    // Project where a natural fling would land, then round to the grid, so
    // strong flings can travel several items instead of stopping after one.
    final double projected = velocity.abs() < tolerance.velocity
        ? position.pixels
        : FrictionSimulation(0.135, position.pixels, velocity).finalX;
    double target = (projected / snapExtent).roundToDouble() * snapExtent;
    // A deliberate fling should always move at least one item.
    if (velocity > tolerance.velocity && target <= position.pixels) {
      target += snapExtent;
    } else if (velocity < -tolerance.velocity && target >= position.pixels) {
      target -= snapExtent;
    }
    return target.clamp(position.minScrollExtent, position.maxScrollExtent);
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = toleranceFor(position);
    final double target = _targetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }
    return null;
  }
}

Widget _preferredCommunityRows({
  required BuildContext context,
  required String communityName,
  required List<HomeFeedItem> apiItems,
  required List<_MockFeedCard> fallbackCards,
}) {
  final String normalizedCommunity = communityName.toLowerCase();
  final List<HomeFeedItem> items = apiItems
      .where(
        (HomeFeedItem item) =>
            item.communityName?.toLowerCase() == normalizedCommunity,
      )
      .take(6)
      .toList();
  if (items.isEmpty) {
    items.addAll(
      List<HomeFeedItem>.generate(
        6,
        (int index) => _mockCommunityFeedItem(
          fallbackCards[index % fallbackCards.length],
          communityName,
          index,
        ),
      ),
    );
  }

  final int columnCount = (items.length / 3).ceil();
  final double columnWidth = MediaQuery.sizeOf(context).width - 36;

  // Each row is 112 tall (96 artwork + 8 vertical padding each side) with a
  // 1px divider between rows; shrink the list when a community has < 3 items.
  final int rowsPerColumn = items.length < 3 ? items.length : 3;
  final double listHeight =
      (rowsPerColumn * 112) + (rowsPerColumn - 1).toDouble();

  return SizedBox(
    height: listHeight,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: _SnapScrollPhysics(snapExtent: columnWidth + 12),
      // Trailing inset must equal the column gap (12) plus the edge inset
      // (12) so the final snap position leaves the last column's left edge
      // aligned with the 12px title margin instead of clamping short.
      padding: const EdgeInsets.only(left: 12, right: 24),
      itemCount: columnCount,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, int columnIndex) {
        final int startIndex = columnIndex * 3;
        final int endIndex = (startIndex + 3).clamp(0, items.length);
        final List<HomeFeedItem> columnItems = items.sublist(
          startIndex,
          endIndex,
        );
        return SizedBox(
          width: columnWidth,
          child: Column(
            children: List<Widget>.generate(columnItems.length, (int index) {
              final HomeFeedItem item = columnItems[index];
              return Column(
                children: <Widget>[
                  PreferredCommunityTrendRow(
                    item: item,
                    onTap: () => _openHomeFeedItem(context, item),
                    onMoreTap: () async {
                      final ToggleFollowingCubit cubit = ToggleFollowingCubit(
                        initialStatus: FollowingStatus(
                          isFollowing: item.requesterFollowsHost,
                          followerCount: item.goingCount,
                        ),
                      );
                      await showProgramOptions(
                        context: context,
                        toggleFollowingCubit: cubit,
                        targetUserName: item.hostName ?? '',
                        targetUserId: item.hostId ?? '',
                        targetUserProfileUrl: item.hostProfileImageUrl,
                      );
                      await cubit.close();
                    },
                  ),
                  if (index != columnItems.length - 1)
                    Divider(
                      height: 1,
                      color: ATColors.hex252525,
                    ),
                ],
              );
            }),
          ),
        );
      },
    ),
  );
}

Widget _communitySection({
  required BuildContext context,
  required String communityName,
  required String? communityId,
  required List<HomeFeedItem> apiItems,
  required List<_MockFeedCard> fallbackCards,
}) {
  return Column(
    children: <Widget>[
      DiscoverCategoriesTile(
        categoryName: communityName,
        onTap: communityId == null
            ? null
            : () => context.pushNamed(
                  ATRoutes.SOCIETY_SCREEN,
                  extra: <String, String>{
                    'communityId': communityId,
                    'communityName': communityName,
                  },
                ),
        trailing: FollowUnfollowDropDown(
          communityName: communityName,
          communityId: communityId,
          text: ATStrings.FOLLOW,
          onSelected: (String po) {},
          popUpTrailingIcon: const Icon(Icons.add_circle_outline),
          child: SvgPicture.asset(
            ATImgStrings.moreHorizontalFilledIcon,
            width: 30,
            height: 30,
          ),
        ),
      ),
      const SizedBox(height: 8),
      _preferredCommunityRows(
        context: context,
        communityName: communityName,
        apiItems: apiItems,
        fallbackCards: fallbackCards,
      ),
      const SizedBox(height: 12),
      Divider(
        height: 1,
        indent: 12,
        endIndent: 12,
        color: ATColors.hex252525,
      ),
      const SizedBox(height: 32),
    ],
  );
}

class MainDiscoverView extends StatefulWidget {
  const MainDiscoverView({super.key});

  @override
  State<MainDiscoverView> createState() => _MainDiscoverViewState();
}

class _MainDiscoverViewState extends State<MainDiscoverView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final HomeFeedCubit cubit = context.read<HomeFeedCubit>();
      if ((cubit.currentHomeFeedData?.homeFeedItems?.isEmpty ?? true)) {
        cubit.fetchHomeFeed();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double textScaleAllowance =
        (MediaQuery.textScalerOf(context).scale(14) - 14).clamp(0, 14) * 2;
    final double compactCardHeight = 195 + textScaleAllowance;
    final List<HomeFeedItem> apiFeedItems =
        context.watch<HomeFeedCubit>().currentHomeFeedData?.homeFeedItems ??
            <HomeFeedItem>[];
    final List<_MockFeedCard> discoverCards = _mixedDiscoverCards(apiFeedItems);
    final List<LiveUser> liveUsers =
        context.watch<LiveUsersCubit>().currentLiveUsersData?.liveUsers ??
            <LiveUser>[];
    final Set<String> seenCreatorIds = <String>{};
    final List<_TopCreatorEntry> topCreators = <_TopCreatorEntry>[];
    for (final HomeFeedItem item in apiFeedItems) {
      final String name = item.hostName?.trim() ?? '';
      final String id = item.hostId?.trim().isNotEmpty == true
          ? item.hostId!
          : name.toLowerCase();
      final bool isProgram =
          item.contentType == 'episode' || item.contentType == 'standalone';
      if (isProgram && name.isNotEmpty && seenCreatorIds.add(id)) {
        topCreators.add((
          id: id,
          image: item.hostProfileImageUrl?.trim().isNotEmpty == true
              ? item.hostProfileImageUrl!
              : ATImgStrings.noAvatarImage,
          name: name,
          program: item,
        ));
      }
      if (topCreators.length == 5) break;
    }
    for (final LiveUser user in liveUsers) {
      if (topCreators.length == 5) break;
      final String name = user.username?.trim() ?? '';
      final String id = user.userId?.trim().isNotEmpty == true
          ? user.userId!
          : name.toLowerCase();
      if (name.isEmpty || !seenCreatorIds.add(id)) continue;
      topCreators.add((
        id: id,
        image: user.profileImageUrl?.trim().isNotEmpty == true
            ? user.profileImageUrl!
            : ATImgStrings.noAvatarImage,
        name: name,
        program: HomeFeedItem(
          id: user.contentId,
          showId: user.showId,
          contentType: user.contentType,
          status: 'live',
          hostId: user.userId,
          hostName: name,
          hostProfileImageUrl: user.profileImageUrl,
        ),
      ));
    }

    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<TrendingHashtagsCubit>(
            create: (_) => TrendingHashtagsCubit()..fetchTrendingTags()),
        BlocProvider<CommunitiesCubit>(
            create: (_) => CommunitiesCubit()..fetchCommunities())
      ],
      child: Column(
        children: <Widget>[
          const HorizontalScrollCards(),
          const SizedBox(height: 34),

          HastagHeadingRow(
            title: ATStrings.trendingHashtags,
            viewAllOnpressed: () {
              context.pushNamed(ATRoutes.TRENDING_HASHTAGS_SCREEN);
            },
          ),
          const SizedBox(height: 12),

          BlocBuilder<TrendingHashtagsCubit,
              ATAppState<TrendingTagsResponseModel>>(
            builder: (BuildContext context,
                ATAppState<TrendingTagsResponseModel> state) {
              return switch (state) {
                InitialState<TrendingTagsResponseModel>() =>
                  const SizedBox.shrink(),
                LoadingState<TrendingTagsResponseModel>() ||
                FailureState<TrendingTagsResponseModel>() ||
                SuccessState<TrendingTagsResponseModel>() =>
                  Builder(
                    builder: (BuildContext context) {
                      final TrendingTagsResponseModel? hashtagsData = context
                          .read<TrendingHashtagsCubit>()
                          .currentTrendingTags;
                      final List<HashTag> apiHashtags =
                          hashtagsData?.trendingHashtag ?? <HashTag>[];
                      final List<HashTag> trendingHashtags = apiHashtags.isEmpty
                          ? mockTrendingHashtags
                          : apiHashtags;

                      if (trendingHashtags.isEmpty) {
                        if (state is LoadingState) {
                          return const Column(
                            children: <Widget>[
                              RenderTrendingHashtagRowShimmer(),
                              RenderTrendingHashtagRowShimmer(),
                            ],
                          );
                        }
                        if (state is FailureState) {
                          return Center(
                            child: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => context
                                  .read<TrendingHashtagsCubit>()
                                  .fetchTrendingTags(),
                            ),
                          );
                        }
                        return const Center(
                          child: Text(
                              'No trending hashtags available at the moment'),
                        );
                      }

                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: HashTagsSubtitleRow(
                              trailingOnpressed: () => context.pushNamed(
                                ATRoutes.SOCIETY_HASHTAG_SCREEN,
                                extra: <String, dynamic>{
                                  'hashtagName':
                                      (trendingHashtags[0].name ?? '')
                                          .replaceFirst(RegExp(r'^#+'), ''),
                                  'isTopThree': true,
                                },
                              ),
                              hashTagTitle: trendingHashtags[0].name ?? '',
                              hashTagSubTitle: mockTrendingActivityTextFor(
                                trendingHashtags[0],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: compactCardHeight,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // Card width 145 + 16 trailing gap.
                              physics:
                                  const _SnapScrollPhysics(snapExtent: 161),
                              itemCount: 5,
                              padding: const EdgeInsets.only(left: 12),
                              itemBuilder: (_, int index) {
                                final _MockFeedCard card = discoverCards[index];
                                return RenderTrendingHashTag(
                                  trendingPicture: card.image,
                                  title: card.title,
                                  creatorName: card.creator,
                                  creatorAvatar: card.avatar,
                                  isPaid: card.isPaid,
                                  statusLabel: card.status,
                                  squareArtwork: true,
                                  trailingSpacing: index == 4 ? 0 : 16,
                                  onTap: () => _openDiscoverCard(context, card),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          Divider(
                            height: 1,
                            indent: 12,
                            endIndent: 12,
                            color: ATColors.hex252525,
                          ),
                          const SizedBox(height: 24),
                          if (trendingHashtags.length > 1) ...<Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: HashTagsSubtitleRow(
                                trailingOnpressed: () => context.pushNamed(
                                  ATRoutes.SOCIETY_HASHTAG_SCREEN,
                                  extra: <String, dynamic>{
                                    'hashtagName':
                                        (trendingHashtags[1].name ?? '')
                                            .replaceFirst(RegExp(r'^#+'), ''),
                                    'isTopThree': true,
                                  },
                                ),
                                hashTagTitle: trendingHashtags[1].name ?? '',
                                hashTagSubTitle: mockTrendingActivityTextFor(
                                  trendingHashtags[1],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: compactCardHeight,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics:
                                    const _SnapScrollPhysics(snapExtent: 161),
                                itemCount: 5,
                                padding: const EdgeInsets.only(left: 12),
                                itemBuilder: (_, int index) {
                                  final _MockFeedCard card =
                                      discoverCards[index];
                                  return RenderTrendingHashTag(
                                    trendingPicture: card.image,
                                    title: card.title,
                                    creatorName: card.creator,
                                    creatorAvatar: card.avatar,
                                    isPaid: card.isPaid,
                                    statusLabel: card.status,
                                    squareArtwork: true,
                                    trailingSpacing: index == 4 ? 0 : 16,
                                    onTap: () =>
                                        _openDiscoverCard(context, card),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            Divider(
                              height: 1,
                              indent: 12,
                              endIndent: 12,
                              color: ATColors.hex252525,
                            ),
                          ],
                        ],
                      );
                    },
                  )
              };
            },
          ),

          const SizedBox(height: 40),

          ATContainer(
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            child: Text(
              ATStrings.SPOTLIGHT,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: compactCardHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const _SnapScrollPhysics(snapExtent: 161),
              padding: const EdgeInsets.only(left: 12),
              children: List<Widget>.generate(5, (int index) {
                final _MockFeedCard card = discoverCards[index];
                return RenderTrendingHashTag(
                  trendingPicture: card.image,
                  title: card.title,
                  creatorName: card.creator,
                  creatorAvatar: card.avatar,
                  isPaid: card.isPaid,
                  statusLabel: card.status,
                  squareArtwork: true,
                  trailingSpacing: index == 4 ? 0 : 16,
                  onTap: () => _openDiscoverCard(context, card),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          Divider(
            height: 1,
            indent: 12,
            endIndent: 12,
            color: ATColors.hex252525,
          ),
          const SizedBox(height: 40),

          // Community sections, driven by the communities API with the
          // original hard-coded categories as a fallback.
          BlocBuilder<CommunitiesCubit, ATAppState<CommunitiesResponseModel>>(
            builder: (BuildContext context,
                ATAppState<CommunitiesResponseModel> state) {
              final CommunitiesResponseModel? data =
                  context.read<CommunitiesCubit>().currentCommunities;
              final Map<String, Community> communities =
                  data?.communities ?? <String, Community>{};

              final List<({String name, String? id})> sections =
                  (data?.communityIds ?? <String>[])
                      .map((String id) => communities[id])
                      .whereType<Community>()
                      .where((Community community) =>
                          community.name?.trim().isNotEmpty ?? false)
                      .take(3)
                      .map((Community community) =>
                          (name: community.name!, id: community.communityId))
                      .toList();

              if (sections.isEmpty) {
                sections.addAll(<({String name, String? id})>[
                  (name: ATStrings.TECHNOLOGY, id: null),
                  (name: ATStrings.SPORTS, id: null),
                  (name: ATStrings.TRUE_CRIME, id: null),
                ]);
              }

              return Column(
                children: List<Widget>.generate(sections.length, (int index) {
                  final ({String name, String? id}) section = sections[index];
                  return _communitySection(
                    context: context,
                    communityName: section.name,
                    communityId: section.id,
                    apiItems: apiFeedItems,
                    fallbackCards: <_MockFeedCard>[
                      ...discoverCards.skip(index),
                      ...discoverCards.take(index),
                    ],
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 4),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: AmptiveMore2DiscoverTitle(),
          ),
          const SizedBox(height: 18),

          BlocBuilder<CommunitiesCubit, ATAppState<CommunitiesResponseModel>>(
            builder: (BuildContext context,
                ATAppState<CommunitiesResponseModel> state) {
              return switch (state) {
                InitialState<CommunitiesResponseModel>() =>
                  const SizedBox.shrink(),
                LoadingState<CommunitiesResponseModel>() ||
                FailureState<CommunitiesResponseModel>() ||
                SuccessState<CommunitiesResponseModel>() =>
                  Builder(
                    builder: (BuildContext context) {
                      final CommunitiesResponseModel? community =
                          context.read<CommunitiesCubit>().currentCommunities;
                      final Map<String, Community> communities =
                          community?.communities ?? <String, Community>{};
                      final List<String> communityIds =
                          community?.communityIds ?? <String>[];

                      if (communities.isEmpty) {
                        if (state is LoadingState) {
                          return const Center(
                              child: DiscoverPageCommunitiesShimmer());
                        }
                        if (state is FailureState) {
                          return Center(
                            child: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => context
                                  .read<CommunitiesCubit>()
                                  .fetchCommunities(),
                            ),
                          );
                        }
                        return const Center(
                            child: Text('Communities not available yet'));
                      }

                      return SizedBox(
                        height: 122,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          // Card width 170 + 12 trailing margin.
                          physics: const _SnapScrollPhysics(snapExtent: 182),
                          padding: const EdgeInsets.only(left: 12),
                          itemCount: communityIds.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String id = communityIds[index];
                            final Community? community = communities[id];

                            return CommunityCardWidget(
                              picture: community?.image ??
                                  ATImgStrings.COMMUNITY_CARD,
                              semanticLabel:
                                  '${community?.name ?? 'Community'} community',
                              onTap: () => context.pushNamed(
                                ATRoutes.SOCIETY_SCREEN,
                                extra: <String, String>{
                                  'communityId': id,
                                  'communityName':
                                      community?.name ?? 'Community',
                                },
                              ),
                              //title: community?.name,
                            );
                          },
                        ),
                      );
                    },
                  ),
              };
            },
          ),
          const SizedBox(height: 24),
          Divider(indent: 12, endIndent: 12, color: ATColors.hex252525),
          const SizedBox(height: 40),

          ATContainer(
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            child: Text(
              ATStrings.TOP_CREATORS,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: compactCardHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              // Tile carries its own 12 leading padding + 150 width.
              physics: const _SnapScrollPhysics(snapExtent: 162),
              children: topCreators
                  .map(
                    (_TopCreatorEntry creator) => TopCreatorWidget(
                      picture: creator.image,
                      creatorName: creator.name,
                      onTap: () => _openHomeFeedItem(context, creator.program),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          Divider(
            height: 1,
            indent: 12,
            endIndent: 12,
            color: ATColors.hex252525,
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}

class DiscoverPageCommunitiesShimmer extends StatelessWidget {
  const DiscoverPageCommunitiesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 122,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 12),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return const RenderCommunityCardShimmer();
        },
      ),
    );
  }
}
