import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/events/cubits/event_detail_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/end_live_program_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/get_live_program_entry_token_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/start_live_program_cubit.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/presentation/widgets/event_or_show_card.dart';
import 'package:amptive/src/features/home/presentation/widgets/render_community_name.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_actions_modal.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/live_indicators.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nested/nested.dart';
import 'package:readmore/readmore.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';
import '../../../../shared/sliver_header_delegate.dart';

class PreviewEventScreen extends StatelessWidget {
  const PreviewEventScreen({
    super.key,
    required this.hostedEvent,
  });
  final HostedEvent hostedEvent;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<EventDetailCubit>(
          create: (_) => EventDetailCubit(
            initialEvent: hostedEvent,
          ),
        ),
        BlocProvider<BlurredHeaderCubit>(
            create: (_) => BlurredHeaderCubit()),
        BlocProvider<ToggleFollowingCubit>(
            create: (_) => ToggleFollowingCubit(
              initialStatus: FollowingStatus(
              isFollowing: true,
              followerCount: hostedEvent.followerCount ?? 0,
            )
          )
        ),
        BlocProvider<StartLiveProgramCubit>(
          create: (_) => StartLiveProgramCubit()),
      ],
      child: _EventSubWidget(hostedEvent: hostedEvent),
    );
  }
}

class _EventSubWidget extends StatefulWidget {
  const _EventSubWidget({required this.hostedEvent});

  final HostedEvent hostedEvent;

  @override
  State<_EventSubWidget> createState() => _EventSubWidgetState();
}

