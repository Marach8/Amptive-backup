import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/blurred_header.dart';
import '../../../../shared/hashtag_badge.dart';
import '../../../../shared/sliver_header_delegate.dart';
import '../widgets/trending_society_hashtag_widget.dart';

class SocietyHastagScreen extends StatelessWidget {
  const SocietyHastagScreen({
    super.key,
    this.hashtagName,
    this.showHeaderFlame = false,
  });

  final String? hashtagName;
  final bool showHeaderFlame;

  @override
  Widget build(BuildContext context) {
    final String displayName = hashtagName?.trim().isNotEmpty ?? false
        ? hashtagName!.trim()
        : ATStrings.society;

    return BlocProvider<HomeFeedCubit>(
      create: (_) => HomeFeedCubit()..refreshHomeFeed(),
      child: ATAnnotatedRegion(
        statusBarColor: ATColors.transparent,
        child: Scaffold(
          // Same as the dashboard: keeps the safe-area padding inside the
          // bottom menu so its height matches everywhere.
          resizeToAvoidBottomInset: false,
          bottomSheet: const AppBottomMenu(),
          body: BlocProvider<BlurredHeaderCubit>(
            create: (_) => BlurredHeaderCubit(),
            child: Builder(builder: (BuildContext blocContext) {
              return NotificationListener<ScrollNotification>(
                onNotification:
                    blocContext.read<BlurredHeaderCubit>().onScrollNotification,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ATSliverHDelegate(
                          maxExt: kToolbarHeight +
                              MediaQuery.paddingOf(context).top,
                          minExt: kToolbarHeight +
                              MediaQuery.paddingOf(context).top,
                          child: ATBlurredHeaderWidget(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: ATBackBtn(
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 56),
                                  child: Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: ATStrings.HASH +
                                              displayName.toLowerCase(),
                                        ),
                                        if (showHeaderFlame) ...<InlineSpan>[
                                          const WidgetSpan(
                                            child: SizedBox(width: 2),
                                          ),
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.middle,
                                            child: Icon(
                                              Icons
                                                  .local_fire_department_rounded,
                                              size: 18,
                                              color: ATColors.hexFF0078,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.39,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: <Widget>[
                            const ATHashtagBadge(
                              badgeSize: 50,
                              hashSize: 28,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            BlocBuilder<HomeFeedCubit,
                                ATAppState<HomeFeedResponseModel>>(
                              builder: (BuildContext context,
                                  ATAppState<HomeFeedResponseModel> state) {
                                final List<HomeFeedItem> items =
                                    _hashtagItems(context, displayName);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      ATStrings.HASH + displayName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(fontSize: ATSizes.size15),
                                    ),
                                    Text(
                                      _hashtagSubtitle(items),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontSize: ATSizes.size13,
                                              color: ATColors.hexA8A8A8),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 15,
                    )),
                    BlocBuilder<HomeFeedCubit,
                        ATAppState<HomeFeedResponseModel>>(
                      builder: (BuildContext context,
                          ATAppState<HomeFeedResponseModel> state) {
                        final List<HomeFeedItem> items =
                            _hashtagItems(context, displayName);
                        if (items.isEmpty &&
                            state is LoadingState<HomeFeedResponseModel>) {
                          return const SliverToBoxAdapter(
                            child: SizedBox(
                              height: 180,
                              child: Center(
                                child: CupertinoActivityIndicator(
                                  radius: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                        if (items.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(
                                child: Text('No posts use this hashtag yet.'),
                              ),
                            ),
                          );
                        }
                        return SliverPadding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 120),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final HomeFeedItem item = items[index];
                                return TrendingSocietyHashtagWidget(
                                  trendingPicture: item.thumbnailUrl ??
                                      item.coverUrl ??
                                      item.showCoverUrl ??
                                      ATImgStrings.createShowPlaceholder,
                                  title: item.title ?? item.showTitle ?? '',
                                  creatorName: item.hostName ?? 'Creator',
                                  creatorAvatar: item.hostProfileImageUrl ??
                                      ATImgStrings.noAvatarImage,
                                  statusLabel:
                                      item.status?.toLowerCase() == 'live'
                                          ? 'LIVE'
                                          : 'Scheduled',
                                  isPaid:
                                      item.showType?.toLowerCase() == 'paid' ||
                                          (item.price ?? 0) > 0,
                                  onTap: () => _openHashtagItem(context, item),
                                );
                              },
                              childCount: items.length,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 18,
                              childAspectRatio: 0.74,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

List<HomeFeedItem> _hashtagItems(BuildContext context, String hashtagName) {
  final String target = _normaliseHashtag(hashtagName);
  final List<HomeFeedItem> items =
      context.read<HomeFeedCubit>().currentHomeFeedData?.homeFeedItems ??
          <HomeFeedItem>[];
  return items
      .where((HomeFeedItem item) =>
          item.tags?.any(
            (HashTag tag) =>
                _normaliseHashtag(tag.name ?? tag.displayName ?? '') == target,
          ) ??
          false)
      .toList();
}

String _normaliseHashtag(String value) =>
    value.trim().replaceFirst(RegExp(r'^#+'), '').toLowerCase();

void _openHashtagItem(BuildContext context, HomeFeedItem item) {
  FocusManager.instance.primaryFocus?.unfocus();
  final bool isLive = item.status?.toLowerCase() == 'live';
  final String route = isLive
      ? item.contentType == 'standalone'
          ? ATRoutes.liveEventDetailed
          : ATRoutes.liveShowDetailed
      : ATRoutes.scheduleDetailed;
  context.pushNamed(route, extra: item);
}

String _hashtagSubtitle(List<HomeFeedItem> items) {
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
  return 'Explore shows and events using this hashtag';
}
