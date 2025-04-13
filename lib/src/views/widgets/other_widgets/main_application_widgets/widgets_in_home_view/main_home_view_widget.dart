import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/show_or_event_data_model_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../common_widgets/circular_image.dart';
import '../../../common_widgets/divider_widget.dart';
import '../../../common_widgets/image_loader_widget.dart';
import '../../../common_widgets/live_user_model_widget.dart';
import 'appbar_drop_down.dart';
import 'user_go_live_widget.dart';

class AmptiveHomeViewWidget extends StatelessWidget {
  const AmptiveHomeViewWidget({super.key});

  @override
  Widget build(context) {
    return SafeArea(
      child: NestedScrollView(
        floatHeaderSlivers: true,
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            floating: true, snap: true,
            leadingWidth: 150.w,
            leading: const Padding(
              padding: EdgeInsets.only(left: 15),
              child: ATHomeDropDown(
                offset: Offset(0, 50),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ATImgLoader(imgPath: ATImgStrings.logo2, height: 20.906, width: 86.32,),
                    Gap(4.0),
                    Icon(Icons.keyboard_arrow_down_outlined, size: 25,),
                  ],
                ),
              ),
            ),
          
            actions: [
              GestureDetector(
                onTap: (){},
                child: Stack(
                  children: [
                    const ATImgLoader(
                      imgPath: ATImgStrings.walletIcon, 
                      height: 30, width: 30,
                    ),
                    Positioned(
                      top: 5, right: 0,
                      child: ATCircleAvatar(diameter: 8, color: ATColors.hexECO404)
                    )
                  ],
                )
              ),
              const Gap(24),
              GestureDetector(
                onTap: () => context.pushNamed(ATRoutes.CREATOR_PROFILE_SCREEN),
                //onTap: () => context.pushNamed(ATRoutes.USER_PROFILE_SCREEN),
                child: const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: ATCircularImage(
                    imagePath: ATImgStrings.jpeg2,
                  ),
                )
              ),
            ],      
          ),
        ],
         
        body: ListView( 
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 100,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 11.w, right: 14.w),
                    child: const AmptiveUserGoLiveWidget(),
                  ),
                  ...Iterable.generate(
                    20,
                    (_) => Padding(
                      padding: EdgeInsets.only(right: 14.w),
                      child: const ATLiveUser(),
                    )
                  ),
                ]
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 14.0.h),
              child: const ATDivider(),
            ),

            ...Iterable.generate(
              10,
              (_) => Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                child: GestureDetector(
                  onTap: () => context.pushNamed(ATRoutes.showDetailedScreen),
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
