import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_back_arrow_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/constants/strings/image_strings.dart';
import '../widgets/hastags_subtitle_row.dart';
import '../widgets/render_trending_hashtag.dart';

class AmptiveTrendingHashTagsScreen extends StatelessWidget {
  const AmptiveTrendingHashTagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: Text(
                ATStrings.TRENDING_HASHTAGS,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              elevation: 0,
              centerTitle: true,
              floating: true,
              leading: const AmptiveBackArrowWidget()
            ),

            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: HashTagsSubtitleRow(
                      hashTagTitle: ATStrings.SOCIETY,
                      hashTagSubTitle: 'ankira22, glendonnor, and 15k other are live',
                      trailingOnpressed: (){
                        context.pushNamed(ATRoutes.TRENDING_HASHTAG_FULL_SCREEN);
                      },
                    ),
                  ),              
                  Gap(15.h),              
                  SizedBox(
                    height: 165,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        5,
                        (_) => const RenderTrendingHashTag(
                          trendingPicture: ATImgStrings.weCanDoHardThingsBgImage,
                        )
                      ),
                    ),
                  ),

                  Gap(40.h),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: HashTagsSubtitleRow(
                      trailingOnpressed: (){},
                      hashTagTitle: 'Katerinisback',
                      hashTagSubTitle: 'emmanuel, nnanna and 205 others are live',
                    ),
                  ),              
                  Gap(15.h),              
                  SizedBox(
                    height: 165,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        5,
                        (_) => const RenderTrendingHashTag(
                          trendingPicture: ATImgStrings.OFFICE_LADIES
                        )
                      ),
                    ),
                  ),

                  Gap(40.h),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: HashTagsSubtitleRow(
                      hashTagTitle: ATStrings.SOCIETY,
                      hashTagSubTitle: 'ankira22, glendonnor, and 15k other are live',
                      trailingOnpressed: (){},
                    ),
                  ),              
                  Gap(15.h),              
                  SizedBox(
                    height: 165,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        5,
                        (_) => const RenderTrendingHashTag(
                          trendingPicture: ATImgStrings.weCanDoHardThingsBgImage,
                        )
                      ),
                    ),
                  ),

                  Gap(40.h),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: HashTagsSubtitleRow(
                      trailingOnpressed: (){},
                      hashTagTitle: 'Katerinisback',
                      hashTagSubTitle: 'emmanuel, nnanna and 205 others are live',
                    ),
                  ),              
                  Gap(15.h),              
                  SizedBox(
                    height: 165,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        5,
                        (_) => const RenderTrendingHashTag(
                          trendingPicture: ATImgStrings.OFFICE_LADIES
                        )
                      ),
                    ),
                  ),
              
              
                  Gap(60.h),
                ]
              )
            )
          ],
        ),
      ),
    );
  }
}