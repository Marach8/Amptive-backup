import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/blurred_header.dart';
import '../../../../shared/hashtag_badge.dart';
import '../../../../shared/sliver_header_delegate.dart';
import '../widgets/trending_society_hashtag_widget.dart';

class SocietyHastagScreen extends StatelessWidget {
  const SocietyHastagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: ATRoundedBackBtn(
                                  bgColor: ATColors.transparent,
                                ),
                              ),
                              Text(
                                ATStrings.HASH +
                                    ATStrings.society.toLowerCase(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                width: 30,
                              )
                            ],
                          ),
                        )),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: <Widget>[
                          const ATHashtagBadge(),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                ATStrings.HASH + ATStrings.society,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: ATSizes.size15),
                              ),
                              Text(
                                'ankira22, emmanuel, and 15k others are live',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        fontSize: ATSizes.size13,
                                        color: ATColors.hexA8A8A8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 15,
                  )),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    sliver: SliverGrid(
                        delegate: SliverChildListDelegate.fixed(
                            List<Widget>.generate(
                                28,
                                (_) => const TrendingSocietyHashtagWidget(
                                    trendingPicture: ATImgStrings
                                        .weCanDoHardThingsBgImage)).toList()),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 18,
                                childAspectRatio: 0.72)),
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
