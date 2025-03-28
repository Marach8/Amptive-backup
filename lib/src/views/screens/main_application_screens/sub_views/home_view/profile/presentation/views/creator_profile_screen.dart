import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/profile/show_top_creator_societies.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:amptive/src/views/widgets/common_widgets/two_texts_rich_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../../../utils/dialogs/go_live/follow_or_subscribe_dialog.dart';
import '../../bloc/profile_bloc_export.dart';
import '../widgets/profile_widgets_export.dart';

class AmptiveCreatorProfileScreen extends StatelessWidget {
  const AmptiveCreatorProfileScreen({super.key});

  @override
  Widget build(context) {
    
    return ATAnnotatedRegion(
      statusBarColor: ATColors.trsprnt,
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
              backgroundColor: ATColors.black, stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CreatorProfilePix(),                    
                    const SizedBox(height: 50),
                
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
                
                    const SizedBox(height: 20),                
                    const CreatorBadge(),                
                    const SizedBox(height: 20),
                
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 20,
                      children: [
                        NoOfFollowers(noOfFollowers: '1.1m'),
                        NoOfSubscribers(),
                      ],
                    ),                
                    const SizedBox(height: 20),                
                    const _ProfileDesc(),
                
                    const SizedBox(height: 20),
                    const RowOfSocials(),                
                    const SizedBox(height: 15),
                
                    const EditProfileAndSubscriptionRow(),                
                  ],
                ),
              ),
            ),


            SliverPersistentHeader(
              pinned: true,
              delegate: ATSliverHDelegate(
                maxExt: 65, minExt: 65, rebuild: false,              
                child: ProfileScreenTabs(tabs: _tabs),
              ),
            )
          ],

          body: BlocBuilder<ProfileTabViewBloc, int>(
            builder: (_, state) {
              return IndexedStack(
                index: state,
                children: List.generate(
                  4,
                  (_) => ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 50),
                    itemCount: 10,
                    itemBuilder: (_, listIndex){
                      return ProfileEventOrShowDisplay(key: ValueKey('B$listIndex'),);
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


class _ProfileDesc extends StatelessWidget {
  const _ProfileDesc();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}


final _tabs = [
  ATStrings.SCHEDULED, ATStrings.ENDED,
  ATStrings.SHOWS, ATStrings.EVENTS
];