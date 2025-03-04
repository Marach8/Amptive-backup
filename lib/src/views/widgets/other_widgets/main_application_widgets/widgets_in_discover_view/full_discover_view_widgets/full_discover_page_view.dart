import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import '../row_of_title_with_view_all_trailing.dart';
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
  Widget build(context) {
    return Column(
      children: [
        const _HorizontalScrollCards(),
        Gap(30.h),
        AmptiveRowOfTitleWithTrendingViewAll(
          title: ATStrings.TRENDING_HASHTAGS,
          viewAllOnpressed: (){
            context.pushNamed(ATRoutes.TRENDING_HASHTAGS_SCREEN);
          },
        ),
    
        Gap(10.h),
    
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: AmptiveRowOfTrendingHashTagTitle(
            trailingOnpressed: () => context.pushNamed(ATRoutes.SOCIETY_SCREEN),
            hashTagTitle: ATStrings.SOCIETY,
            hashTagSubTitle: 'ankira22, glendonnor, and 15k other are live',
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
                trendingPicture: AmptiveImageStrings.weCanDoHardThingsBgImage,
              )
            ),
          ),
        ),
    
        const Divider(indent: 15, endIndent: 15,),
    
        Gap(40.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: AmptiveRowOfTrendingHashTagTitle(
            trailingOnpressed: (){},
            hashTagTitle: 'Katerinisback',
            hashTagSubTitle: 'emmanuel, nnanna and 205 others are live',
          ),
        ),
    
        Gap(15.h),
    
        SizedBox(
          height: 170,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptiveTrendingHashtagModel(
                trendingPicture: AmptiveImageStrings.OFFICE_LADIES
              )
            ),
          ),
        ),
    
        Gap(60.h),
    
        const AmptiveDiscoverCategoriesTitleWidget(
          categoryName: ATStrings.TECHNOLOGY
        ),
        Gap(15.h),
        SizedBox(
          height: 300,
          child: ListView(
            physics: const BouncingScrollPhysics(),
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
          categoryName: ATStrings.SPORTS,
        ),
        Gap(15.h),
        SizedBox(
          height: 300,
          child: ListView(
            physics: const BouncingScrollPhysics(),
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
          categoryName: ATStrings.TRUE_CRIME,
        ),
        Gap(15.h),
        SizedBox(
          height: 300,
          child: ListView(
            physics: const BouncingScrollPhysics(),
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
    
        ATContainer(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            ATStrings.TOP_CREATORS,
            style: Theme.of(context).textTheme.bodyLarge 
          ),
        ),
        Gap(20.h),
        SizedBox(
          height: 170,
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
    
        ATContainer(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            ATStrings.SPOTLIGHT,
            style: Theme.of(context).textTheme.bodyLarge 
          ),
        ),
        Gap(15.h),
        SizedBox(
          height: 170,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptiveTrendingHashtagModel(
                trendingPicture: AmptiveImageStrings.OFFICE_LADIES
              )
            ),
          ),
        ),
        const Gap(100)
      ],
    );
  }
}





class _HorizontalScrollCards extends StatefulWidget {
  const _HorizontalScrollCards();

  @override
  State<_HorizontalScrollCards> createState() => _HorizontalScrollCardsState();
}

class _HorizontalScrollCardsState extends State<_HorizontalScrollCards> {
  final ValueNotifier<int> _indexNotifier = ValueNotifier(0);
  final _adverts = [
    AmptiveImageStrings.discoverPic1,
    AmptiveImageStrings.discoverPic1,
    AmptiveImageStrings.discoverPic1
  ];


  @override
  void dispose() {
    _indexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return SizedBox(
      height: 260,
      width: ATHelperFuncs.getScreenWidth(context),
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: _adverts.length,
            itemBuilder: (_, pageIndex, __){
              final advert = _adverts.elementAtOrNull(pageIndex);
              return AmptiveImageLoaderWidget(imagePath: advert ?? '');
            },
            options: CarouselOptions(
              autoPlay: true,
              scrollPhysics: const BouncingScrollPhysics(),
              autoPlayCurve: Curves.decelerate,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (pageIndex, _) => _indexNotifier.value = pageIndex
            )
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index){
                  return AmptiveRebuilderWidget(
                    notifier: _indexNotifier,
                    builder: (_, value, __){
                      final isActive = index == value;
                      return ATContainer(
                        margin: const EdgeInsets.only(left: 3),
                        radius: 8, height: 8,
                        color: isActive ? ATColors.whiteColor : ATColors.inactiveDotColor, 
                        width: isActive ? 25 : 8,
                        child: const SizedBox.shrink()
                      );
                    }
                  );
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}
