import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/profile/bloc/profile_bloc_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../widgets/profile_widgets_export.dart';


class ATUserProfileScreen extends StatelessWidget {
  const ATUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      statusBarColor: ATColors.trsprnt,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (_, __) => <Widget>[
            SliverAppBar(
              expandedHeight: 340.0, pinned: true,
              automaticallyImplyLeading: false,
              actions: <Widget>[
                const SizedBox(width: 15),
                ATCircleAvatar(
                  onTap: () => context.pop(),
                  diameter: 30, color: ATColors.black.withValues(alpha:0.7),
                  child: const Icon(Icons.keyboard_arrow_left),
                ),
                const Spacer(),
                ATCircleAvatar(
                  onTap: () => context.pushNamed(ATRoutes.PROFILE_MENU_SCREEN),
                  diameter: 30, color: ATColors.black.withValues(alpha:0.7),
                  child: const Icon(Icons.menu, size: 20),
                ),
                const SizedBox(width: 15)
              ],
              backgroundColor: ATColors.black,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const UserBgProfileWidget(),
                    const SizedBox(height: 50),                 
                    Text(
                      'Emmanuel Marach',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 0.6,
                      )
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'nnannaemmanuel💖💝',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ATColors.hexC2C2C2, height: 0.8
                      ),
                    ),
                    const SizedBox(height: 20),                
                    const NoOfFollowers(noOfFollowers: '1.2k'),
                    const SizedBox(height: 15),
        
                    ATContainer(
                      onTap: () => context.pushNamed(ATRoutes.EDIT_PROFILE),
                      width: ATHelperFuncs.getScreenWidth(context),
                      alignment: Alignment.center, radius: 50,
                      margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      color: ATColors.white.withValues(alpha:0.2),
                      child: Text(
                        ATStrings.EDIT_PROFILE,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: ATSizes.size14
                        )
                      )
                    ),
                    const SizedBox(height: 15),     
                    Divider(
                      thickness: 1,
                      color: ATColors.white.withValues(alpha: 0.1),
                    ), 
                  ],
                ),
              ),
            ),


            //Header for sticky tab
            SliverPersistentHeader(
              pinned: true,
              delegate: ATSliverHDelegate(
                maxExt: 55, minExt: 55,             
                child: ProfileScreenTabs(tabs: _tabs),
              ),
            )
          ],

          body: BlocBuilder<ProfileTabViewBloc, int>(
            builder: (_, int state) {
              return IndexedStack(
                index: state,
                children: List.generate(
                  2,
                  (_) => ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
                    itemCount: 10,
                    itemBuilder: (_, int listIndex){
                      return ProfileEventOrShowDisplay(key: ValueKey('A$listIndex'),);
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

final List<String> _tabs = <String>[ATStrings.ATTENDED, ATStrings.UPCOMING];