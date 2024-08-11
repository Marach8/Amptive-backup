import 'package:amptive/src/utils/dialogs/full_audio_or_video_detail_snackbar_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/song_or_video_data_model_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/bottom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../common_widgets/circular_container_with_picture_widget.dart';
import '../../../common_widgets/image_loader_widget.dart';
import 'appbar_pop_drop_down.dart';


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

    return NestedScrollView(
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
              onTap: (){//context.pushNamed(AmptiveRoutes.newScreen);
              },
              child: const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.walletIcon, height: 30, width: 30,)
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
          
          bottom: const AmptiveLiveUsersListView(),
                
        )
      ],
       
      body: ListView(              
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
      )
    );
  }
}
