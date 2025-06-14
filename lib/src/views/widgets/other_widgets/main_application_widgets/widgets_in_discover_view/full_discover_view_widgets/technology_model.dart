import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../common_widgets/circle_avatar.dart';
import '../../../../common_widgets/custom_container_widget.dart';
import '../../../../common_widgets/image_loader_widget.dart';

class AmptiveTechnologyModel extends StatelessWidget {
  final String trendingPicture;
  const AmptiveTechnologyModel({
    super.key,
    required this.trendingPicture
  });

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      width: 250,
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(5),
            child: ATImgLoader(imgPath: trendingPicture),
          ),
          const Gap(5),
          SizedBox(
            width: 135,
            child: Text(
              "Don't forget who you are",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Row(
            children: [
              ATContainer(
                height: 12, width: 12,
                color: ATColors.authHintColor,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "P",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: ATColors.hex0D0D0D
                    ),
                  ),
                ),
              ),
              const Gap(2),
              Text(
                'glendonnor',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: ATFontSizes.size13,
                  color: ATColors.hexCDCDCD
                ),
              ),
              const Gap(5),
              ATCircleAvatar(
                diameter: 3,
                color: ATColors.hexCDCDCD
              ),
              Text(
                'FRIDAY',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ATColors.hexCDCDCD
                ),
              ),
              const Spacer()
            ],
          )
        ],
      ),
    );
  }
}