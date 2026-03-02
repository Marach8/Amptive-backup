import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';

class RenderATransaction extends StatelessWidget {
  const RenderATransaction({
    super.key,
    required this.time,
    required this.amount,
    required this.color,
    required this.icon,
    required this.imgPath,
    required this.txnType,
    this.descriptionIconColor,
    this.tileColor,
  });

  final String txnType, time, amount, imgPath;
  final IconData icon;
  final Color color;
  final Color? tileColor, descriptionIconColor;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: (){},
      color: tileColor ?? ATColors.white.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(15), radius: 15,
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 35, width: 35,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                ATCircularImage(
                  imagePath: imgPath,
                  diameter: 35,
                ),
                Positioned(
                  right: -2, top: -2,
                  child: CircleAvatar(
                    radius: 9, backgroundColor: color,
                    child: Icon(
                      icon, size: 10,
                      color: descriptionIconColor ?? ATColors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  txnType,
                  style: context.textTheme.bodySmall
                ),
                Text(
                  time,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: ATColors.hexC2C2C2,
                    fontSize: ATSizes.size13
                  )
                ),
              ],
            ),
          ),
          const SizedBox(width: 20,),
          Text(
            amount, maxLines: 2,
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: ATSizes.size16
            ),
          )
        ],
      ),
    );
  }
}