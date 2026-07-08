import 'package:amptive/src/features/home/cubits/live_listeners_cubit.dart';
import 'package:amptive/src/features/home/cubits/validate_ticket_cubit.dart';
import 'package:amptive/src/features/home/cubits/whispers_cubit.dart';
import 'package:amptive/src/config/utils/dialogs/dialog_export.dart';
import 'package:amptive/src/features/home/presentation/widgets/render_community_name.dart';
import 'package:amptive/src/features/home/presentation/widgets/render_live_listeners.dart';
import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/get_live_program_entry_token_cubit.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/wallet/presentation/widgets/one_time_process_payment_dialog.dart';
import 'package:amptive/src/features/wallet/presentation/widgets/select_one_time_payment_method.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/live_indicators.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';
import '../../../../shared/row_of_people_listening_widget.dart';
import '../widgets/whispers_list.dart';
import '../../data/models/response/home_feed_response_model.dart';


class LiveEventDetailedScreen extends StatefulWidget {
  const LiveEventDetailedScreen({
    super.key,
    this.homeFeedItem,
  });

  final HomeFeedItem? homeFeedItem;

  @override
  State<LiveEventDetailedScreen> createState() => _LiveEventDetailedScreenState();
}

class _LiveEventDetailedScreenState extends State<LiveEventDetailedScreen> {
  final ValueNotifier<bool> _canJoinNotifier = ValueNotifier<bool>(false);
  late bool _allowWhispers;

