import 'package:amptive/src/config/utils/dialogs/dialog_export.dart';
import 'package:amptive/src/features/home/presentation/widgets/render_community_name.dart';
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

class LiveEventDetailedScreen extends StatelessWidget {
  const LiveEventDetailedScreen({
    super.key,
    this.homeFeedItem,
  });

  final HomeFeedItem? homeFeedItem;

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
                  imgPath: homeFeedItem?.coverUrl ??
                      homeFeedItem?.thumbnailUrl ??
                      '',
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
                                      tag: homeFeedItem?.coverUrl ??
                                          homeFeedItem?.thumbnailUrl ??
                                          '',
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(16),
                                        child: ATImgLoader(
                                          imgPath: homeFeedItem?.coverUrl ??
                                              homeFeedItem?.thumbnailUrl ??
                                              '',
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
                                  homeFeedItem?.title ?? '',
                                  overflow: TextOverflow.clip,
                                  style:
                                      context.textTheme.displayMedium?.copyWith(
                                    fontSize: ATSizes.size24,
                                    fontWeight: ATFontWeights.w600,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Row(
                                  spacing: 20,
                                  children: <Widget>[
                                    LiveIndicatorWithAnimatinWifiIcon(),
                                    Flexible(
                                        child: RenderCommunityName(
                                            communityName: 'Test Community'))
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
                                const RenderHashTags(),
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
                                  title: homeFeedItem?.hostName ?? '',
                                  subtitle: 'Host',
                                  diameter: 35,
                                  leadingImagePath:
                                      (homeFeedItem?.hostProfileImageUrl ?? '')
                                              .isNotEmpty
                                          ? homeFeedItem!.hostProfileImageUrl!
                                          : ATImgStrings.noAvatarImage,
                                ),
                                ...(homeFeedItem?.cohosts ?? <User>[])
                                    .map((User cohost) => TileWithLeadingImage(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 9),
                                          title: cohost.username ?? '',
                                          subtitle: 'Cohost',
                                          diameter: 42,
                                          leadingImagePath:
                                              cohost.profilePicture ??
                                                  ATImgStrings.noAvatarImage,
                                        )),
                                const SizedBox(height: 30),
                                Text(
                                  '${homeFeedItem?.viewerCount ?? 0} Listening',
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(fontSize: ATSizes.size17),
                                ),
                                Divider(
                                  color: ATColors.white.withValues(alpha: 0.1),
                                ),
                                const SizedBox(height: 10),
                                if ((homeFeedItem?.avatarUrls ?? <String>[])
                                    .isNotEmpty) ...<Widget>[
                                  PeopleListeningWithNumberStacked(
                                    images: homeFeedItem!.avatarUrls!,
                                    noOfListeners:
                                        homeFeedItem?.viewerCount ?? 0,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                                Text(
                                  'daniel, jessica, gerald, peter and 652 more',
                                  style: context.textTheme.bodySmall?.copyWith(
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
                                  color: ATColors.white.withValues(alpha: 0.1),
                                ),
                                ReadMoreText(
                                  homeFeedItem?.title ?? '',
                                  trimMode: TrimMode.Length,
                                  trimExpandedText: ATStrings.showLess,
                                  trimCollapsedText: ATStrings.showMore,
                                  colorClickableText: ATColors.white,
                                  trimLength: 100,
                                  style: TextStyle(
                                    color:
                                        ATColors.white.withValues(alpha: 0.6),
                                    fontSize: 14,
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
                                  color: ATColors.white.withValues(alpha: 0.1),
                                ),
                              ],
                            ),
                          ),
                          const ATWhispersWidget(),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  ATStrings.GOT_TICKET_ID,
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(fontSize: ATSizes.size17),
                                ),
                                Divider(
                                  color: ATColors.white.withValues(alpha: 0.1),
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
                                        borderRadius: BorderRadius.circular(14),
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 150),
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
        bottomSheet: BlocConsumer<GetLiveProgramEntryTokenCubit,
                ATAppState<LiveProgramEntryToken>>(
            listener: (_, ATAppState<LiveProgramEntryToken> state) async {
          if (state is SuccessState<LiveProgramEntryToken>) {
            final ProfileData? userData =
                context.read<LocalUserDataCubit>().currentUserData;
            final String? userId = userData?.userId;
            final bool hasTestedMic = userData?.hasTestedMic == true;
            final bool isHost = userId == homeFeedItem?.hostId;

            final LiveProgramData liveProgramData = LiveProgramData(
                roomEntryToken: state.newData?.roomEntryToken ?? '',
                roomUrl: state.newData?.roomUrl ?? '',
                streamId: state.newData?.streamId ?? '',
                roomParticipantId: state.newData?.roomParticipantId ?? '',
                programId: homeFeedItem?.id ?? '',
                coverUrl:
                    homeFeedItem?.coverUrl ?? homeFeedItem?.thumbnailUrl ?? '',
                role: isHost ? ParticipantRole.host : ParticipantRole.audience,
                community: Community(name: 'Test Community'),
                programTitle: homeFeedItem?.title ?? '',
                programDesc: 'New program');

            if (!isHost || hasTestedMic) {
              context.pop(liveProgramData);
            } else {
              await context.pushNamed(
                ATRoutes.goLiveOnboarding,
                extra: liveProgramData,
              );

              if (context.mounted) {
                context.pop(liveProgramData);
              }
            }
          } else if (state is FailureState<LiveProgramEntryToken>) {
            showAppNotification2(
              context: context,
              text: state.message,
              type: NotificationType.failure,
            );
          }
        }, builder:
                (BuildContext ctx, ATAppState<LiveProgramEntryToken> state) {
          final bool isPaid = homeFeedItem?.programType == ProgramType.paid;
          return ATBlurredBgBtn(
            onPressed: () async {
  String? selectedPaymentMethod;

  if (isPaid) {
    selectedPaymentMethod = await selectOneTimePaymentMethodDialog(
      context: context,
      amount: '${homeFeedItem?.price ?? 0}',
    );

    if (!context.mounted || selectedPaymentMethod == null) {
      return;
    }

    final bool? paymentSuccess = await oneTimePaymentDialog(
      context: context,
      paymentMethod: selectedPaymentMethod,
      contentId: homeFeedItem?.id ?? '',
      amount: int.tryParse('${homeFeedItem?.price ?? 0}') ?? 0,
    );

    if (paymentSuccess != true) {
      return;  
    }
  }


  ctx.read<GetLiveProgramEntryTokenCubit>().getLiveProgramEntryToken(
    homeFeedItem?.livestreamId ?? '',
  );
},
            isLoading: state is LoadingState<LiveProgramEntryToken>,
            bgColor: ATColors.white,
            fgColor: ATColors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (isPaid) ...<Widget>[
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
                ],
                Text(
                  isPaid
                      ? '${ATStrings.nairaText}${homeFeedItem?.price}'
                      : 'Join live event',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: ATFontWeights.w600,
                    color: ATColors.hex0D0D0D,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
