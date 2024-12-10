import 'dart:async';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
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
        const NewWidget(),
        Gap(30.h),
        AmptiveRowOfTitleWithTrendingViewAll(
          title: AmptiveOtherStrings.TRENDING_HASHTAGS,
          viewAllOnpressed: (){
            context.pushNamed(AmptiveRoutes.TRENDING_HASHTAGS_SCREEN);
          },
        ),
    
        Gap(10.h),
    
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: AmptiveRowOfTrendingHashTagTitle(
            trailingOnpressed: () => context.pushNamed(AmptiveRoutes.SOCIETY_SCREEN),
            hashTagTitle: AmptiveOtherStrings.SOCIETY,
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
          categoryName: AmptiveOtherStrings.TECHNOLOGY
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
          categoryName: AmptiveOtherStrings.SPORTS,
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
          categoryName: AmptiveOtherStrings.TRUE_CRIME,
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





class NewWidget extends StatefulWidget {
  const NewWidget({
    super.key,
  });

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  ValueNotifier<int> indexNotifier = ValueNotifier(0);
  late ScrollController _scrollController;
  late Timer _timer;
  int _currentItemIndex = 0;
  final int _itemCount = 3;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollToNextItem();
  }

  void _scrollToNextItem() {
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async{
        await _scrollController.animateTo(
          _currentItemIndex * AmptiveHelperFunctions.getScreenWidth(context) * 0.9,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
        ).then(
          (_) => indexNotifier.value = _currentItemIndex,
        );
        // marach.log(_currentItemIndex.toString());

        _currentItemIndex++;
        if (_currentItemIndex >= _itemCount) {
          // Reset to the first item if we reach the end
          _currentItemIndex = 0;
          _scrollController.jumpTo(0.0);
        }
      }
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 265,
      child: Column(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index){
                  return ValueListenableBuilder(
                    valueListenable: indexNotifier,
                    builder: (_, value, __){
                      //marach.log('this is the value $value');
                      final isActive = index == value;
                      return AmptiveCustomContainer(
                        margin: const EdgeInsets.only(left: 3),
                        radius: 8,
                        color: isActive ? AmptiveColors.whiteColor : AmptiveColors.inactiveDotColor,
                        height: 8, 
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

          // SmoothPageIndicator(
          //   controller: PageController(),
          //   count: 3,
          //   effect: ExpandingDotsEffect(
          //     activeDotColor: AmptiveColors.whiteColor,
          //     dotColor: AmptiveColors.inactiveDotColor,
          //     dotHeight: 8, dotWidth: 8,
          //     spacing: 4
          //   ),
          // )