import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/episodes/cubits/episode_detail_cubit.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/events/presentation/screens/preview_event_screen.dart';
import 'package:amptive/src/features/home/presentation/widgets/event_or_show_card.dart';
import 'package:amptive/src/features/home/presentation/widgets/render_community_name.dart';
import 'package:amptive/src/features/episodes/presentation/widgets/existing_episodes_indicator.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_actions_modal.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/live_indicators.dart';
import 'package:nested/nested.dart';


class PreviewEpisodeScreen extends StatelessWidget {
  const PreviewEpisodeScreen({super.key, required this.episode});
  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<EpisodeDetailCubit>(
          create: (_) => EpisodeDetailCubit(initialEpisode: episode)),
        BlocProvider<BlurredHeaderCubit>(
          create: (_) => BlurredHeaderCubit()),
        BlocProvider<ToggleFollowingCubit>(
          create: (_) => ToggleFollowingCubit(
            initialStatus: FollowingStatus(
              isFollowing: true,
              followerCount: episode.host?.followersCount ?? 0,
            )
          )
        )
      ],
      child: _SubWidget(episode: episode),
    );
  }
}
class _SubWidget extends StatefulWidget {
  const _SubWidget({required this.episode});

  final Episode episode;

  @override
  State<_SubWidget> createState() => _SubWidgetState();
}

