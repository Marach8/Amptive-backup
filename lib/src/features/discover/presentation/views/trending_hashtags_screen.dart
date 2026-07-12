import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/features/discover/cubits/trending_hashtags_cubit.dart';
import 'package:amptive/src/features/discover/data/models/response/trending_hashtags_response_model.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/discover/discover_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:amptive/src/shared/blurred_header.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:amptive/src/shared/refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';

class TrendingHashTagsScreen extends StatelessWidget {
  const TrendingHashTagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<TrendingHashtagsCubit>(
          create: (_) => TrendingHashtagsCubit()..fetchTrendingTags(),
        ),
        BlocProvider<HomeFeedCubit>(
          create: (_) => HomeFeedCubit()..refreshHomeFeed(),
        ),
      ],
      child: ATAnnotatedRegion(
        child: Scaffold(
          // Same as the dashboard: keeps the safe-area padding inside the
          // bottom menu so its height matches everywhere.
          resizeToAvoidBottomInset: false,
          bottomSheet: const AppBottomMenu(),
          body: BlocProvider<BlurredHeaderCubit>(
            create: (_) => BlurredHeaderCubit(),
            child: Builder(
              builder: (BuildContext blocContext) =>
                  NotificationListener<ScrollNotification>(
                onNotification:
                    blocContext.read<BlurredHeaderCubit>().onScrollNotification,
                child: BlocConsumer<TrendingHashtagsCubit,
                    ATAppState<TrendingTagsResponseModel>>(
                  listener: (BuildContext context,
                      ATAppState<TrendingTagsResponseModel> state) {
                    if (state is FailureState<TrendingTagsResponseModel>) {
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                  builder: (BuildContext context,
                      ATAppState<TrendingTagsResponseModel> state) {
                    return switch (state) {
                      InitialState<TrendingTagsResponseModel>() =>
                        const SizedBox.shrink(),
                      LoadingState<TrendingTagsResponseModel>() ||
                      FailureState<TrendingTagsResponseModel>() ||
                      SuccessState<TrendingTagsResponseModel>() =>
                        ATRefreshIndicator(
                          indicatorTopOffset:
                              MediaQuery.paddingOf(context).top +
                                  kToolbarHeight +
                                  12,
                          onRefresh: () async {
                            await Future.wait(<Future<void>>[
                              context
                                  .read<TrendingHashtagsCubit>()
                                  .fetchTrendingTags(),
                              context.read<HomeFeedCubit>().refreshHomeFeed(),
                            ]);
                          },
                          child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            slivers: <Widget>[
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: ATSliverHDelegate(
                                  maxExt: kToolbarHeight +
                                      MediaQuery.paddingOf(context).top,
                                  minExt: kToolbarHeight +
                                      MediaQuery.paddingOf(context).top,
                                  child: ATBlurredHeaderWidget(
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: ATBackBtn(
                                            alignment: Alignment.centerLeft,
                                            leadingText:
                                                ATStrings.trendingHashtags,
                                            leadingStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontSize: ATSizes.size23,
                                                  letterSpacing: -0.39,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 16),
                              ),
                              BlocBuilder<HomeFeedCubit,
                                  ATAppState<HomeFeedResponseModel>>(
                                builder: (BuildContext context,
                                    ATAppState<HomeFeedResponseModel>
                                        feedState) {
                                  final TrendingTagsResponseModel? hashtags =
                                      context
                                          .read<TrendingHashtagsCubit>()
                                          .currentTrendingTags;
                                  final List<HashTag> apiHashtags =
                                      hashtags?.trendingHashtag ?? <HashTag>[];
                                  final List<HomeFeedItem> feedItems = context
                                          .read<HomeFeedCubit>()
                                          .currentHomeFeedData
                                          ?.homeFeedItems ??
                                      <HomeFeedItem>[];
                                  final List<HashTag> trendingHashtags =
                                      apiHashtags.isNotEmpty
                                          ? apiHashtags
                                          : _trendingTagsFromFeed(feedItems);

                                  if (trendingHashtags.isEmpty) {
                                    if (state is LoadingState ||
                                        feedState is LoadingState<
                                            HomeFeedResponseModel>) {
                                      return SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: Center(
                                          child: Transform.translate(
                                            offset: const Offset(0, -120),
                                            child:
                                                const CupertinoActivityIndicator(
                                              radius: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    if (state is FailureState) {
                                      return SliverFillRemaining(
                                        child: Center(
                                          child: IconButton(
                                            icon: const Icon(Icons.refresh),
                                            onPressed: () => context
                                                .read<TrendingHashtagsCubit>()
                                                .fetchTrendingTags(),
                                          ),
                                        ),
                                      );
                                    }
                                    return SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Center(
                                        child: Transform.translate(
                                          offset: const Offset(0, -120),
                                          child: const Text(
                                            'No trending hashtags available at the moment',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return SliverList(
                                    delegate:
                                        SliverChildListDelegate.fixed(<Widget>[
                                      ...trendingHashtags
                                          .asMap()
                                          .entries
                                          .map((MapEntry<int, HashTag> entry) {
                                        final List<HomeFeedItem> taggedItems =
                                            _itemsForTag(
                                                feedItems, entry.value);
                                        return Column(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: HashTagsSubtitleRow(
                                                hashTagTitle:
                                                    entry.value.name ?? '',
                                                hashTagSubTitle:
                                                    _hashtagActivityText(
                                                  entry.value,
                                                  taggedItems,
                                                ),
                                                showFlame: entry.key < 3,
                                                trailingOnpressed: () =>
                                                    context.pushNamed(
                                                  ATRoutes
                                                      .SOCIETY_HASHTAG_SCREEN,
                                                  extra: <String, dynamic>{
                                                    'hashtagName':
                                                        _normaliseTag(
                                                      entry.value.name ??
                                                          entry.value
                                                              .displayName,
                                                    ),
                                                    'isTopThree': entry.key < 3,
                                                  },
                                                ),
                                              ),
                                            ),
                                            if (taggedItems
                                                .isNotEmpty) ...<Widget>[
                                              const SizedBox(height: 10),
                                              _TaggedContentRow(
                                                items: taggedItems,
                                              ),
                                            ],
                                            const SizedBox(height: 40),
                                          ],
                                        );
                                      }),
                                      const SizedBox(height: 100),
                                    ]),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    };
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _normaliseTag(String? value) =>
    (value ?? '').trim().replaceFirst(RegExp(r'^#+'), '').toLowerCase();

List<HashTag> _trendingTagsFromFeed(List<HomeFeedItem> items) {
  final Map<String, HashTag> tags = <String, HashTag>{};
  final Map<String, int> usage = <String, int>{};

  for (final HomeFeedItem item in items) {
    final Set<String> itemTags = <String>{};
    for (final HashTag tag in item.tags ?? <HashTag>[]) {
      final String key = _normaliseTag(tag.name ?? tag.displayName);
      if (key.isEmpty || !itemTags.add(key)) continue;
      tags.putIfAbsent(key, () => tag);
      usage[key] = (usage[key] ?? 0) + 1;
    }
  }

  final List<HashTag> ranked = tags.entries
      .map((MapEntry<String, HashTag> entry) => entry.value.copyWith(
            usageCount: usage[entry.key] ?? entry.value.usageCount,
          ))
      .toList()
    ..sort((HashTag a, HashTag b) =>
        (b.usageCount ?? 0).compareTo(a.usageCount ?? 0));
  return ranked;
}

List<HomeFeedItem> _itemsForTag(
  List<HomeFeedItem> items,
  HashTag hashtag,
) {
  final String target = _normaliseTag(hashtag.name ?? hashtag.displayName);
  if (target.isEmpty) return <HomeFeedItem>[];
  return items
      .where((HomeFeedItem item) =>
          item.tags?.any(
            (HashTag tag) =>
                _normaliseTag(tag.name ?? tag.displayName) == target,
          ) ??
          false)
      .toList();
}

String _hashtagActivityText(HashTag hashtag, List<HomeFeedItem> items) {
  final List<String> liveCreators = items
      .where((HomeFeedItem item) => item.status?.toLowerCase() == 'live')
      .map((HomeFeedItem item) => item.hostName?.trim() ?? '')
      .where((String name) => name.isNotEmpty)
      .toSet()
      .toList();

  if (liveCreators.length >= 3) {
    return '${liveCreators[0]}, ${liveCreators[1]}, and ${liveCreators.length - 2} others are live';
  }
  if (liveCreators.length == 2) {
    return '${liveCreators[0]} and ${liveCreators[1]} are live';
  }
  if (liveCreators.length == 1) return '${liveCreators.first} is live';

  final int usageCount = hashtag.usageCount ?? items.length;
  return '$usageCount ${usageCount == 1 ? 'post' : 'posts'}';
}

class _TaggedContentRow extends StatelessWidget {
  const _TaggedContentRow({required this.items});

  final List<HomeFeedItem> items;

  @override
  Widget build(BuildContext context) {
    final double textScaleAllowance =
        (MediaQuery.textScalerOf(context).scale(14) - 14).clamp(0, 14) * 2;
    final double compactCardHeight = 195 + textScaleAllowance;
    return SizedBox(
      height: compactCardHeight,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 12),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final HomeFeedItem item = items[index];
          return RenderTrendingHashTag(
            trendingPicture: item.thumbnailUrl ??
                item.coverUrl ??
                item.showCoverUrl ??
                ATImgStrings.createShowPlaceholder,
            title: item.title ?? item.showTitle,
            creatorName: item.hostName ?? 'Creator',
            creatorAvatar:
                item.hostProfileImageUrl ?? ATImgStrings.noAvatarImage,
            statusLabel:
                item.status?.toLowerCase() == 'live' ? 'LIVE' : 'Scheduled',
            isPaid:
                item.showType?.toLowerCase() == 'paid' || (item.price ?? 0) > 0,
            squareArtwork: true,
            trailingSpacing: index == items.length - 1 ? 0 : 16,
            onTap: () => _openTaggedItem(context, item),
          );
        },
      ),
    );
  }
}

void _openTaggedItem(BuildContext context, HomeFeedItem item) {
  FocusManager.instance.primaryFocus?.unfocus();
  final bool isLive = item.status?.toLowerCase() == 'live';
  final String route = isLive
      ? item.contentType == 'standalone'
          ? ATRoutes.liveEventDetailed
          : ATRoutes.liveShowDetailed
      : ATRoutes.scheduleDetailed;
  context.pushNamed(route, extra: item);
}

/// Shared compact placeholder used only by the inline Discover section.
/// The View All screen uses the standard activity spinner instead.
class RenderTrendingHashtagRowShimmer extends StatelessWidget {
  const RenderTrendingHashtagRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: <Widget>[
                  ATShimmer(width: 120, height: 16, radius: 4),
                  ATShimmer(width: 200, height: 10, radius: 3),
                ],
              ),
              ATShimmer(width: 20, height: 20, radius: 4),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            padding: const EdgeInsets.only(left: 12),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => const Padding(
              padding: EdgeInsets.only(right: 15),
              child: ATShimmer(width: 140, height: 180, radius: 12),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
