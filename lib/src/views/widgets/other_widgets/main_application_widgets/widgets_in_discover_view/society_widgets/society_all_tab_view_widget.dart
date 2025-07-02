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
import '../../../../../../features/discover/presentation/widgets/render_trending_hashtag.dart';
import '../../../../../../features/discover/presentation/widgets/hashtag_heading_row.dart';

class AmptiveDiscoverSocietyAllTabViewWidget extends StatelessWidget {
  const AmptiveDiscoverSocietyAllTabViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HastagHeadingRow(
          title: ATStrings.TRENDING,
          viewAllOnpressed: (){context.pushNamed(ATRoutes.TRENDING_SOCIETY_SCREEN);},
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
        const Gap(35),
    
        ATContainer(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            ATStrings.POPULAR_CREATORS,
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
                picture: ATImgStrings.MAN_PHOTO
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