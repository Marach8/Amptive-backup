import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/dialogs/full_audio_or_video_detail_snackbar_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/live_user_model_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/song_or_video_data_model_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/user_with_add_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';


class AmptiveHomeViewWidget extends StatefulWidget {
  const AmptiveHomeViewWidget({
    super.key,
  });

  @override
  State<AmptiveHomeViewWidget> createState() => _AmptiveHomeViewWidgetState();
}

class _AmptiveHomeViewWidgetState extends State<AmptiveHomeViewWidget> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override 
  void initState(){
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2)
    );

    _animation = Tween<double>(
      begin: 0, end: 50
    ).animate( //_animationController
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn
      )
    );
  }

  @override 
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }

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
                  20,
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
    
            bottom: TabBar(
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
              padding: const EdgeInsets.fromLTRB(20, 9, 20, 0),
              children: Iterable.generate(
                10,
                (_) => Container(
                  margin: EdgeInsets.only(bottom: 49.0.h),
                  child: GestureDetector(
                    onTap: () => showAudioOrVideoFullDetails(
                      context: context,
                      snackBarAnimation: _animation,
                      controller: _animationController
                    ),
                    child: const AmptiveSongOrVideoDataModelWidget()
                  ),
                )
              ).toList()
            ),
          ],
        )
      ),
    );
  }
}