class _EventSubWidgetState extends State<_EventSubWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EventDetailCubit>().fetchEventDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight =
        kToolbarHeight + MediaQuery.paddingOf(context).top;
    final bool isLive = widget.hostedEvent.isLive ?? false;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) return;

        final HostedEvent? updatedEvent =
            context.read<EventDetailCubit>().currentEventDetail;
        context.pop(updatedEvent);
      },
      child: ATAnnotatedRegion(
        statusBarColor: ATColors.transparent,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: BlocBuilder<EventDetailCubit, ATAppState<HostedEvent>>(
                      builder: (_, __) {
                    final String? coverUrl = context
                        .read<EventDetailCubit>()
                        .currentEventDetail
                        ?.coverUrl;
                    return ATImgLoader(
                        boxFit: BoxFit.fill, imgPath: coverUrl ?? '');
                  }),
                ),
              ),
              ColoredBox(
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
                          child: const ATBlurredHeaderWidget(
                            paddingFromTop: 50,
                          ),
                        ),
                      )
                    ],
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                      child: BlocConsumer<EventDetailCubit,
                              ATAppState<HostedEvent>>(
                          listener: (_, ATAppState<HostedEvent> state) {
                        if (state is FailureState<HostedEvent>) {
                          showAppNotification2(
                            context: context,
                            text: state.message,
                            type: NotificationType.failure,
                          );
                        }
                      }, builder: (_, ATAppState<HostedEvent> state) {
                        final HostedEvent? event =
                            context.read<EventDetailCubit>().currentEventDetail;
                        final int goingCount = event?.goingCount ?? 0;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Hero(
                              tag: event?.eventId ?? '',
                              child: CoverPicWithTopRightMoreIcon(
                                  imgPath: event?.coverUrl ?? '',
                                  onMoreTapped: () async {
                                    final SelectedProgramAction? foo =
                                        await showProgramOptions(
                                      context: context,
                                      toggleFollowingCubit:
                                          context.read<ToggleFollowingCubit>(),
                                      targetUserName:
                                          event?.host?.username ?? '',
                                      targetUserId: event?.host?.userId ?? '',
                                    );
                                  }),
                            ),
                            const SizedBox(height: 24),

                            // Event doesn't have episodes like shows, so no ExistingEpisodesIndicator

                            Text(
                              maxLines: 2,
                              event?.title ?? '',
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
                                EpisodeScheduleDateIndicator(
                                  text1: formatScheduleDate(
                                      event?.scheduledFor ?? ''),
                                ),
                                RenderCommunityName(
                                    communityName: event?.community?.name)
                              ],
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<LocalUserDataCubit,
                                ATAppState<CachedUserData>>(
                              builder:
                                  (_, ATAppState<CachedUserData> userState) {
                                final bool isHost = context
                                        .read<LocalUserDataCubit>()
                                        .currentUserData
                                        ?.userId ==
                                    event?.host?.userId;
                                if (!isHost) return const SizedBox.shrink();
                                return Row(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // context.pushReplacementNamed(
                                        //   ATRoutes.liveProgramScreen,
                                        //   extra: GoLiveProgramParams(
                                        //     streamId: event?.livestreamId ?? '',
                                        //     userType: GoLiveUserType.host,
                                        //     contentId: event?.eventId,
                                        //   ),
                                        // );
                                      },
                                      child: const Text('Go Live'),
                                    ),
                                  ],
                                );
                              },
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
                            RenderHashTags(hashtags: event?.tags),
                            const SizedBox(height: 30),
                            Text(
                              ATStrings.hostedBy,
                              style: context.textTheme.bodySmall
                                  ?.copyWith(fontSize: ATSizes.size17),
                            ),
                            Divider(
                              color: ATColors.white.withValues(alpha: 0.1),
                            ),
                            TileWithLeadingImage(
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              title: event?.host?.username ?? '',
                              subtitle: 'Host',
                              diameter: 42,
                              leadingImagePath: event?.host?.profilePicture ??
                                  ATImgStrings.jpeg1,
                            ),
                            ...(event?.coHosts ?? <CoHost>[])
                                .map((CoHost cohost) => TileWithLeadingImage(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 9),
                                      title: cohost.username ?? '',
                                      subtitle: 'Host',
                                      diameter: 42,
                                      leadingImagePath: cohost.profilePicture ??
                                          ATImgStrings.jpeg1,
                                    )),
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
                            if (goingCount == 0)
                              Row(
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
                                  color: ATColors.white.withValues(alpha: 0.6)),
                            ),
                            const SizedBox(height: 35),

                            Text(
                              'About Event',
                              style: context.textTheme.bodySmall
                                  ?.copyWith(fontSize: ATSizes.size17),
                            ),
                            Divider(
                              color: ATColors.white.withValues(alpha: 0.1),
                            ),
                            ReadMoreText(
                              event?.description ?? '',
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
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),

          bottomSheet: BlocConsumer<StartLiveProgramCubit, 
              ATAppState<LiveProgramEntryToken>>(
              listener: (_, ATAppState<LiveProgramEntryToken> state){
                if(state is SuccessState<LiveProgramEntryToken>){
                  final HostedEvent? updatedEvent =
                      context.read<EventDetailCubit>().currentEventDetail;
                  context.pushReplacementNamed(
                    ATRoutes.goLiveOnboarding,
                    extra: LiveProgramData(
                      roomEntryToken: state.newData?.roomEntryToken ?? '',
                      roomUrl: state.newData?.roomUrl ?? '',
                      streamId: state.newData?.streamId ?? '',
                      roomParticipantId: state.newData?.roomParticipantId ?? '',
                      programId: updatedEvent?.eventId ?? '',
                      coverUrl: updatedEvent?.coverUrl ?? '',
                      role: ParticipantRole.host,
                      community: updatedEvent?.community,
                      programTitle: updatedEvent?.title ?? '',
                      programDesc: updatedEvent?.description ?? '',
                    )
                  );
                }
              },
              builder: (_, state) {
                return ATBlurredBgBtn(
                  onPressed: () async {
                    final HostedEvent? updatedEvent =
                      context.read<EventDetailCubit>().currentEventDetail;
                    context.read<StartLiveProgramCubit>().startLiveProgram(
                      contentId: updatedEvent?.eventId ?? '',
                    );
                  },
                  btnTitle: 'Edit Event'
                );
              }
            ),
          ),

          // bottomSheet: ATBlurredBgBtn(
          //   onPressed: () async {
          //     final HostedEvent? updatedEvent =
          //         context.read<EventDetailCubit>().currentEventDetail;
          //     final HostedEvent? editedEvent = await context.pushNamed(
          //         ATRoutes.editEventScreen,
          //         extra: updatedEvent ?? widget.hostedEvent);
          //     if (context.mounted &&
          //         editedEvent != null &&
          //         editedEvent != updatedEvent) {
          //       context.read<EventDetailCubit>().updateEvent(editedEvent);
          //       showAppNotification2(
          //         context: context,
          //         text: 'Event detail updated.',
          //         type: NotificationType.success,
          //       );
          //     }
          //   },
          //   btnTitle: 'Edit Event'
          // ),
      ),
    );
  }
}

String formatScheduleDate(String isoString) {
  try {
    final DateTime parsed = DateTime.parse(isoString).toLocal();

    final DateFormat formatter = DateFormat("d MMM, y 'at' HH:mm");

    return formatter.format(parsed);
  } catch (e) {
    return isoString; // fallback if parsing fails
  }
}
