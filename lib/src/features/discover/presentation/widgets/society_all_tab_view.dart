import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/utils/image_strings.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../views/widgets/common_widgets/custom_container_widget.dart';
import 'top_creator_widget.dart';
import 'render_trending_hashtag.dart';
import 'hashtag_heading_row.dart';

class SocietyAllTabView extends StatelessWidget {
  const SocietyAllTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HastagHeadingRow(
          title: ATStrings.TRENDING,
          viewAllOnpressed: (){context.pushNamed(ATRoutes.TRENDING_SOCIETY_SCREEN);},
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
                trendingPicture: ATImgStrings.JOE_POMP_SHOW,
              )
            ),
          ),
        ),
        const SeparatorDivider(),

        const SizedBox(height: 40,),

        ATContainer(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            ATStrings.POPULAR_CREATORS,
            style: Theme.of(context).textTheme.bodyLarge 
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 180,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List<Widget>.generate(
              5,
              (_) => const TopCreatorWidget(
                picture: ATImgStrings.MAN_PHOTO
              )
            ),
          ),
        ),

        const SeparatorDivider(),
    
        const SizedBox(height: 35,),
        HastagHeadingRow(
          title: ATStrings.PAID_EVENTS,
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
                trendingPicture: ATImgStrings.CRIMINAL,
              )
            ),
          ),
        ),
        const SeparatorDivider(),

        const SizedBox(height: 35,),    
        HastagHeadingRow(
          title: ATStrings.FREE_EVENTS,
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
        const SizedBox(height: 50,)
      ],
    );
  }
}





class SeparatorDivider extends StatelessWidget {
  const SeparatorDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: 15, endIndent: 15,
      color: ATColors.hex252525
    );
  }
}