import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/profile/data/models/request/upgrade_account_data.dart';
import 'package:amptive/src/features/upgrade_account/cubits/select_category_cubit.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/select_acct_type_screen.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/subscription_plan_screen.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/radio_button.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SelectCategoryScreen extends StatelessWidget {
  const SelectCategoryScreen({super.key, required this.acctType});

  final AccountType acctType;

  static const List<String> creatorCategories = <String>[
    'AI & Machine Learning',
    'Activism & Social Justice',
    'Advertising & PR Trends',
    'Ancient Civilizations & Lost Cultures',
    'Anime & Animation',
    'Astrology & Horoscopes',
    'Athlete Stories',
    'Audio Storytelling & Narration',
    'Beauty & Skincare Tips',
    'Behind-the-Scenes & Film Industry',
    'Biographies & Great Leaders',
    'Bilingual & Multicultural Talks',
    'Blockchain & Web3',
    'Bodybuilding & Fitness',
    'Breaking News & Global Events',
    'Business & Economy News',
    'Business Startups & Funding',
    'Career Growth & Leadership',
    'Celebrity & Influencer News',
    'Coding & Software Development',
    'Comedy & Skits',
    'Conspiracy Theories',
    'Content Creation & Monetization',
    'Cooking & Food Discussions',
    'Criminal Psychology & Profiling',
    'Crypto & Web3',
    'Cultural Discussions & Heritage',
    'Cybersecurity & Hacking',
    'Dating & Love Life',
    'Designing & Branding',
    'Digital Art & NFTs',
    'DIY & Crafts',
    'Documentaries & Investigative Stories',
    'Drama, Romance & Mystery',
    'Education & Learning',
    'Esports & Competitive Gaming',
    'Esports & Gaming Culture',
    'Fact-Checking & Misinformation',
    'Family & Relationship Dynamics',
    'Fan Theories & Fandoms',
    'Fashion Industry & Designer Talks',
    'Fashion Trends & Outfit Inspiration',
    'Financial Literacy & Money Management',
    'Football (Soccer)',
    'Friendship & Social Skills',
    'Fun & Educational Kids Content',
    'Funny Life Experiences',
    'Game Reviews & Industry News',
    'Game Streaming & Playthroughs',
    'Gadgets & Consumer Tech',
    'Generational & Lifestyle Talks',
    'Graphic Design & Branding',
    'Health & Wellness',
    'Historical True Crime Stories',
    'History & Ancient Civilizations',
    'Horror & Thriller Audio Stories',
    'Internet Memes & Trends',
    'Investing & Financial Freedom',
    'Journalism & Investigative Reporting',
    'Language & Cultural Exchange',
    'Language Learning & Linguistics',
    'Life Coaching & Self-Improvement',
    'Life Experiences & Personal Growth',
    'Life Hacks & Productivity Tips',
    'Live Performances & Jam Sessions',
    'Marketing & Social Media Growth',
    'Marriage & Family',
    'Mental Health & Wellbeing',
    'Mindfulness & Meditation',
    'Movie Reviews & Discussions',
    'Music Commentary & Reviews',
    'Music Industry & Artist Talks',
    'Music Production & Songwriting',
    'Mythology & Folklore',
    'Nutrition & Dieting',
    'Paranormal & Mysticism',
    'Parenting & Child Development',
    'Personal Branding & Influence',
    'Philosophy & Deep Discussions',
    'Photography & Videography',
    'Political Debates & Opinions',
    'Politics & Government',
    'Pop Culture & Trending Topics',
    'Pregnancy & Newborn Care',
    'Psychology & Human Behavior',
    'Relationship Science & Psychology',
    'Religious & Faith-Based Talks',
    'Retro & Classic Games',
    'Roleplay & Interactive Stories',
    'Sci-Fi & Fantasy Audio Stories',
    'Screenwriting & Storytelling',
    'Self-Care & Mental Wellbeing',
    'Side Hustles & Freelancing',
    'Singing & Vocal Performances',
    'Slang, Idioms & Expressions',
    'Social Media Growth & Strategies',
    'Space & Astronomy',
    'Spirituality & Manifestation',
    'Sports Medicine & Recovery',
    'Stand-up Comedy & Roasting',
    'Startup Stories & Founder Advice',
    'Sustainable Fashion & Ethical Brands',
    'Teaching & Raising Children',
    'Tech & Science News',
    'Technology & Innovation',
    'Therapy & Coping Strategies',
    'TV Show Discussions & Recaps',
    'Unsolved Mysteries & Cold Cases',
    'Viral Trends & Digital Culture',
    'Virtual Reality (VR) & Metaverse',
    'War & Political History',
    'Workout Routines & Tips',
    'Others',
  ];

  static const List<String> businessCategories = <String>[
    'Art & Crafts',
    'Automotive & Transportation',
    'Baby',
    'Beauty',
    'Clothing & Accessories',
    'Education & Training',
    'Electronics',
    'Finance & Investing ',
    'Food & Beverage',
    'Gaming',
    'Health & Wellness',
    'Home, Furniture & Appliances',
    'Machinery & Equipment',
    'Media & Entertainment',
    'Personal Blog',
    'Pets',
    'Professional Services',
    'Public Administration',
    'Real Estate',
    'Restaurants & Bars',
    'Shopping & Retail',
    'Software & Apps',
    'Sports, Fitness & Outdoors',
    'Travel & Tourism',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isCreator = acctType == AccountType.creator;
    final List<String> activeCategories =
        isCreator ? creatorCategories : businessCategories;

    return BlocProvider<SelectCategoryCubit>(
      create: (_) => SelectCategoryCubit(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: ATAppBar(
            leadingWidth: 30,
            padding: const EdgeInsets.only(left: 7),
            leading: const ATRoundedBackBtn(),
            titleText: isCreator
                ? ATStrings.amptiveForCreators
                : ATStrings.amptiveForBusiness,
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Text(
                        ATStrings.selectCategory,
                        style: context.textTheme.headlineLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 20),
                      child: Text(
                        ATStrings.selectCategoryDesc,
                        maxLines: 2,
                        style: context.textTheme.titleMedium
                            ?.copyWith(color: ATColors.hexCDCDCD),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: ATSliverHDelegate(
                  maxExt: 60,
                  minExt: 60,
                  child: Material(
                    color: ATColors.black,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(13, 0, 15, 20),
                      child: BlocSelector<SelectCategoryCubit,
                          SelectCategoryParams, String>(
                        selector: (SelectCategoryParams state) =>
                            state.searchQuery,
                        builder: (
                          BuildContext context,
                          String searchQuery,
                        ) {
                          return ATTextFormField(
                            onChanged: (String input) {
                              context
                                  .read<SelectCategoryCubit>()
                                  .updateSearchQuery(input);
                            },
                            textInputAction: TextInputAction.done,
                            hintText: ATStrings.search4Category,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: ATImgLoader(
                                height: 25,
                                width: 25,
                                color: ATColors.white,
                                imgPath: ATImgStrings.outlinedSearch,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              BlocSelector<SelectCategoryCubit, SelectCategoryParams,
                  List<String>>(
                selector: (SelectCategoryParams state) {
                  final String normalizedSearchQuery = state.searchQuery.trim();

                  if (normalizedSearchQuery.isEmpty) {
                    return activeCategories;
                  }

                  return activeCategories
                      .where(
                        (String category) => category
                            .toLowerCase()
                            .contains(normalizedSearchQuery.toLowerCase()),
                      )
                      .toList();
                },
                builder: (BuildContext context, List<String> categories) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, int index) {
                        final String category = categories[index];

                        return BlocSelector<SelectCategoryCubit,
                            SelectCategoryParams, String?>(
                          selector: (SelectCategoryParams state) =>
                              state.selectedCategory,
                          builder: (
                            BuildContext context,
                            String? selectedCategory,
                          ) {
                            final bool isSelected =
                                selectedCategory == category;

                            return ATContainer(
                              onTap: () {
                                context
                                    .read<SelectCategoryCubit>()
                                    .selectCategory(
                                      isSelected ? null : category,
                                    );
                              },
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 18, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      category,
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(fontSize: 16),
                                    ),
                                  ),
                                  ATRadioBtn(isSelected: isSelected),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      childCount: categories.length,
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          bottomSheet:
              BlocSelector<SelectCategoryCubit, SelectCategoryParams, String?>(
            selector: (SelectCategoryParams state) => state.selectedCategory,
            builder: (BuildContext context, String? selectedCategory) {
              final double bottomInset =
                  MediaQuery.viewInsetsOf(context).bottom;
              final double bottom = bottomInset == 0 ? 50.0 : 15.0;

              return Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, bottom),
                child: ATPlainElevatedBtn(
                  onPressed: selectedCategory == null
                      ? null
                      : () {
                          UpgradeProfileData().copyWith(
                            category: selectedCategory,
                          );

                          const SubscriptionPlanData incoming =
                              SubscriptionPlanData(
                            entryPoint:
                                SubPlanScreenEntryPoint.creatorProfileSetup,
                          );

                          context.pushNamed(
                            ATRoutes.subPlanSetupScreen,
                            extra: incoming,
                          );
                        },
                  btnTitle: ATStrings.setupSubPlan,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
