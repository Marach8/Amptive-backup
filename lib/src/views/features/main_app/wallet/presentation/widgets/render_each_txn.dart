
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';

class RenderTxnWidget extends StatelessWidget {
  const RenderTxnWidget({
    super.key,
    required this.time,
    required this.amount,
    required this.color,
    required this.icon,
    required this.imgPath,
    required this.txnType,
  });

  final String txnType, time, amount, imgPath;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: (){},
      color: ATColors.white.withValues(alpha: 0.05),
      radius: 15, padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          SizedBox(
            height: 35, width: 35,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ATCircularImage(
                  imagePath: imgPath,
                  diameter: 35,
                ),
                Positioned(
                  right: -2, top: -2,
                  child: ATCircleAvatar(
                    diameter: 20, color: color,
                    child: Icon(icon, color: ATColors.black, size: 15,),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                txnType,
                style: Theme.of(context).textTheme.bodySmall
              ),
              Text(
                time,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ATColors.hexC2C2C2,
                  fontSize: ATFontSizes.size13
                )
              ),
            ],
          ),
          const SizedBox(width: 20,),
          Expanded(
            child: Text(
              amount, maxLines: 2,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: ATFontSizes.size16
              ),
            ),
          )
        ],
      ),
    );
  }
}

