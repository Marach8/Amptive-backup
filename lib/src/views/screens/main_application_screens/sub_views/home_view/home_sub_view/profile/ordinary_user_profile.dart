import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../utils/dialogs/go_live/follow_or_subscribe_dialog.dart';
import 'creator_profile.dart';



class AmptiveOrdinaryUserProfileScreen extends StatelessWidget {
  const AmptiveOrdinaryUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabIndex = ValueNotifier(0);

    return AmptiveAnnotatedRegionWidget(
      statusBarColor: AmptiveColors.transparentColor,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              expandedHeight: 340.0, pinned: true,
              leading:  AmptiveCircleAvatarWidget(
                onTap: () => context.pop(),
                diameter: 30, color: AmptiveColors.black.withOpacity(0.7),
                child: const Icon(Icons.keyboard_arrow_left),
              ),
              automaticallyImplyLeading: false,
              leadingWidth: 30,
              actions: [
                AmptiveCircleAvatarWidget(
                  diameter: 30, color: AmptiveColors.black.withOpacity(0.7),
                  child: const Icon(Icons.menu, size: 20),
                ),
              ],
              backgroundColor: AmptiveColors.black,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AmptiveCustomContainer(
                      color: AmptiveColors.whiteColor.withOpacity(0.5),
                      height: 150,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AmptiveColors.black,
                          AmptiveColors.whiteColor.withOpacity(0.5),
                          AmptiveColors.hexD9D9D9
                        ]
                      ),
                      width: AmptiveHelperFunctions.getScreenWidth(context),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            bottom: -35,
                            child: AmptiveCircularContainerWithPictureWidget(
                              diameter: 70, addBorder: true,
                              borderColor: AmptiveColors.black,
                              borderWidth: 3,
                              imagePath: AmptiveImageStrings.jpeg2
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
                        color: AmptiveColors.hexC2C2C2
                      ),
                    ),
                    const Gap(20),
                
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomPaint(
                          size: const Size(16, 16),
                          painter: RoundedScallopedPainter(
                            color: AmptiveColors.dimWhiteColor1
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Icon(Icons.star, color: AmptiveColors.black, size: 12),
                          ),
                        ),
                        Text(
                          '1.2k',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: AmptiveFontSizes.size16
                          ),
                        ),
                        const Gap(5),
                        Text(
                          AmptiveStrings.FOLLOWERS,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: AmptiveFontSizes.size16
                          ),
                        ),                
                      ],
                    ),
                    const Gap(20),
        
                    AmptiveCustomContainer(
                      onTap: (){},
                      width: AmptiveHelperFunctions.getScreenWidth(context),
                      alignment: Alignment.center, radius: 50,
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      color: AmptiveColors.whiteColor.withOpacity(0.2),
                      child: Text(
                        AmptiveStrings.EDIT_PROFILE,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: AmptiveFontSizes.size14
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
              delegate: AmptiveTabBarDelegate(
                maxExt: 65, minExt: 65, rebuild: false,
                child: AmptiveCustomContainer(
                  color: AmptiveColors.black,              
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
                              return AmptiveCustomContainer(
                                curve: Curves.decelerate,
                                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                margin: const EdgeInsets.fromLTRB(0, 10, 10, 20),
                                alignment: Alignment.center, radius: 50,
                                border: !isSelected ? Border.all(
                                  color: AmptiveColors.whiteColor.withOpacity(0.1),
                                  width: 2
                                ) : null,
                                color: isSelected ? AmptiveColors.whiteColor : AmptiveColors.black,
                                onTap: () => tabIndex.value = index,
                                child: Text(
                                  string,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: AmptiveFontSizes.size13,
                                    color: isSelected ? AmptiveColors.black : AmptiveColors.whiteColor
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

// TabBar delegate for sticky tabs
class AmptiveTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final bool rebuild;
  final double minExt, maxExt;

  AmptiveTabBarDelegate({
    required this.child,
    required this.maxExt,
    required this.minExt,
    required this.rebuild
  });

  @override
  double get minExtent => minExt;

  @override
  double get maxExtent => maxExt;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return rebuild;
  }
}



final _tabs = [AmptiveStrings.ATTENDED, AmptiveStrings.UPCOMING];