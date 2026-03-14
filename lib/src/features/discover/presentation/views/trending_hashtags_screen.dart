import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/image_strings.dart';
import '../widgets/hastags_subtitle_row.dart';
import '../widgets/render_trending_hashtag.dart';

class TrendingHashTagsScreen extends StatelessWidget {
  const TrendingHashTagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                title: Text(
                  ATStrings.trendingHashtags,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                elevation: 0,
                centerTitle: true,
                floating: true,
                leading: const ATRoundedBackBtn(),
              ),
              SliverList(
                  delegate: SliverChildListDelegate.fixed(<Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: HashTagsSubtitleRow(
                    hashTagTitle: ATStrings.society,
                    hashTagSubTitle:
                        'ankira22, glendonnor, and 15k other are live',
                    trailingOnpressed: () {
                      context.pushNamed(ATRoutes.SOCIETY_HASHTAG_SCREEN);
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 180,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(
                        5,
                        (_) => const RenderTrendingHashTag(
                              trendingPicture:
                                  ATImgStrings.weCanDoHardThingsBgImage,
                            )),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: HashTagsSubtitleRow(
                    trailingOnpressed: () {},
                    hashTagTitle: 'Katerinisback',
                    hashTagSubTitle: 'emmanuel, nnanna and 205 others are live',
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 180,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(
                        5,
                        (_) => const RenderTrendingHashTag(
                            trendingPicture: ATImgStrings.OFFICE_LADIES)),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: HashTagsSubtitleRow(
                    hashTagTitle: ATStrings.society,
                    hashTagSubTitle:
                        'ankira22, glendonnor, and 15k other are live',
                    trailingOnpressed: () {},
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 180,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(
                        5,
                        (_) => const RenderTrendingHashTag(
                              trendingPicture:
                                  ATImgStrings.weCanDoHardThingsBgImage,
                            )),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: HashTagsSubtitleRow(
                    trailingOnpressed: () {},
                    hashTagTitle: 'Katerinisback',
                    hashTagSubTitle: 'emmanuel, nnanna and 205 others are live',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 180,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(
                        5,
                        (_) => const RenderTrendingHashTag(
                            trendingPicture: ATImgStrings.OFFICE_LADIES)),
                  ),
                ),
                const SizedBox(
                  height: 60,
                )
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
