import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../utils/dialogs/go_live/follow_or_subscribe_dialog.dart';
import 'creator_profile.dart';



class ATUserProfileScreen extends StatelessWidget {
  const ATUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabIndex = ValueNotifier(0);

    return ATAnnotatedRegion(
      statusBarColor: ATColors.trsprtColor,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              expandedHeight: 340.0, pinned: true,
              automaticallyImplyLeading: false,
              actions: [
                const Gap(15),
                AmptiveCircleAvatarWidget(
                  onTap: () => context.pop(),
                  diameter: 30, color: ATColors.black.withOpacity(0.7),
                  child: const Icon(Icons.keyboard_arrow_left),
                ),
                const Spacer(),
                AmptiveCircleAvatarWidget(
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
                      color: ATColors.white.withOpacity(0.5),
                      height: 150,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ATColors.black,
                          ATColors.white.withOpacity(0.5),
                          ATColors.hexD9D9D9
                        ]
                      ),
                      width: ATHelperFuncs.getScreenWidth(context),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            bottom: -35,
                            child: ATCircularImage(
                              diameter: 70, addBorder: true,
                              borderColor: ATColors.black,
                              borderWidth: 3,
                              imagePath: ATImgStrings.jpeg2
                            )
                          ),
                        ],
                      ),
                    ),
                    
                    const Gap(40),
                
                    Text(
                      'Alieu Baba',
                      style: Theme.of(context).textTheme.bodyLarge
                    ),
                    Text(
                      'alieubaba',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                    const Gap(20),
                
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                          '1.2k',
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
                    const Gap(20),
        
                    ATContainer(
                      onTap: (){},
                      width: ATHelperFuncs.getScreenWidth(context),
                      alignment: Alignment.center, radius: 50,
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      color: ATColors.white.withOpacity(0.2),
                      child: Text(
                        ATStrings.EDIT_PROFILE,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: ATFontSizes.size14
                        )
                      )
                    ),
                  ],
                ),
              ),
            ),


            //Header for sticky tab
            SliverPersistentHeader(
              pinned: true,
              delegate: ATSliverHDelegate(
                maxExt: 65, minExt: 65, rebuild: false,
                child: ATContainer(
                  color: ATColors.black,              
                  child: AmptiveRebuilderWidget(
                    notifier: tabIndex,
                    shouldDispose: true,
                    builder: (_, value, __) {
                      return Row(        
                        mainAxisAlignment: MainAxisAlignment.start,            
                        children:[
                          const Gap(15),
                          ..._tabs.map(
                            (string){
                              final index = _tabs.indexOf(string);
                              final isSelected = index == value;
                              return ATContainer(
                                curve: Curves.decelerate,
                                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                margin: const EdgeInsets.fromLTRB(0, 10, 10, 20),
                                alignment: Alignment.center, radius: 50,
                                border: !isSelected ? Border.all(
                                  color: ATColors.white.withOpacity(0.1),
                                  width: 2
                                ) : null,
                                color: isSelected ? ATColors.white : ATColors.black,
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
                      );
                    }
                  ),
                ),
              ),
            ),
          ],

          body:  AmptiveRebuilderWidget(
            notifier: tabIndex,
            builder: (_, index, __) {
              return IndexedStack(
                index: index,
                children: List.generate(
                  2,
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


final _tabs = [ATStrings.ATTENDED, ATStrings.UPCOMING];