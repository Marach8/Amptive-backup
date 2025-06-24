import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import '../../events_and_shows_models_widgets/free_event_model.dart';
import '../../events_and_shows_models_widgets/paid_event_model.dart';
import '../../../../../../features/discover/presentation/widgets/render_trending_hashtag.dart';
import '../../../../../../features/discover/presentation/widgets/hashtag_heading_row.dart';

class AmptiveDiscoverSocietyEventsTabViewWidget extends StatelessWidget {
  const AmptiveDiscoverSocietyEventsTabViewWidget({
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
          title: ATStrings.PAID_EVENTS,
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
                trendingPicture: ATImgStrings.CRIMINAL
              )
            ),
          ),
        ),
        const Gap(35),
    
        HastagHeadingRow(
          title: ATStrings.FREE_EVENTS,
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
                trendingPicture: ATImgStrings.weCanDoHardThingsBgImage
              )
            ),
          ),
        ),
        const Gap(35),
      ],
    );
  }
}