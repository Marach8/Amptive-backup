import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/events_and_shows_models_widgets/free_show_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import '../../events_and_shows_models_widgets/paid_show_model.dart';
import '../full_discover_view_widgets/trending_hashtag_model.dart';
import '../row_of_title_with_view_all_trailing.dart';

class AmptiveDiscoverSocietyShowsTabViewWidget extends StatelessWidget {
  const AmptiveDiscoverSocietyShowsTabViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AmptiveRowOfTitleWithTrendingViewAll(
          title: ATStrings.TRENDING,
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
          title: ATStrings.PAID_SHOWS,
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
          title: ATStrings.FREE_SHOWS,
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
      ],
    );
  }
}