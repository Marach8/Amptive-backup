import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/song_or_video_data_model_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../common_widgets/circular_container_with_picture_widget.dart';
import '../../../common_widgets/container_for_rendering_other_widgets.dart';
import '../../../common_widgets/image_loader_widget.dart';
import '../../../common_widgets/live_user_model_widget.dart';
import 'appbar_drop_down.dart';
import 'user_with_add_icon_widget.dart';


class AmptiveHomeViewWidget extends StatelessWidget {
  const AmptiveHomeViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            floating: true,
            centerTitle: false,   
            leadingWidth: 150.w,
            leading: const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.logo2, height: 20.906, width: 86.32,),
                  Gap(4.0),
                  AmptiveAppBarDropDownWidget()
                ],
              ),
            ),
          
            actions: [
              GestureDetector(
                onTap: (){},
                child: const AmptiveImageLoaderWidget(
                  imagePath: AmptiveImageStrings.walletIcon, 
                  height: 30, width: 30,
                )
              ),
              const Gap(24),
              GestureDetector(
                onTap: (){},
                child: const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: AmptiveCircularContainerWithPictureWidget(
                    imagePath: AmptiveImageStrings.jpeg2,
                  ),
                )
              ),
            ],      
          ),

          // SliverPersistentHeader(
          //   pinned: true,
          //   delegate: AmptiveSliverHeader()
          // )
        ],
         
        body: ListView(              
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 100,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.62.w),
                    child: const AmptiveUserWithAddIconWidget(),
                  ),
                  ...Iterable.generate(
                    20,
                    (_) => Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(14.w),
                        const AmptiveLiveUserModelWidget()
                      ],
                    )
                  ),
                ]
              ),
            ),
            AmptiveCustomContainer(
              color: AmptiveColors.whiteColor,
              height: 0.15,
              width: double.infinity,
              child: const SizedBox.shrink(),
            ),

            ...Iterable.generate(
              10,
              (_) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: GestureDetector(
                  onTap: () => context.pushNamed(AmptiveRoutes.showDetailedScreen),
                  child: const AmptiveSongOrVideoDataModelWidget()
                ),
              )
            )
          ]
        )
      ),
    );
  }
}
