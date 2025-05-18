import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/font_weights.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../../widgets/common_widgets/custom_container_widget.dart' show ATContainer;
import '../../../../widgets/common_widgets/image_loader_widget.dart' show ATImgLoader;

class ProfileEventOrShowDisplay extends StatelessWidget {
  const ProfileEventOrShowDisplay({super.key});

  @override
  Widget build(context) {
    return ATContainer(
      margin: const EdgeInsets.only(bottom: 15),
      height: 80,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: const ATImgLoader(
              imgPath: ATImgStrings.weCanDoHardThingsBgImage,
              height: 77, width: 77,
            ),
          ),
          const SizedBox(width: 10),
      
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Row 1
                Row(
                  children: [
                    ATCircleAvatar(
                      diameter: 15,
                      color: ATColors.hexF91880,
                      child: const FittedBox(child: Text('S')),
                    ),
                    Text(
                      'We Can Do Hard Things',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size12,
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right_outlined, color: ATColors.hexC2C2C2, size: 20)
                  ],
                ),
                //Row 2
                Text(
                  maxLines: 2,
                  'How To Be More Alive With Cole Authur Riley (Best of Emmanuel Nnanna)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ATFontSizes.size15,
                  ),
                ),
      
                //Row 3
                Row(
                  children: [
                    ATContainer(
                      alignment: Alignment.center,
                      height: 10, width: 10, radius: 1,
                      color: ATColors.hexC2C2C2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'P',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: ATFontWeights.w800,
                            fontSize: ATFontSizes.size10,
                            color: ATColors.black
                          ),
                        )
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      'Society',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                    ATCircleAvatar(
                      diameter: 3,
                      color: ATColors.hexC2C2C2,
                    ),
                    
                    const SizedBox(width: 5,),
                    Text(
                      '15 JAN 2034 at 19:00',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
