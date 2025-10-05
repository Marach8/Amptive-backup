import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/show_event_nd_paid_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';

class ProfileEventOrShowDisplay extends StatelessWidget {
  const ProfileEventOrShowDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: (){
        //context.pushNamed(ATRoutes.LIVE_SHOW_DETAILED);
      },
      margin: const EdgeInsets.fromLTRB(15, 12, 15, 12),
      height: 80, radius: 0,
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: const ATImgLoader(
              imgPath: ATImgStrings.weCanDoHardThingsBgImage,
              height: 77, width: 77,
            ),
          ),
          const SizedBox(width: 10),
      
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //Row 1
                Row(
                  children: <Widget>[
                    const ATShowIcon(),
                    const SizedBox(width: 5,),
                    Flexible(
                      child: Text(
                        'We Can Do Hard Things',
                        style: context.textTheme.bodySmall?.copyWith(
                          fontSize: ATSizes.size12,
                          color: ATColors.hexC2C2C2
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right_outlined, color: ATColors.hexC2C2C2, size: 20)
                  ],
                ),
                //Row 2
                Text(
                  maxLines: 2,
                  'How To Be More Alive With Cole Authur Riley (Best of Emmanuel Nnanna)',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: ATSizes.size15,
                  ),
                ),
      
                //Row 3
                Row(
                  children: <Widget>[
                    ATPaidIndicatorIcon(
                      size: 10, radius: 1,
                      color: ATColors.hexC2C2C2
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      'Society',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                    const SizedBox(width: 5,),
                    ATCircleAvatar(
                      diameter: 3,
                      color: ATColors.hexC2C2C2,
                    ),
                    
                    const SizedBox(width: 5,),
                    Text(
                      '15 JAN 2034 at 19:00',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
