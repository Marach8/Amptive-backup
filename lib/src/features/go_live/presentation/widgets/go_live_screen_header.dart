import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/dialogs/go_live/host_view_of_top_gifters.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/views/widgets/animation_widgets/horiz_slider_animation.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/host_end_show_bloc.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../config/utils/dialogs/go_live/audience_view_of_to_gifters_dialog.dart';
import '../../../../config/utils/dialogs/go_live/host_end_show_dialog.dart';
import '../../../../config/utils/dialogs/go_live/host_view_of_listeners_dialog.dart';


class GoLiveScreenHeader extends StatelessWidget {
  const GoLiveScreenHeader({
    super.key,
    this.exitIcon
  });
  final Widget? exitIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[              
        exitIcon ?? ATContainer(
          onTap: (){
            context.read<AmptiveEndShowBloc>().add(
              Reset2IntialStateEvent()
            );
            showHostEndShowDialog(context: context);
            //context.read<AmptiveNavBarBloc>().goToPage(0),
          },
          border: Border.all(color: ATColors.black, width: 5),
          color: ATColors.hexECO404.withValues(alpha: 0.3),
          height: 35, width: 35, boxShape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ATColors.black,
              blurRadius: 5, spreadRadius: 10,
            )
          ],
          child: Icon(Icons.logout, color: ATColors.hexECO404, size: 20,),
        ),

        Expanded(
          child: LayoutBuilder(
            builder: (_, BoxConstraints kst) {
              return GoLiveProgramTitle(
                width: kst.maxWidth,
                slidingChildren: <Widget>[
                  Text(
                    ATStrings.LIVE,
                    style: context.textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 5),
                  const ATCircleAvatar(diameter: 5),
                  const SizedBox(width: 5),
                  Text(
                    "Don't Forget Who you are by the perkjdkakfkdkajdkakdjakfjdkajkdajkfdjkafkdakdfjkakfakjdfkajkfafakjkjk",
                    style: context.textTheme.bodyMedium?.copyWith(
                      overflow: TextOverflow.fade
                    ),
                  )
                ],
              );
            }
          ),
        ),
    
        _GiftingNdFollowing(
          onGiftTap: (){
            exitIcon == null ? showHostViewOfTopGiftersDialog(context)
              : showAudienceViewOfTopGiftersDialog(context);
          },
          onFollowersTap: (){
            if(exitIcon == null){
              showListenersDialog(context: context);
            }
            else{
              showListenersDialog(context: context, enableKickOut: false);
            }
          },
        ),
      ],
    );
  }
}



class _GiftingNdFollowing extends StatelessWidget {
  const _GiftingNdFollowing({
    required this.onGiftTap,
    required this.onFollowersTap
  });

  final VoidCallback? onGiftTap, onFollowersTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: ATColors.black,
          blurRadius: 35, spreadRadius: 20,
          offset: const Offset(-20, 0)
        )
      ],
      child: Row(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              ATContainer(
                onTap: onGiftTap, radius: 30,
                padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                color: ATColors.white.withValues(alpha: 0.1),
                child: Row(
                  children: <Widget>[
                    Text(
                      "🎁",
                      style: context.textTheme.bodyMedium?.copyWith(
                        overflow: TextOverflow.fade
                      ),
                    ),
                    const Gap(5),
                    Text(
                      "Gift",
                      style: context.textTheme.bodyMedium?.copyWith(
                        overflow: TextOverflow.fade
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -2, right: 4,
                child: ATCircleAvatar(diameter: 6, color: ATColors.hexECO404)
              )
            ],
          ),
      
          const SizedBox(width: 10,),
              
          ATContainer(
            onTap: onFollowersTap,
            padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
            radius: 30,
            color: ATColors.white.withValues(alpha: 0.1),
            child: Row(
              children: <Widget>[
                const ATImgLoader(imgPath: ATImgStrings.USER_ICON),
                Text(
                  "144k",
                  style: context.textTheme.bodyMedium?.copyWith(
                    overflow: TextOverflow.fade
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
