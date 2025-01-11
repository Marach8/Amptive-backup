import 'package:amptive/src/bloc/main_app/nav_bar_bloc.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/routes.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/add_co_host_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/horiz_slider_animation.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../../services/create_show/create_show_service.dart';
import '../../../../../services/go_live_service/go_live_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import 'dart:developer' as marach show log;
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_or_cohost_widget.dart';



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
                "Don't Forget Who you are by glennodyle",
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
            onTap: () => context.read<AmptiveNavBarBloc>().goToPage(0),
            color: AmptiveColors.notifRed.withValues(alpha: 0.3),
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
                  onTap: (){
                  },
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
                  padding: const EdgeInsets.all(5),
                  radius: 30,
                  color: AmptiveColors.whiteColor.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      const Icon(Iconsax.user, size: 15),
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