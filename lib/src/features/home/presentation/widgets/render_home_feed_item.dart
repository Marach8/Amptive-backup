import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/extensions/num_extensions.dart';
import 'package:amptive/src/shared/worm_animated_circles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/shared/global_model_objects.dart' hide Host;
import 'package:amptive/src/shared/global_model_objects.dart' as gm show Host;
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/features/home/presentation/widgets/cohosts_list_modal.dart';
import 'package:amptive/src/shared/live_indicators.dart';
import 'package:amptive/src/shared/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/features/home/presentation/widgets/row_of_paid_show_and_play_button_widget.dart';
import 'package:amptive/src/shared/row_of_people_listening_widget.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_card_shimmer.dart';
import 'package:amptive/src/features/home/presentation/widgets/with_2_others_widget.dart';
import 'package:amptive/src/shared/bouncing_card.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:amptive/src/features/events/data/repository/events_repo_impl.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo_impl.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/dashboard.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:go_router/go_router.dart';
import 'program_actions_modal.dart';

class RenderHomeFeedItem extends StatelessWidget {
  const RenderHomeFeedItem({
    required this.homeFeedItem,
    this.isFirstCard = false,
    super.key,
  });

  final HomeFeedItem homeFeedItem;
  final bool isFirstCard;

  // A scheduled episode that hasn't begun has no start time and no livestream,
  // so it is never live even if the feed mislabels its status as 'live'.
  bool get _hasStarted =>
      (homeFeedItem.startedAt?.trim().isNotEmpty ?? false) ||
      (homeFeedItem.livestreamId?.trim().isNotEmpty ?? false);

  bool get _isLive =>
      homeFeedItem.status?.toLowerCase() == 'live' && _hasStarted;

