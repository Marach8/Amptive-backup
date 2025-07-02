import 'package:amptive/src/features/discover/presentation/widgets/follow_unfollow_dropdown.dart';
import 'package:amptive/src/features/discover/presentation/widgets/horizontal_scroll_cards.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/strings/image_strings.dart';
import '../../../../utils/constants/strings/other_strings.dart';
import '../widgets/hashtag_heading_row.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/full_discover_view_widgets/discover_categories_title.dart';
import '../widgets/community_card_widget.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/full_discover_view_widgets/more_to_discover_title.dart';
import '../widgets/hastags_subtitle_row.dart';
import '../widgets/trending_technology_widget.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/full_discover_view_widgets/top_creators_model.dart';
import '../widgets/render_trending_hashtag.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';

class MainDiscoverView extends StatelessWidget {
  const MainDiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const HorizontalScrollCards(),
        const SizedBox(height: 48,),
        HastagHeadingRow(
          title: ATStrings.TRENDING_HASHTAGS,
          viewAllOnpressed: (){
            context.pushNamed(ATRoutes.TRENDING_HASHTAGS_SCREEN);
          },
        ),
    
        const SizedBox(height: 10,),
    
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: HashTagsSubtitleRow(
            trailingOnpressed: () => context.pushNamed(ATRoutes.SOCIETY_SCREEN),
            hashTagTitle: ATStrings.SOCIETY,
            hashTagSubTitle: 'ankira22, glendonnor, and 15k other are live',
          ),
        ),
    
        const SizedBox(height: 15,),
    
        SizedBox(
          height: 180,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List<Widget>.generate(
              5,
              (_) => const RenderTrendingHashTag(
                trendingPicture: ATImgStrings.weCanDoHardThingsBgImage,
              )
            ),
          ),
        ),
    
        Divider(
          indent: 15, endIndent: 15,
          color: ATColors.hex252525
        ),
    
        const SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: HashTagsSubtitleRow(
            trailingOnpressed: (){},
            hashTagTitle: 'Katerinisback',
            hashTagSubTitle: 'emmanuel, nnanna and 205 others are live',
          ),
        ),
    
        const SizedBox(height: 15),
    
        SizedBox(
          height: 170,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List<Widget>.generate(
              5,
              (_) => const RenderTrendingHashTag(
                trendingPicture: ATImgStrings.OFFICE_LADIES
              )
            ),
          ),
        ),
        Divider(
          indent: 15, endIndent: 15,
          color: ATColors.hex252525
        ),
    
        const SizedBox(height: 40),
    
        DiscoverCategoriesTile(
          categoryName: ATStrings.TECHNOLOGY,
          trailing: FollowUnfollowDropDown(
            text: ATStrings.FOLLOW,
            onSelected: (String po){},
            popUpTrailingIcon: const Icon(Icons.add_circle_outline),
            child: Icon(Icons.more_horiz, color: ATColors.white,),
          ),
        ),
        const SizedBox(height: 15,),
        
        SizedBox(
          height: 300,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              const SizedBox(width: 5,),
              ...List<Widget>.generate(
                5,
                (_) => const TrendingTechnologyWidget(
                  trendingPicture: ATImgStrings.ENDLESS_THREAD
                )
              ),
            ]
          ),
        ),
        Divider(
          indent: 15, endIndent: 15,
          color: ATColors.hex252525
        ),
    
        const SizedBox(height: 40),
    
        DiscoverCategoriesTile(
          categoryName: ATStrings.SPORTS,
          trailing: FollowUnfollowDropDown(
            text: ATStrings.UNFOLLOW,
            onSelected: (String po){},
            popUpTrailingIcon: const Icon(Icons.remove_circle_outline),
            child: Icon(Icons.more_horiz, color: ATColors.white,),
          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 300,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              const SizedBox(width: 5,),
              ...List<Widget>.generate(
                5,
                (_) => const TrendingTechnologyWidget(
                  trendingPicture: ATImgStrings.JOE_POMP_SHOW
                )
              ),
            ]
          ),
        ),
        Divider(
          indent: 15, endIndent: 15,
          color: ATColors.hex252525
        ),
    
        const SizedBox(height: 40),
    
        DiscoverCategoriesTile(
          categoryName: ATStrings.TRUE_CRIME,
          trailing: FollowUnfollowDropDown(
            text: ATStrings.FOLLOW,
            onSelected: (String po){},
            popUpTrailingIcon: const Icon(Icons.remove_circle_outline),
            child: Icon(Icons.more_horiz, color: ATColors.white,),
          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 300,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              const SizedBox(width: 5,),
              ...List<Widget>.generate(
                5,
                (_) => const TrendingTechnologyWidget(
                  trendingPicture: ATImgStrings.CRIMINAL
                )
              ),
            ]
          ),
        ),
        Divider(
          indent: 15, endIndent: 15,
          color: ATColors.hex252525
        ),
    
        const SizedBox(height: 40,),
    
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: AmptiveMore2DiscoverTitle(),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 122,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              const SizedBox(width: 5,),
              ...List<Widget>.generate(
                5,
                (_) => const CommunityCardWidget(
                  picture: ATImgStrings.COMMUNITY_CARD
                )
              ),
            ]
          ),
        ),
        Divider(
          indent: 15, endIndent: 15,
          color: ATColors.hex252525
        ),
    
        const SizedBox(height: 40,),
    
        ATContainer(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            ATStrings.TOP_CREATORS,
            style: Theme.of(context).textTheme.bodyLarge 
          ),
        ),
        const SizedBox(height: 20,),
        SizedBox(
          height: 170,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List<Widget>.generate(
              5,
              (_) => const AmptiveTopCreatorsModel(
                picture: ATImgStrings.MAN_PHOTO
              )
            ),
          ),
        ),
    
        const SizedBox(height: 48,),
    
        ATContainer(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            ATStrings.SPOTLIGHT,
            style: Theme.of(context).textTheme.bodyLarge 
          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 170,
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
        const Gap(100)
      ],
    );
  }
}