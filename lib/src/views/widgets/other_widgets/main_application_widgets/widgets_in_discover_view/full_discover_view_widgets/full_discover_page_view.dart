import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import 'discover_categories_title.dart';
import 'more_2_discover_model.dart';
import 'more_to_discover_title.dart';
import 'row_of_trending_hashtag_title.dart';
import 'technology_model.dart';
import 'top_creators_model.dart';
import 'trending_hashtag_model.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';

class AmptiveFullDiscoverPageView extends StatelessWidget {
  const AmptiveFullDiscoverPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 265,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    3,
                    (_) => const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.discoverPic1),
                    )
                  )
                ),
              ),
              const Spacer(),
              SmoothPageIndicator(
                controller: PageController(),
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor: AmptiveColors.whiteColor,
                  dotColor: AmptiveColors.inactiveDotColor,
                  dotHeight: 8, dotWidth: 8,
                  spacing: 4
                ),
              )
            ],
          ),
        ),
        Gap(30.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                AmptiveOtherStrings.TRENDING_HASHTAGS,
                style: Theme.of(context).textTheme.bodyLarge 
              ),
              const Spacer(),
              GestureDetector(
                onTap: (){},
                child: Row(
                  children: [
                    Text(
                      AmptiveOtherStrings.VIEW_ALL,
                      style: Theme.of(context).textTheme.labelMedium
                    ),
                    Icon(Icons.keyboard_arrow_right_sharp, color: AmptiveColors.authHintColor,)
                  ],
                ),
              )
            ],
          ),
        ),

        Gap(10.h),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: AmptiveRowOfTrendingHashTagTitle(
            hashTagTitle: AmptiveOtherStrings.society,
            hashTagSubTitle: 'ankira22, glendonnor, and 15k other are live',
          ),
        ),

        Gap(15.h),

        SizedBox(
          height: 165,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptiveTrendingHashtagModel(
                trendingPicture: AmptiveImageStrings.weCanDoHardThingsBgImage,
              )
            ),
          ),
        ),

        const Divider(indent: 15, endIndent: 15,),

        Gap(40.h),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: AmptiveRowOfTrendingHashTagTitle(
            hashTagTitle: 'Katerinisback',
            hashTagSubTitle: 'emmanuel, nnanna and 205 others are live',
          ),
        ),

        Gap(15.h),

        SizedBox(
          height: 165,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptiveTrendingHashtagModel(
                trendingPicture: AmptiveImageStrings.officeLadied
              )
            ),
          ),
        ),

        Gap(60.h),

        const AmptiveDiscoverCategoriesTitleWidget(
          categoryName: AmptiveOtherStrings.TECHNOLOGY
        ),
        Gap(15.h),
        SizedBox(
          height: 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptiveTechnologyModel(
                trendingPicture: AmptiveImageStrings.endlessThread
              )
            ),
          ),
        ),

        Gap(50.h),

        const AmptiveDiscoverCategoriesTitleWidget(
          categoryName: AmptiveOtherStrings.SPORTS,
        ),
        Gap(15.h),
        SizedBox(
          height: 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptiveTechnologyModel(
                trendingPicture: AmptiveImageStrings.JOE_POMP_SHOW
              )
            ),
          ),
        ),

        Gap(50.h),

        const AmptiveDiscoverCategoriesTitleWidget(
          categoryName: AmptiveOtherStrings.TRUE_CRIME,
        ),
        Gap(15.h),
        SizedBox(
          height: 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptiveTechnologyModel(
                trendingPicture: AmptiveImageStrings.CRIMINAL
              )
            ),
          ),
        ),

        Gap(50.h),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: AmptiveMore2DiscoverTitle(),
        ),
        Gap(15.h),
        SizedBox(
          height: 122,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptiveMore2DiscoverModel(
                picture: AmptiveImageStrings.COMMUNITY_CARD
              )
            ),
          ),
        ),

        Gap(50.h),

        AmptiveCustomContainer(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            AmptiveOtherStrings.TOP_CREATORS,
            style: Theme.of(context).textTheme.bodyLarge 
          ),
        ),
        Gap(20.h),
        SizedBox(
          height: 165,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptiveTopCreatorsModel(
                picture: AmptiveImageStrings.MAN_PHOTO
              )
            ),
          ),
        ),

        Gap(50.h),

        AmptiveCustomContainer(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            AmptiveOtherStrings.SPOTLIGHT,
            style: Theme.of(context).textTheme.bodyLarge 
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
              (_) => const AmptiveTrendingHashtagModel(
                trendingPicture: AmptiveImageStrings.officeLadied
              )
            ),
          ),
        ),
      ],
    );
  }
}