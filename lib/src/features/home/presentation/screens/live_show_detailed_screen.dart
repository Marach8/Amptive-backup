import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/home/presentation/widgets/detailed_screen_header.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_detail_hashtags.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/dashboard.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amptive/src/shared/animated_expandable_text.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';
import '../../../../shared/sliver_header_delegate.dart';
import 'package:amptive/src/shared/mesh_gradient_background.dart';
import '../../../../config/utils/dominant_color_extractor.dart';
import '../widgets/empty_listeners_widget.dart';
import '../widgets/event_or_show_card.dart';
import '../../../episodes/presentation/widgets/existing_episodes_indicator.dart';
import '../widgets/people_listening.dart';
import '../widgets/whispers_list.dart';
import '../widgets/whispers_list.dart';
import '../../data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/cubits/show_detail_cubit.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/shared/shimmer.dart';

class ATLiveShowDetailedScreen extends StatelessWidget {
  const ATLiveShowDetailedScreen({
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
    final double physicalTopPadding =
        MediaQueryData.fromView(View.of(context)).padding.top;
    final double blurredHeaderHeight = kToolbarHeight + physicalTopPadding;
    return ATAnnotatedRegion(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ShowDetailCubit>(
            create: (_) => ShowDetailCubit(
              initialShow: HostedShow(
                showId: homeFeedItem?.id ?? homeFeedItem?.showId,
                title: homeFeedItem?.title,
                description: homeFeedItem?.description,
                coverUrl: _displayImage,
              ),
            )..fetchShowDetails(),
          ),
          BlocProvider<DominantColorCubit>(
            create: (_) => DominantColorCubit()
              ..extractColor(
                  _displayImage ?? ATImgStrings.weCanDoHardThingsBgImage),
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<DominantColorCubit, DominantColorState>(
            builder: (context, state) {
              return ATMeshGradientBackground(
                state: state,
                child: BlocProvider<BlurredHeaderCubit>(
                  create: (_) => BlurredHeaderCubit(),
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
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    DetailedScreenHeader(
                                      homeFeedItem: homeFeedItem,
                                      displayImage: _displayImage,
                                    ),
                                    ProgramDetailHashtags(
                                      homeFeedItem: homeFeedItem,
                                    ),
                                    Text(
                                      ATStrings.hostedBy,
                                      style: context.textTheme.titleMedium?.copyWith(
                                        fontSize: ATSizes.size17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Divider(
                                      color:
                                          ATColors.white.withValues(alpha: 0.1),
                                    ),
                                    TileWithLeadingImage(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 9),
                                      title: homeFeedItem?.hostName ?? '',
                                      subtitle: 'Host',
                                      diameter: 40,
                                      leadingImagePath:
                                          homeFeedItem?.hostProfileImageUrl ??
                                              ATImgStrings.jpeg1,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    if ((homeFeedItem?.status?.toLowerCase() == 'live' 
                                            ? (homeFeedItem?.viewerCount ?? 0) 
                                            : (homeFeedItem?.goingCount ?? 0)) > 0) ...[
                                      Text(
                                        homeFeedItem?.status?.toLowerCase() == 'live' 
                                            ? '${homeFeedItem?.viewerCount ?? 0} Listening' 
                                            : '${homeFeedItem?.goingCount ?? 0} Going',
                                        style: context.textTheme.titleMedium?.copyWith(
                                          fontSize: ATSizes.size17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Divider(
                                        color:
                                            ATColors.white.withValues(alpha: 0.1),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      NoOfListenersWidget(
                                        avatarUrls: homeFeedItem?.avatarUrls ?? [],
                                        totalCount: homeFeedItem?.status?.toLowerCase() == 'live' 
                                            ? (homeFeedItem?.viewerCount ?? 0) 
                                            : (homeFeedItem?.goingCount ?? 0),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'daniel, jessica, gerald, peter and 652 more',
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                                color: ATColors.white
                                                    .withValues(alpha: 0.6)),
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                    ] else ...[
                                      EmptyListenersWidget(
                                        isLive: true,
                                        hashCodeForSentence: homeFeedItem?.hashCode,
                                      ),
                                    ],
                                    Text(
                                      'About Episode',
                                      style: context.textTheme.titleMedium?.copyWith(
                                        fontSize: ATSizes.size17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Divider(
                                      color:
                                          ATColors.white.withValues(alpha: 0.1),
                                    ),
                                    BlocBuilder<ShowDetailCubit, ATAppState<HostedShow>>(
                                      builder: (context, state) {
                                        final showData = context.read<ShowDetailCubit>().currentShowDetail;
                                        final description = showData?.description ?? homeFeedItem?.description;
                                        
                                        final bool isLoading = state is InitialState<HostedShow> || state is LoadingState<HostedShow>;
                                        if (isLoading && description == null) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              ATShimmer(height: 14, width: double.infinity, margin: EdgeInsets.only(bottom: 8)),
                                              ATShimmer(height: 14, width: double.infinity, margin: EdgeInsets.only(bottom: 8)),
                                              ATShimmer(height: 14, width: 200),
                                            ],
                                          );
                                        }

                                        final String fallbackText = 'No description provided.';
                                        final String parsedDescription = (description ?? fallbackText).stripHtmlAndPreserveNewlines;
                                        
                                        return AnimatedExpandableText(
                                          text: parsedDescription,
                                          trimLines: 3,
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      ATStrings.whispers,
                                      style: context.textTheme.titleMedium?.copyWith(
                                        fontSize: ATSizes.size17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Divider(
                                      color:
                                          ATColors.white.withValues(alpha: 0.1),
                                    ),
                                  ],
                                ),
                              ),
                              const ATWhispersWidget(),
                              const SizedBox(
                                height: 130,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          bottomSheet: ATBlurredBgBtn(
            showBackgroundGradient: true,
            onPressed: () {
              // context.pushNamed(
              //   ATRoutes.liveProgramScreen,
              //   extra: GoLiveProgramParams(
              //     streamId: homeFeedItem?.livestreamId ?? '',
              //     userType: GoLiveUserType.audience,
              //   ),
              // );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ATStrings.SUBSCRIBE,
                  style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: ATSizes.size17, color: ATColors.black),
                ),
                const SizedBox(
                  width: 5,
                ),
                ATCircleAvatar(
                  diameter: 5,
                  color: ATColors.black,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  homeFeedItem?.price != null
                      ? '₦${homeFeedItem!.price!.toStringAsFixed(0)}/month'
                      : '₦1,900/month',
                  style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: ATSizes.size17, color: ATColors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