  @override 
  void initState(){
    super.initState();
    _canJoinNotifier.value = 
      widget.homeFeedItem?.programType == ProgramType.free;
    _allowWhispers = widget.homeFeedItem?.allowWhispers ?? false;

    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        if(!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback(
          (_){
            if(!mounted) return;
            if(_allowWhispers){
              context.read<LiveWhispersCubit>().fetchWhispers(
                livestreamId: widget.homeFeedItem?.livestreamId ?? '');
            }

            context.read<LiveListenersCubit>().fetchLiveListeners(
              liveStreamId: widget.homeFeedItem?.livestreamId ?? '');
          }
        );
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight =
        kToolbarHeight + MediaQuery.paddingOf(context).top;
    
    final bool isPaidEvent = widget.homeFeedItem?.programType
      == ProgramType.paid;
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
                  imgPath: widget.homeFeedItem?.coverUrl 
                    ?? widget.homeFeedItem?.thumbnailUrl ?? '',
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
                            child: const BlurredHeaderWidget2()),
                      )
                    ],
                    body: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.viewInsetsOf(context).bottom,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Hero(
                                      tag: widget.homeFeedItem?.coverUrl
                                        ?? widget.homeFeedItem?.thumbnailUrl ?? '',
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(16),
                                        child: ATImgLoader(
                                          imgPath: widget.homeFeedItem?.coverUrl
                                            ?? widget.homeFeedItem?.thumbnailUrl ?? '',
                                          boxFit: BoxFit.cover,
                                          height: 360,
                                          width: context.screenWidth,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: ATContainer(
                                        height: 32,
                                        width: 32,
                                        onTap: () {},
                                        boxShape: BoxShape.circle,
                                        color: ATColors.hex0D0D0D
                                            .withValues(alpha: 0.7),
                                        child: const Icon(Icons.more_horiz),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  maxLines: 2,
                                  widget.homeFeedItem?.title ?? '',
                                  overflow: TextOverflow.clip,
                                  style:
                                      context.textTheme.displayMedium?.copyWith(
                                    fontSize: ATSizes.size24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  spacing: 20,
                                  children: <Widget>[
                                    const LiveIndicatorWithAnimatinWifiIcon(),
                                    Flexible(child: RenderCommunityName(
                                      communityName: widget.homeFeedItem?.community?.name
                                    ))
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  ATStrings.hashtags,
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(fontSize: 17),
                                ),
                                Divider(
                                  color: ATColors.white.withValues(alpha: 0.1),
                                ),
                                const SizedBox(height: 5),
                                RenderHashTags(
                                  hashtags: widget.homeFeedItem?.hashTagNames?.map(
                                    (String item) => HashTag(name: item)
                                  ).toList(),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  ATStrings.hostedBy,
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(fontSize: ATSizes.size17),
                                ),
                                Divider(
                                  color: ATColors.white.withValues(alpha: 0.1),
                                ),
                                TileWithLeadingImage(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 9),
                                  title: widget.homeFeedItem?.hostName ?? '',
                                  subtitle: 'Host',
                                  diameter: 35,
                                  leadingImagePath:
                                      (widget.homeFeedItem?.hostProfileImageUrl ?? '').isNotEmpty ? 
                                      widget.homeFeedItem!.hostProfileImageUrl! :
                                        ATImgStrings.noAvatarImage,
                                ),
                                ...(widget.homeFeedItem?.cohosts ?? <User>[]).map(
                                  (User cohost) => TileWithLeadingImage(
                                    padding: const EdgeInsets.symmetric(vertical: 9),
                                    title: cohost.username ?? '',
                                    subtitle: 'Cohost',
                                    diameter: 42,
                                    leadingImagePath: cohost.profilePicture
                                      ?? ATImgStrings.noAvatarImage,
                                  )
                                ),
                                const SizedBox(height: 30),

                                const RenderLiveListeners(),
                                const SizedBox(height: 35),
                                
                                Text(
                                  'About Event',
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(fontSize: 17),
                                ),
                                Divider(
                                  color: ATColors.white.withValues(alpha: 0.1),
                                ),
                                ReadMoreText(
                                  widget.homeFeedItem?.title ?? '',
                                  trimMode: TrimMode.Length,
                                  trimExpandedText: ATStrings.showLess,
                                  trimCollapsedText: ATStrings.showMore,
                                  colorClickableText: ATColors.white,
                                  trimLength: 100,
                                  style: TextStyle(
                                    color:
                                        ATColors.white.withValues(alpha: 0.6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if(_allowWhispers) const WhispersWidget(),
                          
                          const SizedBox(height: 30),
                          if(isPaidEvent)Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  ATStrings.gotATicketID,
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(fontSize: 17),
                                ),
                                Divider(
                                  color: ATColors.white.withValues(alpha: 0.1),
                                ),
                                const SizedBox(height: 5),
                                BlocConsumer<ValidateTicketCubit, ATAppState<dynamic>>(
                                  listener: (_, ATAppState<dynamic> state){
                                    if(state is SuccessState<dynamic>){
                                      _canJoinNotifier.value = true;
                                    }
                                    else if (state is FailureState<dynamic>){
                                      showAppNotification2(
                                        context: context,
                                        text: state.message,
                                        type: NotificationType.failure,
                                      );
                                    }
                                  },
                                  builder: (_, ATAppState<dynamic> state) {
                                    final bool isLoading = state is LoadingState<dynamic>;
                                    return ATTextFormField(
                                        hintText: 'Enter your Ticked ID',
                                        maxLines: 1,
                                        enabled: !isLoading,
                                        prefixIcon: const SizedBox( width: 15),
                                        suffixIcon: isLoading ? const Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 15),
                                            child: ATLoadingIndicator(size: 18),
                                          ),
                                        ) : const SizedBox.shrink(),
                                        onFieldSubmitted: (String text){
                                          context.read<ValidateTicketCubit>().validateTicket(
                                            eventId: widget.homeFeedItem?.id ?? '',
                                            ticket: text.trim(),
                                          );
                                        },
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide(
                                            color: ATColors.transparent
                                        )
                                      )
                                    );
                                  }
                                ),
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if(isPaidEvent)const SizedBox(height: 250,),
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
        bottomSheet: BlocConsumer<GetLiveProgramEntryTokenCubit,
          ATAppState<LiveProgramEntryToken>>(
          listener: (_, ATAppState<LiveProgramEntryToken> state)async{
            if(state is SuccessState<LiveProgramEntryToken>){
              final ProfileData? userData = context
                .read<LocalUserDataCubit>().currentUserData;
              final String? userId = userData?.userId;
              final bool hasTestedMic = userData?.hasTestedMic == true;
              final bool isHost = userId == widget.homeFeedItem?.hostId;
            
              final LiveProgramData liveProgramData = LiveProgramData(
                roomEntryToken: state.newData?.roomEntryToken ?? '',
                roomUrl: state.newData?.roomUrl ?? '',
                streamId: state.newData?.streamId ?? '',
                allowAudienceMic: state.newData?.allowAudienceMic ?? false,
                allowComments: state.newData?.allowComments ?? false,
                allowHandRaise: state.newData?.allowHandRaise ?? false,
                allowWhispers: state.newData?.allowWhispers ?? false,
                roomParticipantId: state.newData?.roomParticipantId ?? '',
                programId: widget.homeFeedItem?.id ?? '',
                coverUrl: widget.homeFeedItem?.coverUrl
                  ?? widget.homeFeedItem?.thumbnailUrl ?? '',
                role: isHost
                  ? ParticipantRole.host
                  : ParticipantRole.audience,
                community: Community(name: 'Test Community'),
                programTitle: widget.homeFeedItem?.title ?? '',
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
            //final bool isPaid = widget.homeFeedItem?.programType == ProgramType.paid;
            return ValueListenableBuilder<bool>(
              valueListenable: _canJoinNotifier,
              builder: (_, bool canJoin, __) {
                final bool isPaid = canJoin == false;
                return ATBlurredBgBtn(
                  onPressed: (){
                    if(canJoin){
                      ctx.read<GetLiveProgramEntryTokenCubit>()
                      .getLiveProgramEntryToken(
                        widget.homeFeedItem?.livestreamId ?? '',
                      );
                    }
                    else{
                      //From here, redirect to payment flow. when you come back,
                      //set the "canJoin" notifier to true.
                    }
                  },
                  isLoading: state is LoadingState<LiveProgramEntryToken>,
                  bgColor: ATColors.white,
                  fgColor: ATColors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if(isPaid) ...<Widget>[
                          Text(
                          ATStrings.pay,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ATColors.hex0D0D0D,
                          ),
                        ),
                        const SizedBox(width: 5),
                        CircleAvatar(
                          radius: 2.5,
                          backgroundColor: ATColors.hex0D0D0D,
                        ),
                        const SizedBox(width: 5),
                      ],
                        
                      Text(
                        isPaid ? '${ATStrings.nairaText}${widget.homeFeedItem?.price}' : 'Join live event',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ATColors.hex0D0D0D,
                        ),
                      ),
                    ],
                  ),
                );
              }
            );
          }
        ),
      ),
    );
  }
}
