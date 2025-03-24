import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/profile/show_top_creator_societies.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/home_sub_view/profile/ordinary_user_profile.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/two_texts_rich_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../../utils/dialogs/go_live/follow_or_subscribe_dialog.dart';

class AmptiveCreatorProfileScreen extends StatelessWidget {
  const AmptiveCreatorProfileScreen({super.key});

  @override
  Widget build(context) {
    final tabIndex = ValueNotifier<int>(0);
    
    return ATAnnotatedRegion(
      statusBarColor: ATColors.trsprtColor,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              expandedHeight: 500.0, pinned: true,
              automaticallyImplyLeading: false,
              actions: [
                const Gap(15),
                AmptiveCircleAvatarWidget(
                  onTap: () => context.pop(),
                  diameter: 30, color: ATColors.black.withOpacity(0.7),
                  child: const Icon(Icons.keyboard_arrow_left),
                ),
                const Spacer(),
                Stack(
                  children: [
                    AmptiveCircleAvatarWidget(
                      onTap: () => context.pushNamed(ATRoutes.COMMUNITY_TASK_SCREEN),
                      //onTap: () => context.pushNamed(AmptiveRoutes.USER_PROFILE_SCREEN),
                      diameter: 30, color: ATColors.black.withOpacity(0.7),
                      child: const Icon(Iconsax.global, size: 20),
                    ),
                    Positioned(
                      right: 1, top: 1,
                      child: AmptiveCircleAvatarWidget(diameter: 8, color: ATColors.hexECO404,),
                    )
                  ],
                ),
                const Gap(15),
                AmptiveCircleAvatarWidget(
                  onTap: () => context.pushNamed(ATRoutes.PROFILE_MENU_SCREEN),
                  diameter: 30, color: ATColors.black.withOpacity(0.7),
                  child: const Icon(Icons.menu, size: 20),
                ),
                const Gap(15)
              ],
              backgroundColor: ATColors.black,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ATContainer(
                      decorationImagePath: ATImgStrings.weCanDoHardThingsBgImage,
                      height: 150,                
                      width: ATHelperFuncs.getScreenWidth(context),
                      child: GestureDetector(
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            ATContainer(
                              height: 150,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ATColors.black,
                                  ATColors.trsprtColor,
                                  ATColors.trsprtColor
                                ]
                              ),
                              width: ATHelperFuncs.getScreenWidth(context),
                              child: const SizedBox(),
                            ),
                            Positioned(
                              bottom: -35,
                              child: Hero(
                                tag: ATImgStrings.jpeg1,
                                child: ATCircularImage(
                                  onTap: () => context.pushNamed(
                                    ATRoutes.PROFILE_PIC_SCREEN,
                                    extra: ATImgStrings.jpeg1
                                  ),
                                  diameter: 70, addBorder: true,
                                  borderColor: ATColors.black,
                                  borderWidth: 3,
                                  imagePath: ATImgStrings.jpeg1
                                ),
                              )
                            ),
                            Positioned(
                              bottom: -35,
                              child: ATContainer(
                                color: ATColors.yellowColor1,
                                radius: 10,
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 1),
                                border: Border.all(color: ATColors.black, width: 2),
                                child: Text(
                                  ATStrings.CREATOR.toUpperCase(),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: ATFontSizes.size10,
                                    color: ATColors.black
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const Gap(50),
                
                    Text(
                      'Glennon Doyle',
                      style: Theme.of(context).textTheme.bodyLarge
                    ),
                    Text(
                      'Glennondoyle',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                
                    const Gap(20),
                
                    ATContainer(
                      onTap: (){
                        showTopCreatorSocietiesDialog(context);
                      },
                      border: Border.all(color: ATColors.hexC2C2C2.withOpacity(0.23)),
                      radius: 20,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ATColors.white.withOpacity(0.1),
                          ATColors.hex303030.withOpacity(0.1),
                          ATColors.white.withOpacity(0.1),
                        ]
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ATImgLoader(imgPath: ATImgStrings.TOP_CREATOR_BADGE),
                          const Gap(5),
                          Text(
                            ATStrings.TOP_CREATORS_IN_SOCIETY,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ATColors.hexEECEA0,
                              fontSize: ATFontSizes.size13
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    const Gap(20),
                
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => context.pushNamed(ATRoutes.PROFILE_FOLLOWING_SCREEN),
                          child: Row(
                            children: [
                              CustomPaint(
                                size: const Size(16, 16),
                                painter: RoundedScallopedPainter(
                                  color: ATColors.dimWhiteColor1
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Icon(Icons.star, color: ATColors.black, size: 12),
                                ),
                              ),
                              Text(
                                '1.1m',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: ATFontSizes.size16
                                ),
                              ),
                              const Gap(5),
                              Text(
                                ATStrings.FOLLOWERS,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: ATFontSizes.size16
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Gap(20),

                        GestureDetector(
                          onTap: () => context.pushNamed(ATRoutes.PROFILE_SUBSCRIBERS_SCREEN),
                          child: Row(
                            children: [
                              CustomPaint(
                                size: const Size(16, 16),
                                painter: RoundedScallopedPainter(
                                  color: ATColors.yellowColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Icon(Icons.favorite, color: ATColors.black, size: 12),
                                ),
                              ),
                              Text(
                                '150k',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: ATFontSizes.size16
                                ),
                              ),
                              const Gap(5),
                              Text(
                                ATStrings.SUBSCRIBERS,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: ATFontSizes.size16
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                
                    const Gap(20),
                
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: AmptiveMultipleTextsRichText(
                        items: {
                          'Author of UNTAMED & LOVE WARRIOR. Host of WE CAN DO HARD THINGS. Founder of'
                          : Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: ATFontSizes.size13
                          ),
                          ' @together_rising. ': Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: ATFontSizes.size13,
                            color: ATColors.hexC2C2C2
                          ),
                          'Includes an Oscar winner.': Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: ATFontSizes.size13
                          ),
                        },
                        textAlign: TextAlign.center,
                        textOnTap: (index){
                          if(index == 1){
                            print("Hello");
                          }
                        },
                      ),
                    ),
                
                    const Gap(20),
                
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.instagram, color: ATColors.hexC2C2C2, size: 15,),
                        const Gap(3),
                        Text(
                          ATStrings.INSTAGRAM,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ATColors.hexC2C2C2
                          ),
                        ),
                        const Gap(15),
                        const ATImgLoader(imgPath: ATImgStrings.X_LOGO),
                        const Gap(3),
                        Text(
                          'x',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ATColors.hexC2C2C2
                          ),
                        ),
                        const Gap(15),
                        FaIcon(FontAwesomeIcons.linkedin, color: ATColors.hexC2C2C2, size: 15),
                        const Gap(3),
                        Text(
                          ATStrings.LINKEDIN,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ATColors.hexC2C2C2
                          ),
                        ),
                        const Gap(15),
                        Transform.rotate(
                          angle: -0.9,
                          child: Icon(Icons.insert_link, color: ATColors.hexC2C2C2, size: 15),
                        ),
                        const Gap(3),
                        Text(
                          ATStrings.WEBSITE,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ATColors.hexC2C2C2
                          ),
                        ),
                      ],
                    ),
                
