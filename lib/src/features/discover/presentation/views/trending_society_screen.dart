import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:flutter/material.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/blurred_header.dart';
import '../../../../shared/sliver_header_delegate.dart';
import '../widgets/trending_society_hashtag_widget.dart';

class TrendingSocietyScreen extends StatelessWidget {
  const TrendingSocietyScreen({super.key, this.title, this.items});

  /// Section title ("Trending", "Paid shows", …) and its full item list,
  /// passed by the community page's "View all" buttons.
  final String? title;
  final List<HomeFeedItem>? items;

  void _openItem(BuildContext context, HomeFeedItem item) {
    final bool isLive = item.status?.toLowerCase() == 'live';
    final String route = isLive
        ? item.contentType == 'standalone'
            ? ATRoutes.liveEventDetailed
            : ATRoutes.liveShowDetailed
        : ATRoutes.scheduleDetailed;
    context.pushNamed(route, extra: item);
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
            // Same as the dashboard: keeps the safe-area padding inside the
            // bottom menu so its height matches everywhere.
            resizeToAvoidBottomInset: false,
            bottomSheet: const AppBottomMenu(),
        body: BlocProvider<BlurredHeaderCubit>(
          create: (_) => BlurredHeaderCubit(),
          child: Builder(builder: (BuildContext blocContext) {
            return NotificationListener<ScrollNotification>(
              onNotification:
                  blocContext.read<BlurredHeaderCubit>().onScrollNotification,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: ATSliverHDelegate(
                        maxExt:
                            kToolbarHeight + MediaQuery.paddingOf(context).top,
                        minExt:
                            kToolbarHeight + MediaQuery.paddingOf(context).top,
                        child: ATBlurredHeaderWidget(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: ATBackBtn(
                                    alignment: Alignment.centerLeft,
                                    leadingText: title ?? ATStrings.TRENDING,
                                    leadingStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: ATSizes.size23,
                                          letterSpacing: -0.39,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 15,
                  )),
                  SliverPadding(
                    // Bottom clearance so the last row scrolls fully above
                    // the overlaying bottom menu.
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 120),
                    sliver: SliverGrid(
                        delegate: SliverChildListDelegate.fixed(
                            (items ?? <HomeFeedItem>[])
                                .map((HomeFeedItem item) =>
                                    TrendingSocietyHashtagWidget(
                                      trendingPicture: item.thumbnailUrl ??
                                          item.coverUrl ??
                                          item.showCoverUrl ??
                                          ATImgStrings.createShowPlaceholder,
                                      title: item.title ?? item.showTitle ?? '',
                                      creatorName: item.hostName ?? 'Creator',
                                      creatorAvatar:
                                          item.hostProfileImageUrl ??
                                              ATImgStrings.noAvatarImage,
                                      statusLabel:
                                          item.status?.toLowerCase() == 'live'
                                              ? 'LIVE'
                                              : 'Scheduled',
                                      isPaid: item.showType?.toLowerCase() ==
                                              'paid' ||
                                          (item.price ?? 0) > 0,
                                      onTap: () => _openItem(context, item),
                                    ))
                                .toList()),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 18,
                                // Square artwork + two text lines.
                                childAspectRatio: 0.74)),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
