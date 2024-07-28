import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar.dart';
import 'package:amptive/src/views/widgets/common_widgets/container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/live_user_model_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/svg_asset_loader_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/appbar_pop_drop_down.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/song_or_video_data_model_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/user_with_add_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';


class AmptiveHomeScreen extends StatelessWidget {
  const AmptiveHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          centerTitle: false,
          leadingWidth: 150.w,
          leading: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AmptiveSvgAssetLoaderWidget(svgPath: AmptiveImageStrings.svgLogo2),
              AmptiveAppBarDropDownWidget()
            ],
          ),

          actions: [
            GestureDetector(
              onTap: (){},
              child: const AmptiveSvgAssetLoaderWidget(svgPath: AmptiveImageStrings.svgWalletIcon)
            ),
            const Gap(20),
            GestureDetector(
              onTap: (){},
              child: const AmptiveCircularContainerWithPIctureWidget(
                imagePath: AmptiveImageStrings.jpeg2,
              )
            ),
          ],
        ),


        body: DefaultTabController(
          length: 1,
          child: NestedScrollView(                
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                floating: true,
                expandedHeight: 0,
                  
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    padding: EdgeInsets.zero,   
                    shrinkWrap: true,      
                    scrollDirection: Axis.horizontal,
                    children: [
                      const AmptiveUserWithAddIconWidget(),
                      ...Iterable.generate(
                        50,
                        (_) => Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(20.w),
                            const AmptiveLiveUserModelWidget()
                          ],
                        )
                      )
                    ]
                  ),
                ),

                bottom: const TabBar(
                  tabs: [
                    Tab(text: AmptiveOtherStrings.emptyString,)
                  ],
                ),
                
              )
            ],
            
            body: TabBarView(
              children: [
                ListView(              
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: Iterable.generate(
                    10,
                    (_) => const AmptiveSongOrVideoDataModelWidget()
                  ).toList()
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}