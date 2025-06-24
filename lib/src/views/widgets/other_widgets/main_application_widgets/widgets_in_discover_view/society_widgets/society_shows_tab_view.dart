import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/events_and_shows_models_widgets/free_show_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import '../../events_and_shows_models_widgets/paid_show_model.dart';
import '../../../../../../features/discover/presentation/widgets/render_trending_hashtag.dart';
import '../../../../../../features/discover/presentation/widgets/hashtag_heading_row.dart';

class AmptiveDiscoverSocietyShowsTabViewWidget extends StatelessWidget {
  const AmptiveDiscoverSocietyShowsTabViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HastagHeadingRow(
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
              (_) => const RenderTrendingHashTag(
                trendingPicture: ATImgStrings.weCanDoHardThingsBgImage,
              )
            ),
          ),
        ),
    
        const Gap(35),
        HastagHeadingRow(
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
                trendingPicture: ATImgStrings.OFFICE_LADIES,
              )
            ),
          ),
        ),
    
        const Gap(35),
        HastagHeadingRow(
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
                trendingPicture: ATImgStrings.JOE_POMP_SHOW
              )
            ),
          ),
        ),
      ],
    );
  }
}