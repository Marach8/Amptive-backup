import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_widget_in_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../views/widgets/common_widgets/circular_image.dart';
import '../../../../views/widgets/common_widgets/divider_widget.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';
import '../../../../views/widgets/common_widgets/live_user_model_widget.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/appbar_drop_down.dart';
import '../widgets/go_live_widget_in_home.dart';


class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: context.read<ATNavBarBloc>().ctrlNavVisibility,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) => <Widget>[
          SliverAppBar(
            floating: true, snap: true, leadingWidth: 150,
            leading: const Padding(
              padding: EdgeInsets.only(left: 15),
              child: ATHomeDropDown(
                offset: Offset(0, 50),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ATImgLoader(
                      imgPath: ATImgStrings.AMPTIVE_NAME_LOGO,
                      height: 21, width: 86
                    ),
                    SizedBox(width: 4.0,),
                    Icon(Icons.keyboard_arrow_down_outlined, size: 25,),
                  ],
                ),
              ),
            ),
          
            actions: <Widget>[
              GestureDetector(
                onTap: (){
                  //context.pushNamed(ATRoutes.GO_LIVE_ONBOARDING);
                  context.pushNamed(ATRoutes.WALLET);
                  //context.pushNamed(ATRoutes.WALLET_ONBOARDING);
                },
                child: Stack(
                  children: <Widget>[
                    const ATImgLoader(
                      imgPath: ATImgStrings.WALLET_ICON, 
                      height: 30, width: 30,
                    ),
                    Positioned(
                      top: 5, right: 0,
                      child: ATCircleAvatar(diameter: 8, color: ATColors.hexECO404)
                    )
                  ],
                )
              ),
              const SizedBox(width: 24),
              GestureDetector(
                // onTap: (){
                //   context.pushReplacementNamed(
                //     ATRoutes.MAIN_GO_LIVE_PROGRAM,
                //     extra: GoLiveUserType.audience
                //   );
                // },
                onTap: () => context.pushNamed(ATRoutes.CREATOR_PROFILE_SCREEN),
                //onTap: () => context.pushNamed(ATRoutes.USER_PROFILE_SCREEN),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: BlocBuilder<LocalUserDataCubit, ATAppState<CachedUserData>>(
                    builder: (_, ATAppState<CachedUserData> state) {
                      final CachedUserData? userData = context.read<LocalUserDataCubit>().currentUserData;
                      return ATCircularImage(
                        imagePath: userData?.pictureUrl ?? ATImgStrings.jpeg2,
                      );
                    }
                  ),
                )
              ),
            ],      
          ),
        ],
         
        body: ListView( 
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 100,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children:<Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 11, right: 14),
                    child: GoLiveWidgetInHome(),
                  ),
                  ...Iterable<Widget>.generate(
                    20,
                    (_) => const Padding(
                      padding: EdgeInsets.only(right: 14),
                      child: LiveUserWidget(),
                    )
                  ),
                ]
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 14.0.h),
              child: const ATDivider(),
            ),
      
            ...Iterable<Widget>.generate(
              10,
              (_) => Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                child: GestureDetector(
                  onTap: () => context.pushNamed(ATRoutes.LIVE_EVENT_DETAILED),
                  //onTap: () => context.pushNamed(ATRoutes.LIVE_SHOW_DETAILED),
                  child: const ATShowOrEventInfo()
                ),
              )
            )
          ]
        )
      ),
    );
  }
}
