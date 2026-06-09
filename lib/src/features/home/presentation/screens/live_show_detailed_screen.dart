import 'dart:ui';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/dashboard.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';
import '../../../../shared/sliver_header_delegate.dart';
import '../widgets/event_or_show_card.dart';
import '../../../episodes/presentation/widgets/existing_episodes_indicator.dart';
import '../widgets/people_listening.dart';
import '../widgets/whispers_list.dart';
import '../../data/models/response/home_feed_response_model.dart';

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
    final double blurredHeaderHeight =
        kToolbarHeight + MediaQuery.paddingOf(context).top;
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 250, sigmaY: 250),
                child: ATImgLoader(
                  boxFit: BoxFit.fill,
                  imgPath:
                      _displayImage ?? ATImgStrings.weCanDoHardThingsBgImage,
                ),
              ),
            ),
            ATContainer(
              color: ATColors.hex0D0D0D.withValues(alpha: 0.75),
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
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ATEventOrShowCard(
                                    imgPath: _displayImage,
                                  ),
                                  const SizedBox(height: 24),
                                  const ShowOrEventIndicatorWithTitle(),
                                  const SizedBox(
                                    height: 12,
                                  ),
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
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
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
                                  const SizedBox(
                                    height: 30,
                                  ),
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
                                    diameter: 42,
                                    leadingImagePath:
                                        homeFeedItem?.hostProfileImageUrl ??
                                            ATImgStrings.jpeg1,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    '${homeFeedItem?.viewerCount ?? 0} Listening',
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(fontSize: ATSizes.size17),
                                  ),
                                  Divider(
                                    color:
                                        ATColors.white.withValues(alpha: 0.1),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const NoOfListenersWidget(),
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
                                  Text(
                                    'About Episode',
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
                                  const SizedBox(
                                    height: 30,
                                  ),
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
                            const SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        bottomSheet: ATBlurredBgBtn(
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
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontSize: ATSizes.size17, color: ATColors.black),
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
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontSize: ATSizes.size17, color: ATColors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
