import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/go_live/host_view_of_top_gifters.dart';
import 'package:amptive/src/views/widgets/animation_widgets/horiz_slider_animation.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../bloc/main_app/go_live_bloc/host_view/host_end_show_bloc.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../utils/dialogs/go_live/audience_view_of_to_gifters.dart';
import '../../../../../utils/dialogs/go_live/host_end_show_dialog.dart';
import '../../../../../utils/dialogs/go_live/host_view_of_listeners_dialog.dart';



class AmptiveLiveViewHeaderWidget extends StatelessWidget {
  final Widget? exitIcon;
  const AmptiveLiveViewHeaderWidget({
    super.key,
    this.exitIcon
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        AmptiveHorizSliderAnimationWidget(
          duration: 15.w,
          child: Row(
            children: [
              Text(
                AmptiveOtherStrings.LIVE,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Gap(5.w),
              const AmptiveCirceAvatarWidget(diameter: 5),
              Gap(5.w),
              Text(
                // maxLines: 1,
                "Don't Forget Who you are by ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  overflow: TextOverflow.fade
                ),
              )
            ],
          ),
        ),
              
        Positioned(
          left: 15,
          /// The default is for the host view. provide the exitIcon when calling for other views
          child: exitIcon ?? AmptiveCustomContainer(
            onTap: (){
              context.read<AmptiveEndShowBloc>().add(
                Reset2IntialStateEvent()
              );
              showHostEndShowDialog(context: context);
              //context.read<AmptiveNavBarBloc>().goToPage(0),
            },
            color: AmptiveColors.notifRed.withOpacity(0.3),
            height: 35, width: 35, boxShape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AmptiveColors.black,
                blurRadius: 10, spreadRadius: 30,
                offset: const Offset(-20, 0)
              )
            ],
            child: Icon(Icons.logout, color: AmptiveColors.notifRed),
          ),
        ),
    
        Positioned(
          right: 15,
          child: AmptiveCustomContainer(
            boxShadow: [
              BoxShadow(
                color: AmptiveColors.black,
                blurRadius: 10, spreadRadius: 30,
                offset: const Offset(20, 0)
              )
            ],
            child: Row(
              children: [
                AmptiveCustomContainer(
                  onTap: () => exitIcon == null ? showHostViewOfTopGiftersDialog(context)
                    : showAudienceViewOfTopGiftersDialog(context),
                  padding: const EdgeInsets.all(5),
                  radius: 30,
                  color: AmptiveColors.whiteColor.withOpacity(0.1),
                  child: Row(
                    children: [
                      Text(
                        "🎁",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          overflow: TextOverflow.fade
                        ),
                      ),
                      const Gap(5),
                      Text(
                        "Gift",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          overflow: TextOverflow.fade
                        ),
                      ),
                    ],
                  ),
                ),
            
                Gap(10.w),
                    
                AmptiveCustomContainer(
                  onTap: (){
                    if(exitIcon == null){
                      showListenersDialog(context: context);
                    }
                    else{
                      showListenersDialog(context: context, enableKickOut: false);
                    }
                  },
                  padding: const EdgeInsets.all(5),
                  radius: 30,
                  color: AmptiveColors.whiteColor.withOpacity(0.1),
                  child: Row(
                    children: [
                      const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.USER_ICON),
                      Text(
                        "144k",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          overflow: TextOverflow.fade
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}