import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import '../../events_and_shows_models_widgets/free_event_model.dart';
import '../../events_and_shows_models_widgets/paid_event_model.dart';
import '../full_discover_view_widgets/trending_hashtag_model.dart';
import '../row_of_title_with_view_all_trailing.dart';

class AmptiveDiscoverSocietyEventsTabViewWidget extends StatelessWidget {
  const AmptiveDiscoverSocietyEventsTabViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AmptiveRowOfTitleWithTrendingViewAll(
          title: AmptiveOtherStrings.TRENDING,
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
              (_) => const AmptiveTrendingHashtagModel(
                trendingPicture: AmptiveImageStrings.weCanDoHardThingsBgImage,
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