class _SubWidgetState extends State<_SubWidget> {
  @override 
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        if(mounted){
          context.read<EpisodeDetailCubit>().fetchEpisodeDetails();
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight =
          kToolbarHeight + MediaQuery.paddingOf(context).top;
  
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: ATImgLoader(
                    boxFit: BoxFit.fill,
                    imgPath: widget.episode.thumbnailUrl ?? ''),
              ),
            ),
            ATContainer(
              color: ATColors.hex0D0D0D.withValues(alpha: 0.75),
              child: NotificationListener<ScrollNotification>(
                onNotification:
                    context.read<BlurredHeaderCubit>().onScrollNotification,
                child: NestedScrollView(
                  headerSliverBuilder: (_, __) => <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ATSliverHDelegate(
                        maxExt: blurredHeaderHeight,
                        minExt: blurredHeaderHeight,
                        child: const ATBlurredHeaderWidget(paddingFromTop: 50,)
                      ),
                    )
                  ],
  
                  body: BlocConsumer<EpisodeDetailCubit, ATAppState<Episode>>(
                    listener: (_, ATAppState<Episode> state){},
                    builder: (_, ATAppState<Episode> state) {
                      final Episode? episode = context.read<EpisodeDetailCubit>().currentEpisodeDetail;
                      final bool isLive = episode?.livestreamId != null;
                      final int goingCount = episode?.goingCount ?? 0;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CoverPicWithTopRightMoreIcon(
                              imgPath: episode?.thumbnailUrl ?? '',
                              onMoreTapped: () async {
                                final SelectedProgramAction? foo =
                                    await showProgramOptions(
                                  context: context,
                                  toggleFollowingCubit:
                                      context.read<ToggleFollowingCubit>(),
                                  targetUserName:
                                      episode?.host?.username ?? '',
                                  targetUserId: episode?.host?.userId ?? '',
                                );
                              }),
                            const SizedBox(height: 24),
                          
                            ExistingEpisodesIndicator(
                              activeEpisode: episode,
                              onTappOverride: () => context.pop(),
                            ),
                            const SizedBox(height: 12),
                            
                            Text(
                              maxLines: 2,
                              episode?.title ?? '',
                              overflow: TextOverflow.clip,
                              style: context.textTheme.displayMedium?.copyWith(
                                fontSize: ATSizes.size24,
                                fontWeight: ATFontWeights.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              spacing: 20,
                              children: <Widget>[
                                if(isLive) const LiveIndicatorWithAnimatinWifiIcon()
                                  else EpisodeScheduleDateIndicator(
                                    text1: formatScheduleDate(episode?.scheduledFor ?? ''),
                                  ),
                                RenderCommunityName(communityName: episode?.community?.name)
                              ],
                            ),
                            const SizedBox(height: 40),
                            Text(
                              ATStrings.hashtags,
                              style: context.textTheme.bodySmall
                                  ?.copyWith(fontSize: ATSizes.size17),
                            ),
                            Divider(
                              color: ATColors.white.withValues(alpha: 0.1),
                            ),
                            const SizedBox(height: 5),
                            RenderHashTags(hashtags: episode?.tags),
                            const SizedBox(height: 30),
                            Text(
                              ATStrings.hostedBy,
                              style: context.textTheme.bodySmall
                                  ?.copyWith(fontSize: ATSizes.size17),
                            ),
                            Divider(
                              color: ATColors.white.withValues(alpha: 0.1),
                            ),
                            ...(episode?.coHosts ?? <CoHost>[]).map(
                              (CoHost cohost) => TileWithLeadingImage(
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                title: cohost.username ?? '',
                                subtitle: 'Host',
                                diameter: 42,
                                leadingImagePath: cohost.profilePicture ?? ATImgStrings.jpeg1,
                              )
                            ),
                            const SizedBox(height: 30),
                              Text(
                                '$goingCount Going',
                                style: context.textTheme.bodySmall
                                    ?.copyWith(fontSize: ATSizes.size17),
                              ),
                              Divider(
                                color: ATColors.white.withValues(alpha: 0.1),
                              ),
                              const SizedBox(height: 10),
                              if(goingCount == 0) Row(
                                children: <Widget>[
                                  const ATOverlappingCircles(maxNumber: 3),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(
                                      ATStrings.attendeesWillShowHere,
                                      maxLines: 2,
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(fontSize: ATSizes.size13),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                ATStrings.shareEpisodeLinkDescription,
                                maxLines: 2,
                                style: context.textTheme.bodySmall?.copyWith(
                                    color:
                                        ATColors.white.withValues(alpha: 0.6)),
                              ),
                              const SizedBox(height: 35),
                            // Text(
                            //   '656 Listening',
                            //   style: context.textTheme.bodySmall
                            //       ?.copyWith(fontSize: ATSizes.size17),
                            // ),
                            // Divider(
                            //   color: ATColors.white.withValues(alpha: 0.1),
                            // ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // const NoOfListenersWidget(),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            // Text(
                            //   'daniel, jessica, gerald, peter and 652 more',
                            //   style: context.textTheme.bodySmall?.copyWith(
                            //       color: ATColors.white.withValues(alpha: 0.6)),
                            // ),
                            // const SizedBox( height: 35),
                            Text(
                              ATStrings.aboutEpisode,
                              style: context.textTheme.bodySmall
                                  ?.copyWith(fontSize: ATSizes.size17),
                            ),
                            Divider(
                              color: ATColors.white.withValues(alpha: 0.1),
                            ),
                            ReadMoreText(
                              episode?.description ?? '',
                              trimMode: TrimMode.Length,
                              trimExpandedText: ATStrings.showLess,
                              trimCollapsedText: ATStrings.showMore,
                              colorClickableText: ATColors.white,
                              trimLength: 100,
                              style: TextStyle(
                                color: ATColors.white.withValues(alpha: 0.6),
                                fontSize: ATSizes.size14,
                                fontWeight: ATFontWeights.w500,
                              ),
                            ),
                            const SizedBox(height: 150),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomSheet: ATBlurredBgBtn(
          onPressed: () async{
            final Episode? updatedEpisode = context
              .read<EpisodeDetailCubit>().currentEpisodeDetail;
            final Episode? editedEpisode = await context.pushNamed(
              ATRoutes.editEpisodeScreen,
              extra: updatedEpisode ?? widget.episode
            );
            if(context.mounted && editedEpisode != null
              && editedEpisode != updatedEpisode){
              context.read<EpisodeDetailCubit>().updateEpisode(editedEpisode);
              showAppNotification2(
                context: context,
                text: 'Episode detail updated.',
                type: NotificationType.success,
              );
            }
          },
          btnTitle: 'Edit Episode'
        ),
      ),
    );
  }
}
