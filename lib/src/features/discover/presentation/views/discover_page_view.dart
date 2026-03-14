import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/cubits/trending_hashtags_cubit.dart';
import 'package:amptive/src/features/discover/data/models/response/trending_hashtags_response_model.dart';
import 'package:amptive/src/features/discover/presentation/widgets/follow_unfollow_dropdown.dart';
import 'package:amptive/src/features/discover/presentation/widgets/horizontal_scroll_cards.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../config/utils/other_strings.dart';
import '../widgets/hashtag_heading_row.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/full_discover_view_widgets/discover_categories_title.dart';
import '../widgets/community_card_widget.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/full_discover_view_widgets/more_to_discover_title.dart';
import '../widgets/hastags_subtitle_row.dart';
import '../widgets/trending_technology_widget.dart';
import '../widgets/top_creator_widget.dart';
import '../widgets/render_trending_hashtag.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';

class MainDiscoverView extends StatelessWidget {
  const MainDiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrendingHashtagsCubit>(
      create: (_) => TrendingHashtagsCubit()..fetchTrendingTags(),
      child: Column(
        children: <Widget>[
          const HorizontalScrollCards(),
          const SizedBox(height: 48),
          
          HastagHeadingRow(
            title: ATStrings.trendingHashtags,
            viewAllOnpressed: () {
              context.pushNamed(ATRoutes.TRENDING_HASHTAGS_SCREEN);
            },
          ),
          const SizedBox(height: 10),
      
          BlocBuilder<TrendingHashtagsCubit, ATAppState<TrendingTagsResponseModel>>(
            builder: (BuildContext context, ATAppState<TrendingTagsResponseModel> state) {
              final TrendingTagsResponseModel? hashtagsData = context.read<TrendingHashtagsCubit>().currentTrendingTags;
              final List<HashTag> trendingHashtags = hashtagsData?.trendingHashtag ?? <HashTag>[];
      
              if (trendingHashtags.isEmpty) {
                return const SizedBox.shrink();
              }
      
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: HashTagsSubtitleRow(
                      trailingOnpressed: () => context.pushNamed(ATRoutes.SOCIETY_HASHTAG_SCREEN),
                      hashTagTitle: trendingHashtags[0].name ?? '',
                      hashTagSubTitle: '${trendingHashtags[0].usageCount ?? 0} posts trending',
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      padding: const EdgeInsets.only(left: 15),
                      itemBuilder: (_, __) => const RenderTrendingHashTag(
                        trendingPicture: ATImgStrings.weCanDoHardThingsBgImage,
                      ),
                    ),
                  ),
                  Divider(indent: 15, endIndent: 15, color: ATColors.hex252525),
                  const SizedBox(height: 30),
      
                  if (trendingHashtags.length > 1) ...<Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: HashTagsSubtitleRow(
                        trailingOnpressed: () {},
                        hashTagTitle: trendingHashtags[1].name ?? '',
                        hashTagSubTitle: '${trendingHashtags[1].usageCount ?? 0} posts trending',
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 170,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        padding: const EdgeInsets.only(left: 15),
                        itemBuilder: (_, __) => const RenderTrendingHashTag(
                          trendingPicture: ATImgStrings.OFFICE_LADIES,
                        ),
                      ),
                    ),
                    Divider(indent: 15, endIndent: 15, color: ATColors.hex252525),
                  ],
                ],
              );
            },
          ),
      
          const SizedBox(height: 40),
      
          // Technology Section
          DiscoverCategoriesTile(
            categoryName: ATStrings.TECHNOLOGY,
            trailing: FollowUnfollowDropDown(
              text: ATStrings.FOLLOW,
              onSelected: (String po) {},
              popUpTrailingIcon: const Icon(Icons.add_circle_outline),
              child: Icon(
                Icons.more_horiz,
                color: ATColors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 300,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                const SizedBox(width: 5),
                ...List<Widget>.generate(
                  5,
                  (_) => const TrendingTechnologyWidget(
                    trendingPicture: ATImgStrings.ENDLESS_THREAD,
                  ),
                ),
              ],
            ),
          ),
          Divider(indent: 15, endIndent: 15, color: ATColors.hex252525),
          const SizedBox(height: 40),
      
          // Sports Section
          DiscoverCategoriesTile(
            categoryName: ATStrings.SPORTS,
            trailing: FollowUnfollowDropDown(
              text: ATStrings.UNFOLLOW,
              onSelected: (String po) {},
              popUpTrailingIcon: const Icon(Icons.remove_circle_outline),
              child: Icon(
                Icons.more_horiz,
                color: ATColors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 300,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                const SizedBox(width: 5),
                ...List<Widget>.generate(
                  5,
                  (_) => const TrendingTechnologyWidget(
                    trendingPicture: ATImgStrings.JOE_POMP_SHOW,
                  ),
                ),
              ],
            ),
          ),
          Divider(indent: 15, endIndent: 15, color: ATColors.hex252525),
          const SizedBox(height: 40),
      
          // True Crime Section
          DiscoverCategoriesTile(
            categoryName: ATStrings.TRUE_CRIME,
            trailing: FollowUnfollowDropDown(
              text: ATStrings.FOLLOW,
              onSelected: (String po) {},
              popUpTrailingIcon: const Icon(Icons.remove_circle_outline),
              child: Icon(
                Icons.more_horiz,
                color: ATColors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 300,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                const SizedBox(width: 5),
                ...List<Widget>.generate(
                  5,
                  (_) => const TrendingTechnologyWidget(
                    trendingPicture: ATImgStrings.CRIMINAL,
                  ),
                ),
              ],
            ),
          ),
          Divider(indent: 15, endIndent: 15, color: ATColors.hex252525),
          const SizedBox(height: 40),
      
          // More to Discover Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: AmptiveMore2DiscoverTitle(),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 122,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                const SizedBox(width: 5),
                ...List<Widget>.generate(
                  5,
                  (_) => const CommunityCardWidget(
                    picture: ATImgStrings.COMMUNITY_CARD,
                  ),
                ),
              ],
            ),
          ),
          Divider(indent: 15, endIndent: 15, color: ATColors.hex252525),
          const SizedBox(height: 40),
      
          // Top Creators Section
          ATContainer(
            padding: const EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              ATStrings.TOP_CREATORS,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 170,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List<Widget>.generate(
                5,
                (_) => const TopCreatorWidget(picture: ATImgStrings.MAN_PHOTO),
              ),
            ),
          ),
          const SizedBox(height: 48),
      
          // Spotlight Section
          ATContainer(
            padding: const EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              ATStrings.SPOTLIGHT,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 170,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                5,
                (_) => const RenderTrendingHashTag(
                  trendingPicture: ATImgStrings.OFFICE_LADIES,
                ),
              ),
            ),
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}