  Future<void> _navigateToDetail(BuildContext context) async {
    final String contentType = homeFeedItem.contentType ?? '';
    final bool isStandalone = contentType == 'standalone';

    if (_isLive) {
      final LiveProgramData? liveProgramData = isStandalone
          ? await context.pushNamed(ATRoutes.liveEventDetailed,
              extra: homeFeedItem) as LiveProgramData?
          : await context.pushNamed(ATRoutes.liveShowDetailed,
              extra: homeFeedItem) as LiveProgramData?;

      if (liveProgramData == null) return;
      dashboardKey.currentState
          ?.showLiveStreamOverlay(liveProgramData: liveProgramData);
    } else if (contentType == 'episode') {
      // Episodes open the owner-aware modal (fetches full episode; shows
      // Edit for the host) — same screen, regardless of entry point.
      context.pushNamed(
        ATRoutes.episodeScheduleDetail,
        extra: Episode(
          episodeId: homeFeedItem.id,
          showId: homeFeedItem.showId,
          title: homeFeedItem.title,
          description: homeFeedItem.description,
          thumbnailUrl:
              homeFeedItem.thumbnailUrl ?? homeFeedItem.showCoverUrl,
          status: homeFeedItem.status,
          scheduledFor: homeFeedItem.scheduledFor,
          startedAt: homeFeedItem.startedAt,
          livestreamId: homeFeedItem.livestreamId,
          parentShowTitle: homeFeedItem.showTitle,
          episodeNumber: homeFeedItem.episodeNumber,
          showTypeOverride: homeFeedItem.showType,
          priceOverride: homeFeedItem.price,
          viewerCount: homeFeedItem.viewerCount,
          goingCount: homeFeedItem.goingCount,
          tags: homeFeedItem.tags,
          host: homeFeedItem.hostId == null
              ? null
              : gm.Host(
                  userId: homeFeedItem.hostId!,
                  username: homeFeedItem.hostName,
                  profilePicture: homeFeedItem.hostProfileImageUrl,
                ),
          community: homeFeedItem.communityName == null
              ? null
              : Community(name: homeFeedItem.communityName),
        ),
      );
    } else {
      context.pushNamed(ATRoutes.scheduleDetailed, extra: homeFeedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasProfilePic =
        (homeFeedItem.hostProfileImageUrl ?? '').isNotEmpty;
    return Column(
      children: <Widget>[
        TileWithLeadingImage(
          leadingImagePath: hasProfilePic
              ? homeFeedItem.hostProfileImageUrl!
              : ATImgStrings.noAvatarImage,
          trailingOnPressed: () async {
            await showProgramOptions(
              context: context,
              toggleFollowingCubit: context.read<ToggleFollowingCubit>(),
              targetUserName: homeFeedItem.hostName ?? '',
              targetUserId: homeFeedItem.hostId ?? '',
              targetUserProfileUrl: homeFeedItem.hostProfileImageUrl,
            );
          },
          title: homeFeedItem.hostName ?? '',
          subtitle: _isLive
              ? 'started an ${homeFeedItem.contentType == 'standalone' ? 'event' : 'episode'}'
              : 'scheduled an ${homeFeedItem.contentType == 'standalone' ? 'event' : 'episode'}',
        ),
        const SizedBox(
          height: 2,
        ),
        VisibilityDetector(
          key: Key('home_feed_item_${homeFeedItem.id}'),
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction > 0.5 && homeFeedItem.id != null) {
              final String type = homeFeedItem.contentType?.toLowerCase() ?? '';

              if (type == 'standalone') {
                if (EventsRepoImpl.getCachedEvent(homeFeedItem.id!) == null) {
                  EventsRepoImpl().fetchEvent(eventId: homeFeedItem.id!);
                }
              } else if (type == 'episode') {
                if (EpisodesRepoImpl.getCachedEpisode(homeFeedItem.id!) ==
                    null) {
                  EpisodesRepoImpl().fetchEpisodeDetail(
                    showId: homeFeedItem.showId ?? '',
                    episodeId: homeFeedItem.id!,
                  );
                }
              } else {
                if (ShowsRepoImpl.getCachedShow(homeFeedItem.id!) == null) {
                  ShowsRepoImpl().fetchShow(showId: homeFeedItem.id!);
                }
              }
            }
          },
          child: BouncingCard(
            onTap: () => _navigateToDetail(context),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: ShapeDecoration(
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 16,
                    cornerSmoothing: 0.6,
                  ),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ATImgLoader(
                      imgPath: homeFeedItem.contentType == 'standalone'
                          ? homeFeedItem.thumbnailUrl ?? ATImgStrings.jpeg2
                          : homeFeedItem.contentType == 'episode'
                              ? homeFeedItem.thumbnailUrl ??
                                  homeFeedItem.showCoverUrl ??
                                  ATImgStrings.jpeg2
                              : homeFeedItem.coverUrl ?? ATImgStrings.jpeg2,
                      boxFit: BoxFit.cover,
                      height: context.screenWidth - 16,
                      width: context.screenWidth,
                    ),
                  ),
                  Container(
                    width: context.screenWidth,
                    padding: const EdgeInsets.fromLTRB(17, 15, 17, 15),
                    decoration: ShapeDecoration(
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 16,
                          cornerSmoothing: 0.6,
                        ),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const <double>[
                            0.0,
                            0.5,
                            0.65,
                            0.75,
                            1.0
                          ],
                          colors: <Color>[
                            ATColors.transparent,
                            ATColors.transparent,
                            ATColors.containerGradientColorB
                                .withValues(alpha: 0.95),
                            ATColors.containerGradientColorB,
                            ATColors.containerGradientColorB,
                          ]),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        With2OthersWidget(
                          coHosts: isFirstCard
                              ? <CoHost>[
                                  const CoHost(
                                      userId: 'c1',
                                      name: 'Abby Wambach',
                                      username: 'abbywambach',
                                      bio: 'Olympian, Activist, Author'),
                                  const CoHost(
                                      userId: 'c2',
                                      name: 'Amanda Doyle',
                                      username: 'amandadoyle',
                                      bio: 'Author of UNTAMED and LOV...'),
                                ]
                              : homeFeedItem.coHosts,
                          onTap: () {
                            showCohostsModal(
                              context: context,
                              coHosts: isFirstCard
                                  ? <CoHost>[
                                      const CoHost(
                                          userId: 'c1',
                                          name: 'Abby Wambach',
                                          username: 'abbywambach',
                                          bio: 'Olympian, Activist, Author'),
                                      const CoHost(
                                          userId: 'c2',
                                          name: 'Amanda Doyle',
                                          username: 'amandadoyle',
                                          bio: 'Author of UNTAMED and LOV...'),
                                    ]
                                  : homeFeedItem.coHosts ?? <CoHost>[],
                            );
                          },
                        ),
                        const SizedBox(height: 200),
                        if (_isLive) const LiveIndicatorWithAnimatingDot(),
                        if (_isLive) const SizedBox(height: 10),
                        Text(
                          homeFeedItem.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.displayMedium?.copyWith(
                            fontSize: ATSizes.size24,
                            fontWeight: ATFontWeights.w700,
                            height: 1.2,
                          ),
                        ),
                        if (!_isLive) const SizedBox(height: 8),
                        if (!_isLive)
                          Builder(builder: (BuildContext context) {
                            String formattedDate = '';
                            if (homeFeedItem.scheduledFor != null) {
                              try {
                                final DateTime dt =
                                    DateTime.parse(homeFeedItem.scheduledFor!)
                                        .toLocal();
                                formattedDate =
                                    DateFormat('E, d MMM • h:mm a').format(dt);
                              } catch (_) {
                                formattedDate = homeFeedItem.scheduledFor!;
                              }
                            } else {
                              formattedDate = 'Sun, 15 Jul • 5:00 PM';
                            }
                            return Text(
                              formattedDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: ATSizes.size14,
                                    fontWeight: ATFontWeights.w600,
                                    color: ATColors.hexFED601,
                                  ),
                            );
                          }),
                        const SizedBox(height: 12),
                        ValueListenableBuilder<int>(
                          valueListenable:
                              PaidShowAndPlayBtnWidget.rsvpRevision,
                          builder: (BuildContext context, int revision,
                              Widget? child) {
                            final String id = homeFeedItem.id ??
                                homeFeedItem.hashCode.toString();
                            final bool wasGoing =
                                homeFeedItem.requesterIsGoing ?? false;
                            final bool isGoing = PaidShowAndPlayBtnWidget
                                    .removedRsvpIds
                                    .contains(id)
                                ? false
                                : PaidShowAndPlayBtnWidget.localRsvpIds
                                        .contains(id) ||
                                    wasGoing;
                            final int originalCount = _isLive
                                ? (homeFeedItem.viewerCount ?? 0)
                                : (homeFeedItem.goingCount ?? 0);
                            final int count = _isLive
                                ? originalCount
                                : (originalCount +
                                        (isGoing ? 1 : 0) -
                                        (wasGoing ? 1 : 0))
                                    .clamp(0, 1 << 31);
                            final List<String> avatarUrls = List<String>.of(
                              homeFeedItem.avatarUrls ?? <String>[],
                            );
                            final String currentUserAvatar = context
                                    .read<LocalUserDataCubit>()
                                    .currentUserData
                                    ?.pictureUrl ??
                                '';
                            if (!_isLive && currentUserAvatar.isNotEmpty) {
                              avatarUrls.removeWhere(
                                (String url) => url == currentUserAvatar,
                              );
                              if (isGoing) {
                                avatarUrls.add(currentUserAvatar);
                              }
                            }
                            if (count == 0) {
                              return Row(
                                children: <Widget>[
                                  WormAnimatedCircles(
                                    userAvatarUrl: context
                                            .read<LocalUserDataCubit>()
                                            .currentUserData
                                            ?.pictureUrl ??
                                        '',
                                  ),
                                  const SizedBox(width: 8),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade400,
                                    highlightColor: Colors.white,
                                    loop: 1,
                                    child: Builder(
                                        builder: (BuildContext context) {
                                      final List<String> liveSentences =
                                          <String>[
                                        'Be the First to Join!',
                                        'Grab your spot now!',
                                        'Tap to jump in!',
                                        "Don't miss out, join in!"
                                      ];
                                      final List<String> scheduledSentences =
                                          <String>[
                                        'Be the First to RSVP!',
                                        'Secure your spot now!',
                                        'Set your reminder!',
                                        'RSVP before it starts!'
                                      ];

                                      final int sentenceIndex =
                                          homeFeedItem.hashCode.abs() % 4;
                                      final String currentText = _isLive
                                          ? liveSentences[sentenceIndex]
                                          : scheduledSentences[sentenceIndex];

                                      return Text(
                                        currentText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontSize: ATSizes.size14,
                                              fontWeight: ATFontWeights.w500,
                                            ),
                                      );
                                    }),
                                  ),
                                ],
                              );
                            }
                            return Row(
                              children: <Widget>[
                                PeopleListeningWidget(
                                  viewerProfileUrls: avatarUrls,
                                  totalViewerCount: count,
                                  animateAvatarChanges: !_isLive,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isLive
                                      ? '${count.compactFormat} listening'
                                      : '${count.compactFormat} going',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize: ATSizes.size13,
                                      ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        PaidShowAndPlayBtnWidget(homeFeedItem: homeFeedItem),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RenderHomeFeedItemShimmer extends StatelessWidget {
  const RenderHomeFeedItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProgramCardShimmer();
  }
}
