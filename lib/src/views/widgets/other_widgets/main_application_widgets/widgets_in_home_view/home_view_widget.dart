import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/live_user_model_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/song_or_video_data_model_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/user_with_add_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveHomeViewWidget extends StatelessWidget {
  const AmptiveHomeViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: NestedScrollView(                
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            floating: true,
            expandedHeight: 114.h,
              
            flexibleSpace: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                 Padding(
                  padding: EdgeInsets.only(left: 10.62.w),
                  child: const AmptiveUserWithAddIconWidget(),
                ),
                ...Iterable.generate(
                  10,
                  (_) => Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(14.w),
                      const AmptiveLiveUserModelWidget()
                    ],
                  )
                )
              ]
            ),
    
            bottom:  TabBar(
              indicatorColor: AmptiveColors.indicatorDark,
              indicatorWeight: 1.h,
              tabs: const [
                Tab(text: AmptiveOtherStrings.empty,)
              ],
            ),            
          )
        ],
        
        body: TabBarView(
          children: [
            ListView(              
              padding: const EdgeInsets.only(left: 20, right: 20, top: 9),
              children: Iterable.generate(
                10,
                (_) => Container(
                  margin: EdgeInsets.only(bottom: 49.0.h),
                  child: const AmptiveSongOrVideoDataModelWidget(),
                )
              ).toList()
            ),
          ],
        )
      ),
    );
  }
}
