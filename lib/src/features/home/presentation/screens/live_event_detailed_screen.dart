import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/get_live_program_entry_token_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/start_live_program_cubit.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/presentation/screens/go_live_onboarding_screen.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:readmore/readmore.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';
import '../../../../shared/row_of_people_listening_widget.dart';
import '../widgets/event_or_show_card.dart';
import '../widgets/whispers_list.dart';
import '../../data/models/response/home_feed_response_model.dart';

class ATLiveEventDetailedScreen extends StatelessWidget {
  const ATLiveEventDetailedScreen({
    super.key,
    this.homeFeedItem,
  });

  final HomeFeedItem? homeFeedItem;

  String? get _displayImage {
    final contentType = homeFeedItem?.contentType?.toLowerCase();
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
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<GetLiveProgramEntryTokenCubit>(
          create: (_) => GetLiveProgramEntryTokenCubit(),
        ),
        BlocProvider<BlurredHeaderCubit>(
          create: (_) => BlurredHeaderCubit(),
        )
      ],
      child: ATAnnotatedRegion(
        statusBarColor: ATColors.transparent,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 250, sigmaY: 250),
                  child: ATImgLoader(
                    boxFit: BoxFit.fill,
                    imgPath: _displayImage ?? ATImgStrings.JOE_POMP_SHOW,
                  ),
                ),
              ),
              ColoredBox(
                color: ATColors.hex0D0D0D.withValues(alpha: 0.75),
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
                              child: SizedBox(
                                  height: blurredHeaderHeight,
                                  child: const ATBlurredHeaderWidget())),
                        )
                      ],
                      body: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CoverPicWithTopRightMoreIcon(
                                    imgPath: _displayImage ?? '',
                                    onMoreTapped: () {},
                                    padding: EdgeInsets.zero,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    maxLines: 2,
                                    homeFeedItem?.title ?? '',
                                    overflow: TextOverflow.clip,
                                    style: context.textTheme.displayMedium
                                        ?.copyWith(
                                      fontSize: ATSizes.size24,
                                      fontWeight: ATFontWeights.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const SizedBox(height: 30),
                                  Text(
                                    ATStrings.hashtags,
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(fontSize: ATSizes.size17),
                                  ),
                                  Divider(
                                    color:
                                        ATColors.white.withValues(alpha: 0.1),
                                  ),
                                  const SizedBox(height: 5),
                                  const RenderHashTags(),
                                  const SizedBox(height: 20),
                                  Text(
                                    ATStrings.hostedBy,
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(fontSize: ATSizes.size17),
                                  ),
                                  Divider(
                                    color:
                                        ATColors.white.withValues(alpha: 0.1),
                                  ),
                                  TileWithLeadingImage(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 9),
                                    title: homeFeedItem?.hostName ?? '',
                                    subtitle: 'Host',
                                    diameter: 35,
                                    leadingImagePath:
                                        homeFeedItem?.hostProfileImageUrl ??
                                            ATImgStrings.jpeg1,
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    '${homeFeedItem?.viewerCount ?? 0} Listening',
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(fontSize: ATSizes.size17),
                                  ),
                                  Divider(
                                    color:
                                        ATColors.white.withValues(alpha: 0.1),
                                  ),
                                  const SizedBox(height: 10),
                                  const PeopleListeningWidget(
                                    showNumberInsideContainer: true,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'daniel, jessica, gerald, peter and 652 more',
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                            color: ATColors.white
                                                .withValues(alpha: 0.6)),
                                  ),
                                  const SizedBox(height: 35),
                                  Text(
                                    'About Event',
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(fontSize: ATSizes.size17),
                                  ),
                                  Divider(
                                    color:
                                        ATColors.white.withValues(alpha: 0.1),
                                  ),
                                  ReadMoreText(
                                    'Jessica Yellin, founder of the Webby-Award Winning Independent News Brand, News Not Noise, returns to walk us through what is going on right now in the political landscape.',
                                    trimMode: TrimMode.Length,
                                    trimExpandedText: ATStrings.showLess,
                                    trimCollapsedText: ATStrings.showMore,
                                    colorClickableText: ATColors.white,
                                    trimLength: 100,
                                    style: TextStyle(
                                      color:
                                          ATColors.white.withValues(alpha: 0.6),
                                      fontSize: ATSizes.size14,
                                      fontWeight: ATFontWeights.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    ATStrings.whispers,
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(fontSize: ATSizes.size17),
                                  ),
                                  Divider(
                                    color:
                                        ATColors.white.withValues(alpha: 0.1),
                                  ),
                                ],
                              ),
                            ),
                            const ATWhispersWidget(),
                            const SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    ATStrings.GOT_TICKET_ID,
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(fontSize: ATSizes.size17),
                                  ),
                                  Divider(
                                    color:
                                        ATColors.white.withValues(alpha: 0.1),
                                  ),
                                  const SizedBox(height: 5),
                                  ATTextFormField(
                                      controller: TextEditingController(),
                                      hintText: 'Enter your Ticked ID',
                                      maxLines: 1,
                                      prefixIcon: const SizedBox(
                                        width: 15,
                                      ),
                                      suffixIcon: const Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 15),
                                          child: ATLoadingIndicator(
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: BorderSide(
                                              color: ATColors.transparent))),
                                  const SizedBox(height: 10),
                                  ReadMoreText(
                                    'If you already paid for this event on our website, you should have received a Ticket ID. Kindly enter your Ticket Id in the input field about to access the event...',
                                    trimMode: TrimMode.Length,
                                    trimExpandedText: ATStrings.showLess,
                                    trimCollapsedText:
                                        'Learn more about Ticked ID',
                                    colorClickableText: ATColors.white,
                                    trimLength: 100,
                                    style: TextStyle(
                                      color:
                                          ATColors.white.withValues(alpha: 0.6),
                                      fontSize: ATSizes.size14,
                                      fontWeight: ATFontWeights.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          resizeToAvoidBottomInset: false,
          bottomSheet: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
            child: BlocConsumer<GetLiveProgramEntryTokenCubit, ATAppState<LiveProgramEntryToken>>(
              listener: (_, ATAppState<LiveProgramEntryToken> state)async{
                if(state is SuccessState<LiveProgramEntryToken>){
                  final UserProfileData? userData = context
                    .read<LocalUserDataCubit>().currentUserData;
                  final String? userId = userData?.userId;
                  final bool hasTestedMic = userData?.hasTestedMic == 'true';
                  final bool isHost = userId == homeFeedItem?.hostId;

                  final LiveProgramData liveProgramData = LiveProgramData(
                    roomEntryToken: state.newData?.roomEntryToken ?? '',
                    roomUrl: state.newData?.roomUrl ?? '',
                    streamId: state.newData?.streamId ?? '',
                    roomParticipantId: state.newData?.roomParticipantId ?? '',
                    programId: homeFeedItem?.id ?? '',
                    coverUrl: _displayImage ?? '',
                    role: isHost
                      ? ParticipantRole.host
                      : ParticipantRole.audience,
                    community: Community(name: 'Test Community'),
                    programTitle: homeFeedItem?.title ?? '',
                    programDesc: 'New program'
                  );
                  
                  if(!isHost || hasTestedMic){
                    context.pop(liveProgramData);
                  }
                  else{
                    await context.pushNamed(
                      ATRoutes.goLiveOnboarding,
                      extra: liveProgramData,
                    );
                    
                    if(context.mounted){
                      context.pop(liveProgramData);
                    }
                  }
                }
                else if(state is FailureState<LiveProgramEntryToken>){
                  showAppNotification2(
                    context: context,
                    text: state.message,
                    type: NotificationType.failure,
                  );
                }
              },
              builder: (BuildContext ctx, ATAppState<LiveProgramEntryToken> state) {
                return ATPlainElevatedBtn(
                  onPressed: (){
                    ctx.read<GetLiveProgramEntryTokenCubit>()
                    .getLiveProgramEntryToken(
                      homeFeedItem?.livestreamId ?? '',
                    );
                  },
                  isLoading: state is LoadingState<LiveProgramEntryToken>,
                  bgColor: ATColors.white,
                  fgColor: ATColors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        ATStrings.pay,
                        style: TextStyle(
                          fontSize: ATSizes.size16,
                          fontWeight: ATFontWeights.w600,
                          color: ATColors.hex0D0D0D,
                        ),
                      ),
                      const SizedBox(width: 5),
                      CircleAvatar(
                        radius: 2.5,
                        backgroundColor: ATColors.hex0D0D0D,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        homeFeedItem?.price != null
                            ? '₦${homeFeedItem!.price!.toStringAsFixed(0)}'
                            : '₦5,000',
                        style: TextStyle(
                          fontSize: ATSizes.size16,
                          fontWeight: ATFontWeights.w600,
                          color: ATColors.hex0D0D0D,
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
          ),
          // bottomSheet: ATContainer(
          //   height: 90,
          //   gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: <Color>[
          //         ATColors.hex0D0D0D.withValues(alpha: 0.1),
          //         ATColors.hex0D0D0D
          //       ]),
          //   padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
          //   child: GestureDetector(
          //     onTap: () {
          //       // context.pushNamed(
          //       //   ATRoutes.liveProgramScreen,
          //       //   extra: GoLiveProgramParams(
          //       //     streamId: homeFeedItem?.livestreamId ?? '',
          //       //     userType: GoLiveUserType.audience,
          //       //   ),
          //       // );
          //     },
          //     child: Container(
          //       width: double.infinity,
          //       padding: const EdgeInsets.symmetric(vertical: 16),
          //       decoration: BoxDecoration(
          //         color: ATColors.white,
          //         borderRadius: BorderRadius.circular(12),
          //       ),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Text(
                //       ATStrings.PAY,
                //       style: TextStyle(
                //         fontSize: ATSizes.size16,
                //         fontWeight: ATFontWeights.w600,
                //         color: ATColors.hex0D0D0D,
                //       ),
                //     ),
                //     const SizedBox(width: 5),
                //     ATCircleAvatar(
                //       diameter: 5,
                //       color: ATColors.hex0D0D0D,
                //     ),
                //     const SizedBox(width: 5),
                //     Text(
                //       homeFeedItem?.price != null
                //           ? '₦${homeFeedItem!.price!.toStringAsFixed(0)}'
                //           : '₦5,000',
                //       style: TextStyle(
                //         fontSize: ATSizes.size16,
                //         fontWeight: ATFontWeights.w600,
                //         color: ATColors.hex0D0D0D,
                //       ),
                //     ),
                //   ],
                // ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
