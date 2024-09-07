import 'package:amptive/src/routes.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/events_and_shows_models_widgets/free_show_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../common_widgets/custom_container_widget.dart';
import '../../events_and_shows_models_widgets/free_event_model.dart';
import '../../events_and_shows_models_widgets/paid_event_model.dart';
import '../../events_and_shows_models_widgets/paid_show_model.dart';
import '../full_discover_view_widgets/top_creators_model.dart';
import '../full_discover_view_widgets/trending_hashtag_model.dart';
import '../row_of_title_with_view_all_trailing.dart';

class AmptiveDiscoverSocietyAllTabViewWidget extends StatelessWidget {
  const AmptiveDiscoverSocietyAllTabViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AmptiveRowOfTitleWithTrendingViewAll(
          title: AmptiveOtherStrings.TRENDING,
          viewAllOnpressed: (){context.pushNamed(AmptiveRoutes.TRENDING_SOCIETY_SCREEN);},
        ),
        const Gap(10),
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
    
        const Gap(35),
        AmptiveRowOfTitleWithTrendingViewAll(
          title: AmptiveOtherStrings.PAID_SHOWS,
          viewAllOnpressed: (){},
        ),
        const Gap(10),
        SizedBox(
          height: 165,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptivePaidShowModel(
                trendingPicture: AmptiveImageStrings.OFFICE_LADIES,
              )
            ),
          ),
        ),
    
        const Gap(35),
        AmptiveRowOfTitleWithTrendingViewAll(
          title: AmptiveOtherStrings.FREE_SHOWS,
          viewAllOnpressed: (){},
        ),
        const Gap(10),
        SizedBox(
          height: 165,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptiveFreeShowModel(
                trendingPicture: AmptiveImageStrings.JOE_POMP_SHOW
              )
            ),
          ),
        ),
        const Gap(35),
    
        AmptiveCustomContainer(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            AmptiveOtherStrings.POPULAR_CREATORS,
            style: Theme.of(context).textTheme.bodyLarge 
          ),
        ),
        const Gap(10),
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
    
        const Gap(35),
        AmptiveRowOfTitleWithTrendingViewAll(
          title: AmptiveOtherStrings.PAID_EVENTS,
          viewAllOnpressed: (){},
        ),
        const Gap(10),
        SizedBox(
          height: 165,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptivePaidEventModel(
                trendingPicture: AmptiveImageStrings.CRIMINAL
              )
            ),
          ),
        ),
        const Gap(35),
    
        AmptiveRowOfTitleWithTrendingViewAll(
          title: AmptiveOtherStrings.FREE_EVENTS,
          viewAllOnpressed: (){},
        ),
        const Gap(10),
        SizedBox(
          height: 165,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              5,
              (_) => const AmptiveFreeEventModel(
                trendingPicture: AmptiveImageStrings.weCanDoHardThingsBgImage
              )
            ),
          ),
        ),
        const Gap(35),
      ],
    );
  }
}