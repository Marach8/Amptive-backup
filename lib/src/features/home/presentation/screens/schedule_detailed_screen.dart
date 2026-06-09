import 'dart:ui';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/features/home/cubits/going_cubit.dart';
import 'package:amptive/src/features/home/data/models/response/going_status.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';
import '../../../../shared/sliver_header_delegate.dart';
import 'package:amptive/src/shared/render_hashtags.dart';
import 'package:amptive/src/shared/blurred_header.dart';
import '../widgets/event_or_show_card.dart';
import '../widgets/people_listening.dart';

class ATScheduleDetailedScreen extends StatelessWidget {
  const ATScheduleDetailedScreen({
    super.key,
    this.homeFeedItem,
  });

  final HomeFeedItem? homeFeedItem;

  bool get _canMarkAsGoing {
    final contentType = homeFeedItem?.contentType?.toLowerCase();
    return contentType == 'standalone' || contentType == 'episode';
  }

  GoingStatus _getInitialGoingStatus() {
    return GoingStatus(
      isGoing: homeFeedItem?.requesterIsGoing ?? false,
      goingCount: homeFeedItem?.goingCount ?? 0,
    );
  }

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
      statusBarColor: ATColors.transparent,
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<BlurredHeaderCubit>(
            create: (_) => BlurredHeaderCubit(),
          ),
          BlocProvider<GoingCubit>(
            create: (_) => GoingCubit(initialStatus: _getInitialGoingStatus()),
          ),
        ],
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
                    padding: const EdgeInsets.fromLTRB(
                        15, 10, 15, kBottomNavigationBarHeight * 1.5),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ATEventOrShowCard(
                          imgPath: _displayImage,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          maxLines: 2,
                          homeFeedItem?.title ?? '',
                          overflow: TextOverflow.clip,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontSize: ATSizes.size24,
                                fontWeight: ATFontWeights.w600,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${homeFeedItem?.goingCount ?? 0} Going',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontSize: ATSizes.size14,
                                color: ATColors.white.withValues(alpha: 0.6),
                              ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          ATStrings.hashtags,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: ATSizes.size17),
                        ),
                        Divider(
                          color: ATColors.white.withValues(alpha: 0.1),
                        ),
                        const SizedBox(height: 5),
                        const RenderHashTags(),
                        const SizedBox(height: 30),
                        Text(
                          ATStrings.hostedBy,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: ATSizes.size17),
                        ),
                        Divider(
                          color: ATColors.white.withValues(alpha: 0.1),
                        ),
                        TileWithLeadingImage(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          title: homeFeedItem?.hostName ?? '',
                          subtitle: 'Host',
                          diameter: 42,
                          leadingImagePath: homeFeedItem?.hostProfileImageUrl ??
                              ATImgStrings.jpeg1,
                        ),
                        const SizedBox(height: 30),
                        if ((homeFeedItem?.avatarUrls?.isNotEmpty ?? false) ||
                            (homeFeedItem?.goingCount ?? 0) > 0) ...[
                          Text(
                            '${homeFeedItem?.goingCount ?? 0} Listening',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: ATSizes.size17),
                          ),
                          Divider(
                            color: ATColors.white.withValues(alpha: 0.1),
                          ),
                          const SizedBox(height: 10),
                          const NoOfListenersWidget(),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: _canMarkAsGoing
              ? BlocBuilder<GoingCubit, dynamic>(
                  builder: (context, state) {
                    final goingCubit = context.read<GoingCubit>();
                    final isGoing =
                        goingCubit.currentGoingStatus?.isGoing ?? false;
                    final goingCount =
                        goingCubit.currentGoingStatus?.goingCount ?? 0;

                    return ATContainer(
                      height: 90,
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            ATColors.hex0D0D0D.withValues(alpha: 0.1),
                            ATColors.hex0D0D0D
                          ]),
                      padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                      child: GestureDetector(
                        onTap: () {
                          final contentType =
                              homeFeedItem?.contentType?.toLowerCase();
                          final type = contentType == 'standalone'
                              ? GoingType.event
                              : GoingType.episode;
                          goingCubit.toggleGoing(
                            contentId: homeFeedItem!.id!,
                            type: type,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color:
                                isGoing ? ATColors.white : Colors.transparent,
                            border:
                                Border.all(color: ATColors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (isGoing) ...[
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
                                  color: isGoing
                                      ? ATColors.hex0D0D0D
                                      : ATColors.white,
                                  fontSize: ATSizes.size16,
                                  fontWeight: ATFontWeights.w600,
                                ),
                              ),
                              if (isGoing && goingCount > 0) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ATColors.hex0D0D0D
                                        .withValues(alpha: 0.2),
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
                        ),
                      ),
                    );
                  },
                )
              : null,
        ),
      ),
    );
  }
}
