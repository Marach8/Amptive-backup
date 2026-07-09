import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/features/home/cubits/going_cubit.dart';
import 'package:amptive/src/features/home/data/models/response/going_status.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';
import '../../../../shared/sliver_header_delegate.dart';
import 'package:amptive/src/shared/blurred_header.dart';
import '../widgets/people_listening.dart';

import 'package:amptive/src/features/home/presentation/widgets/detailed_screen_header.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_detail_hashtags.dart';
import 'package:amptive/src/shared/animated_expandable_text.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/shared/mesh_gradient_background.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/shared/btn_with_bg_blur_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_actions_modal.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:go_router/go_router.dart';

class ATScheduleDetailedScreen extends StatelessWidget {
  const ATScheduleDetailedScreen({
    super.key,
    this.homeFeedItem,
    this.hostLoading = false,
    this.onEditProgram,
    this.onOwnerMoreTapped,
  });

  final HomeFeedItem? homeFeedItem;

  /// While the full record is still being fetched (and the host isn't known
  /// yet), the Hosted-by row shows a shimmer instead of a fake placeholder.
  final bool hostLoading;

  /// Set when the viewer owns this program: the bottom CTA becomes
  /// "Edit episode/event" instead of "Add to Calendar".
  final VoidCallback? onEditProgram;

  /// Set when the viewer owns this program: the "..." button opens the
  /// owner actions sheet instead of the generic one.
  final Future<void> Function()? onOwnerMoreTapped;

  bool get _canMarkAsGoing {
    final String? contentType = homeFeedItem?.contentType?.toLowerCase();
    return contentType == 'standalone' || contentType == 'episode';
  }

  GoingStatus _getInitialGoingStatus() {
    return GoingStatus(
      isGoing: homeFeedItem?.requesterIsGoing ?? false,
      goingCount: homeFeedItem?.goingCount ?? 0,
    );
  }

