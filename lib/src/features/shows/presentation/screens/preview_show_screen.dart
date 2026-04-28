import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/calender/calender_export.dart';
import 'package:amptive/src/features/episodes/cubits/episodes_of_a_show_cubit.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/presentation/widgets/event_or_show_card.dart';
import 'package:amptive/src/features/home/presentation/widgets/render_community_name.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_actions_modal.dart';
import 'package:amptive/src/features/episodes/presentation/widgets/existing_episodes_indicator.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/live_indicators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:readmore/readmore.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';
import '../../../../shared/sliver_header_delegate.dart';

class PreviewShowScreen extends StatelessWidget {
  const PreviewShowScreen({
    super.key, 
    required this.hostedShow,
  });
  final HostedShow hostedShow;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<ShowDetailCubit>(
          create: (_) => ShowDetailCubit(initialShow: hostedShow)),
        BlocProvider<BlurredHeaderCubit>(
          create: (_) => BlurredHeaderCubit()),
        BlocProvider<EpisodesOfAShowCubit>(
          create: (_) => EpisodesOfAShowCubit(
            showId: hostedShow.showId ?? '',
          ),
        ),
        BlocProvider<ToggleFollowingCubit>(
          create: (_) => ToggleFollowingCubit(
            initialStatus: FollowingStatus(
              isFollowing: true,
              followerCount: hostedShow.followerCount ?? 0,
            )
          )
        )
      ],
      child: _SubWidget(hostedShow: hostedShow),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget({required this.hostedShow});

  final HostedShow hostedShow;

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
          context.read<ShowDetailCubit>().fetchShowDetails();
          context.read<EpisodesOfAShowCubit>().fetchEpisodesOfAShow();
        }
      }
    );
  }

  @override
  Widget build(_) {
    return Builder(
      builder: (BuildContext context) {
      final double blurredHeaderHeight =
          kToolbarHeight + MediaQuery.paddingOf(context).top;
      final bool hasEpisodes = (widget.hostedShow.episodeCount ?? 0) > 0;
      final bool isLive = widget.hostedShow.isLive ?? false;
    
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
                      imgPath: widget.hostedShow.coverUrl ?? ''),
                ),
              ),
              Container(
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

                    body: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                      child: BlocConsumer<ShowDetailCubit, ATAppState<HostedShow>>(
                        listener: (_, ATAppState<HostedShow> state){
                          if(state is FailureState<HostedShow>){
                            showAppNotification2(
                              context: context,
                              text: state.message,
                              type: NotificationType.failure
                            );
                          }
                        },
                        builder: (_, __) {
                          final HostedShow? updatedShow = context.read<ShowDetailCubit>().currentShowDetail;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Hero(
                                tag: updatedShow?.showId ?? '',
                                child: CoverPicWithTopRightMoreIcon(
                                    imgPath: updatedShow?.coverUrl ?? '',
                                    onMoreTapped: () async {
                                      final SelectedProgramAction? foo =
                                          await showProgramOptions(
                                        context: context,
                                        toggleFollowingCubit:
                                            context.read<ToggleFollowingCubit>(),
                                        targetUserName:
                                            updatedShow?.host?.username ?? '',
                                        targetUserId: updatedShow?.host?.userId ?? '',
                                      );
                                    }),
                              ),
                              const SizedBox(height: 24),
                            
                              if(hasEpisodes) ...<Widget>[
                                ExistingEpisodesIndicator(
                                  activeEpisode: updatedShow?.episodes?.first.copyWith(
                                    showId: updatedShow.showId,
                                    parentShowTitle: updatedShow.title
                                  )
                                ),
                                const SizedBox(height: 12),
                              ],
                              
                              Text(
                                maxLines: 2,
                                updatedShow?.title ?? '',
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
                                  if(isLive) const LiveIndicatorWithAnimatinWifiIcon(),
                                  RenderCommunityName(communityName: updatedShow?.community?.name)
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
                              RenderHashTags(hashtags: updatedShow?.tags),
                              const SizedBox(height: 30),
                              Text(
                                ATStrings.hostedBy,
                                style: context.textTheme.bodySmall
                                    ?.copyWith(fontSize: ATSizes.size17),
                              ),
                              Divider(
                                color: ATColors.white.withValues(alpha: 0.1),
                              ),
                              ...(updatedShow?.coHosts ?? <CoHost>[]).map(
                                (CoHost cohost) => TileWithLeadingImage(
                                  padding: const EdgeInsets.symmetric(vertical: 9),
                                  title: cohost.username ?? '',
                                  subtitle: 'Host',
                                  diameter: 42,
                                  leadingImagePath: cohost.profilePicture ?? ATImgStrings.jpeg1,
                                )
                              ),
                              const SizedBox(height: 30),
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
                                'About Show',
                                style: context.textTheme.bodySmall
                                    ?.copyWith(fontSize: ATSizes.size17),
                              ),
                              Divider(
                                color: ATColors.white.withValues(alpha: 0.1),
                              ),
                              ReadMoreText(
                                updatedShow?.description ?? '',
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
                              // Text(
                              //   ATStrings.whispers,
                              //   style: context.textTheme.bodySmall
                              //       ?.copyWith(fontSize: ATSizes.size17),
                              // ),
                              // Divider(
                              //   color: ATColors.white.withValues(alpha: 0.1),
                              // ),
                            ],
                          );
                        }
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          bottomSheet: ATBlurredBgBtn(
            onPressed: () {
              context.pushNamed(
                ATRoutes.createEpisodeForm,
                extra: widget.hostedShow.showId ?? ''
              );
            },
            btnTitle: hasEpisodes ? 'Add Episode' : 'Create Episode',
          ),
        ),
      );
    });
  }
}
