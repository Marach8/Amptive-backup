import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/utils/colors.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/blurred_header.dart';
import '../../../../shared/sliver_header_delegate.dart';
import '../widgets/trending_society_hashtag_widget.dart';

class TrendingSocietyScreen extends StatelessWidget {
  const TrendingSocietyScreen({super.key});

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
                              const Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: ATBackBtn(
                                    leadingText: ATStrings.society,
                                  )),
                              Text(
                                ATStrings.TRENDING,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 100)
                            ],
                          ),
                        )),
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
                                        trendingPicture: ATImgStrings.jpeg2))
                                .toList()),
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