  String? get _displayImage {
    final String? contentType = homeFeedItem?.contentType?.toLowerCase();
    if (contentType == 'standalone') {
      return homeFeedItem?.thumbnailUrl;
    } else if (contentType == 'episode') {
      return homeFeedItem?.thumbnailUrl ?? homeFeedItem?.showCoverUrl;
    } else {
      return homeFeedItem?.coverUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight =
        kToolbarHeight + MediaQuery.paddingOf(context).top;
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<BlurredHeaderCubit>(
            create: (_) => BlurredHeaderCubit(),
          ),
          BlocProvider<GoingCubit>(
            create: (_) => GoingCubit(initialStatus: _getInitialGoingStatus()),
          ),
          BlocProvider<DominantColorCubit>(
            create: (_) => DominantColorCubit()
              ..extractColor(
                  _displayImage ?? ATImgStrings.weCanDoHardThingsBgImage),
          ),
          BlocProvider<LocalUserDataCubit>(
            create: (_) => LocalUserDataCubit()..initializeCachedData(),
          ),
        ],
        child: BlocBuilder<LocalUserDataCubit, ATAppState<CachedUserData>>(
          builder: (BuildContext context, ATAppState<CachedUserData> _) {
            // Owner detection lives here so every entry point (feed, discover,
            // search, scheduled page…) shows Edit for the host, not just the
            // wrapper. Explicit callbacks (from the wrapper) win when provided.
            final bool isEpisode =
                homeFeedItem?.contentType?.toLowerCase() == 'episode';
            final String? uid =
                context.read<LocalUserDataCubit>().currentUserData?.userId;
            final bool isOwner =
                uid != null && uid.isNotEmpty && uid == homeFeedItem?.hostId;
            void editEpisode() => context.pushNamed(
                  ATRoutes.editEpisodeScreen,
                  extra: _episodeFromFeedItem(homeFeedItem!),
                );
            void openParentShow() {
              if (!isEpisode) return;
              final HostedShow? parentShow = _parentShowFromEpisodeFeedItem();
              if (parentShow == null) return;
              context.pushNamed(
                ATRoutes.showPreviewScreen,
                extra: parentShow,
              );
            }
            final VoidCallback? effectiveEdit =
                onEditProgram ?? (isOwner && isEpisode ? editEpisode : null);
            final Future<void> Function()? effectiveMore = onOwnerMoreTapped ??
                (isOwner && isEpisode
                    ? () => showOwnerEpisodeOptions(
                          context: context,
                          onEditEpisode: editEpisode,
                        )
                    : null);
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: BlocBuilder<DominantColorCubit, DominantColorState>(
                builder: (
                  BuildContext context,
                  DominantColorState state,
                ) {
                  return ATMeshGradientBackground(
                    state: state,
                    child: Builder(builder: (BuildContext blocContext) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: blocContext
                            .read<BlurredHeaderCubit>()
                            .onScrollNotification,
                        child: NestedScrollView(
                          headerSliverBuilder: (_, __) => <Widget>[
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: ATSliverHDelegate(
                                  maxExt: blurredHeaderHeight,
                                  minExt: blurredHeaderHeight,
                                  child: const ATBlurredHeaderWidget()),
                            )
                          ],
                          body: SingleChildScrollView(
                            // Clamping (not bouncing) so dragging down dismisses
                            // the modal cleanly instead of stretching the content
                            // away from the header — same as the show modal.
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 160),
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                DetailedScreenHeader(
                                  homeFeedItem: homeFeedItem,
                                  displayImage: _displayImage,
                                  onMoreTapped: effectiveMore,
                                  onShowNameTapped:
                                      isEpisode ? openParentShow : null,
                                ),
                                ProgramDetailHashtags(
                                  homeFeedItem: homeFeedItem,
                                ),
                                Text(
                                  ATStrings.hostedBy,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize: ATSizes.size17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Divider(
                                  color: ATColors.white.withValues(alpha: 0.1),
                                ),
                                if (hostLoading &&
                                    (homeFeedItem?.hostName ?? '').isEmpty)
                                  const _HostShimmerRow()
                                else
                                  TileWithLeadingImage(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 9),
                                    title: homeFeedItem?.hostName ?? '',
                                    subtitle: 'Host',
                                    diameter: 42,
                                    leadingImagePath:
                                        homeFeedItem?.hostProfileImageUrl ??
                                            ATImgStrings.jpeg1,
                                  ),
                                const SizedBox(height: 30),
                                if ((homeFeedItem?.avatarUrls?.isNotEmpty ??
                                        false) ||
                                    (homeFeedItem?.goingCount ?? 0) > 0) ...<Widget>[
                                  Text(
                                    '${homeFeedItem?.goingCount ?? 0} Going',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: ATSizes.size17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Divider(
                                    color:
                                        ATColors.white.withValues(alpha: 0.1),
                                  ),
                                  const SizedBox(height: 10),
                                  NoOfListenersWidget(
                                    avatarUrls:
                                        homeFeedItem?.avatarUrls ?? <String>[],
                                    totalCount: homeFeedItem?.goingCount ?? 0,
                                  ),
                                  const SizedBox(height: 35),
                                ],
                                Text(
                                  homeFeedItem?.contentType?.toLowerCase() ==
                                          'episode'
                                      ? 'About Episode'
                                      : 'About Event',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize: ATSizes.size17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Divider(
                                  color: ATColors.white.withValues(alpha: 0.1),
                                ),
                                AnimatedExpandableText(
                                  text: (homeFeedItem?.description ??
                                          'No description provided.')
                                      .stripHtmlAndPreserveNewlines,
                                  trimLines: 3,
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              bottomSheet: effectiveEdit != null
                  ? ATBlurredBgBtn(
                      showBackgroundGradient: true,
                      bgColor: ATColors.white,
                      fgColor: ATColors.hex0D0D0D,
                      onPressed: effectiveEdit,
                      child: Text(
                        homeFeedItem?.contentType?.toLowerCase() == 'standalone'
                            ? 'Edit event'
                            : 'Edit episode',
                        style: TextStyle(
                          color: ATColors.hex0D0D0D,
                          fontSize: ATSizes.size16,
                          fontWeight: ATFontWeights.w600,
                        ),
                      ),
                    )
                  : _canMarkAsGoing
                      ? BlocBuilder<GoingCubit, ATAppState<GoingStatus>>(
                          builder: (
                            BuildContext context,
                            ATAppState<GoingStatus> state,
                          ) {
                            final GoingCubit goingCubit =
                                context.read<GoingCubit>();
                            final bool isGoing =
                                goingCubit.currentGoingStatus?.isGoing ?? false;
                            final int goingCount =
                                goingCubit.currentGoingStatus?.goingCount ?? 0;

                            return ATBlurredBgBtn(
                              showBackgroundGradient: true,
                              bgColor: ATColors.white,
                              fgColor: ATColors.hex0D0D0D,
                              onPressed: state is LoadingState<GoingStatus>
                                  ? null
                                  : () {
                                      final String? contentType = homeFeedItem
                                          ?.contentType
                                          ?.toLowerCase();
                                      final GoingType type =
                                          contentType == 'standalone'
                                          ? GoingType.event
                                          : GoingType.episode;
                                      goingCubit.toggleGoing(
                                        contentId: homeFeedItem!.id!,
                                        type: type,
                                      );
                                    },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (isGoing) ...<Widget>[
                                    Icon(
                                      Icons.check,
                                      color: ATColors.hex0D0D0D,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    isGoing ? 'Going' : 'Add to Calendar',
                                    style: TextStyle(
                                      color: ATColors.hex0D0D0D,
                                      fontSize: ATSizes.size16,
                                      fontWeight: ATFontWeights.w600,
                                    ),
                                  ),
                                  if (isGoing && goingCount > 0) ...<Widget>[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ATColors.hex0D0D0D
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '$goingCount',
                                        style: TextStyle(
                                          color: ATColors.hex0D0D0D,
                                          fontSize: ATSizes.size12,
                                          fontWeight: ATFontWeights.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        )
                      : null,
            );
          },
        ),
      ),
    );
  }

  // Builds an [Episode] from the feed item so the edit form has something to
  // prefill when the modal is reached from a raw (non-wrapper) entry point.
  Episode _episodeFromFeedItem(HomeFeedItem item) => Episode(
        episodeId: item.id,
        showId: item.showId,
        title: item.title,
        description: item.description,
        thumbnailUrl: item.thumbnailUrl ?? item.showCoverUrl,
        status: item.status,
        scheduledFor: item.scheduledFor,
        parentShowTitle: item.showTitle,
        episodeNumber: item.episodeNumber,
        showTypeOverride: item.showType,
        priceOverride: item.price,
        tags: item.tags,
        host: item.hostId == null
            ? null
            : Host(
                userId: item.hostId!,
                username: item.hostName,
                profilePicture: item.hostProfileImageUrl,
              ),
        community: item.communityName == null
            ? null
            : Community(name: item.communityName),
      );

  HostedShow? _parentShowFromEpisodeFeedItem() {
    final String? showId = homeFeedItem?.showId;
    if (showId == null || showId.trim().isEmpty) return null;

    return HostedShow(
      showId: showId,
      title: homeFeedItem?.showTitle ?? 'Show',
      description: homeFeedItem?.description,
      coverUrl: homeFeedItem?.showCoverUrl ?? homeFeedItem?.coverUrl,
      category: homeFeedItem?.showCategory,
      showType: homeFeedItem?.showType,
      price: homeFeedItem?.price,
      status: homeFeedItem?.status,
      goingCount: homeFeedItem?.goingCount,
      totalViewers: homeFeedItem?.viewerCount,
      host: homeFeedItem?.hostId == null
          ? null
          : Host(
              userId: homeFeedItem!.hostId!,
              username: homeFeedItem?.hostName,
              profilePicture: homeFeedItem?.hostProfileImageUrl,
            ),
      coHosts: homeFeedItem?.coHosts,
      tags: homeFeedItem?.tags,
      isLive: homeFeedItem?.status?.toLowerCase() == 'live',
      community: homeFeedItem?.communityName == null
          ? null
          : Community(name: homeFeedItem?.communityName),
    );
  }

}

class _HostShimmerRow extends StatelessWidget {
  const _HostShimmerRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: <Widget>[
          ATShimmer(height: 42, width: 42, radius: 21),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ATShimmer(height: 14, width: 120, radius: 6),
              SizedBox(height: 8),
              ATShimmer(height: 11, width: 60, radius: 6),
            ],
          ),
        ],
      ),
    );
  }
}
