import 'package:amptive/src/features/discover/presentation/widgets/society_all_tab_view.dart' show SeparatorDivider;
import 'package:flutter/material.dart';

import '../../../../config/utils/image_strings.dart';
import '../../../../config/utils/other_strings.dart';
import 'render_trending_hashtag.dart';
import 'hashtag_heading_row.dart';

class SocietyShowsTabView extends StatelessWidget {
  const SocietyShowsTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HastagHeadingRow(
          title: ATStrings.TRENDING,
          viewAllOnpressed: (){},
        ),
        const SizedBox(height: 10,),
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
    
        const SeparatorDivider(),
    
        const SizedBox(height: 40,),
        HastagHeadingRow(
          title: ATStrings.PAID_SHOWS,
          viewAllOnpressed: (){},
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 180,
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
    
        const SeparatorDivider(),

        const SizedBox(height: 40,),
        HastagHeadingRow(
          title: ATStrings.FREE_SHOWS,
          viewAllOnpressed: (){},
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 180,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List<Widget>.generate(
              5,
              (_) => const RenderTrendingHashTag(
                trendingPicture: ATImgStrings.JOE_POMP_SHOW
              )
            ),
          ),
        ),
        const SizedBox(height: 50,),
      ],
    );
  }
}