                    const Gap(15),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ATContainer(
                            alignment: Alignment.center, radius: 50,
                            margin: const EdgeInsets.only(left: 15),
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            color: ATColors.white.withOpacity(0.2),
                            child: Text(
                              ATStrings.EDIT_PROFILE,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: ATFontSizes.size14
                              )
                            )
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: ATContainer(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            margin: const EdgeInsets.only(right: 15),
                            alignment: Alignment.center, radius: 50,
                            color: ATColors.white.withOpacity(0.2),
                            child: Text(
                              ATStrings.SUBSCRIPTION,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: ATFontSizes.size14
                              )
                            )
                          ),
                        )
                      ]
                    ),                
                  ],
                ),
              ),
            ),


            SliverPersistentHeader(
              pinned: true,
              delegate: AmptiveTabBarDelegate(
                maxExt: 65, minExt: 65, rebuild: false,              
                child: ATContainer(
                  color: ATColors.black,             
                  child: AmptiveRebuilderWidget(
                    notifier: tabIndex,
                    shouldDispose: true,
                    builder: (_, value, __) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(        
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,            
                          children: [
                            const Gap(15),
                            ..._tabs.map(
                              (string){
                                final index = _tabs.indexOf(string);
                                final isSelected = index == value;
                                return ATContainer(
                                  curve: Curves.decelerate,
                                  alignment: Alignment.center, radius: 50,
                                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  margin: const EdgeInsets.fromLTRB(0, 10, 10, 20),
                                  color: isSelected ? ATColors.white : ATColors.black,
                                  border: !isSelected ? Border.all(
                                    color: ATColors.white.withOpacity(0.1),
                                    width: 2
                                  ) : null,
                                  onTap: () => tabIndex.value = index,
                                  child: Text(
                                    string,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: ATFontSizes.size13,
                                      color: isSelected ? ATColors.black : ATColors.white
                                    ),
                                  ),
                                );
                              }
                            )
                          ]
                        ),
                      );
                    }
                  ),
                ),
              ),
            )
          ],

          body:  AmptiveRebuilderWidget(
            notifier: tabIndex,
            builder: (_, index, __) {
              return IndexedStack(
                index: index,
                children: List.generate(
                  4,
                  (_) => ListView.builder(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 50),
                    itemCount: 10,
                    itemBuilder: (_, listIndex){
                      return const ProfileEventOrShowDisplay();
                    },
                  ),
                )
              );
            }
          ),
        ),
      ),
    );
  }
}






class ProfileEventOrShowDisplay extends StatelessWidget {
  const ProfileEventOrShowDisplay({super.key});

  @override
  Widget build(context) {
    return ATContainer(
      margin: const EdgeInsets.only(bottom: 15),
      height: 80,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: const ATImgLoader(
              imgPath: ATImgStrings.weCanDoHardThingsBgImage,
              height: 77, width: 77,
            ),
          ),
          const Gap(10),
      
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Row 1
                Row(
                  children: [
                    AmptiveCircleAvatarWidget(
                      diameter: 15,
                      color: ATColors.hexF91880,
                      child: const FittedBox(child: Text('S')),
                    ),
                    Text(
                      'We Can Do Hard Things',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size12,
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right_outlined, color: ATColors.hexC2C2C2, size: 20)
                  ],
                ),
                //Row 2
                Text(
                  maxLines: 2,
                  'How To Be More Alive With Cole Authur Riley (Best of Emmanuel Nnanna)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ATFontSizes.size15,
                  ),
                ),
      
                //Row 3
                Row(
                  children: [
                    ATContainer(
                      alignment: Alignment.center,
                      height: 10, width: 10, radius: 1,
                      color: ATColors.hexC2C2C2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'P',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: ATFontWeights.w800,
                            fontSize: ATFontSizes.size10,
                            color: ATColors.black
                          ),
                        )
                      ),
                    ),
                    const Gap(5),
                    Text(
                      'Society',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                    AmptiveCircleAvatarWidget(
                      diameter: 3,
                      color: ATColors.hexC2C2C2,
                    ),
                    
                    const Gap(5),
                    Text(
                      '15 JAN 2034 at 19:00',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



final _tabs = [
  ATStrings.SCHEDULED, ATStrings.ENDED,
  ATStrings.SHOWS, ATStrings.EVENTS
];