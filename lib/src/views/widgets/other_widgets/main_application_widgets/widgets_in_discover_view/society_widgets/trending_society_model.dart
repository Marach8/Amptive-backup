import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../common_widgets/circle_avatar.dart';
import '../../../../common_widgets/custom_container_widget.dart';
import '../../../../common_widgets/image_loader_widget.dart';

class AmptiveTrendingSocietyModel extends StatelessWidget {
  final String trendingPicture;
  const AmptiveTrendingSocietyModel({
    super.key,
    required this.trendingPicture
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(5),
          child: AmptiveContainer(
            height: 170.h, width: AmptiveHelperFunctions.getScreenWidth(context),
            child: FittedBox(
              fit: BoxFit.fill,
              child: AmptiveImageLoaderWidget(
                imagePath: trendingPicture
              ),
            ),
          ),
        ),
        const Gap(5),
        SizedBox(
          width: 135,
          child: Text(
            "Former CIA Agent on The Name",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AmptiveContainer(
              height: 12, width: 12,
              color: AmptiveColors.grey5Color,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "P",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AmptiveColors.brandBlack
                  ),
                ),
              ),
            ),
            const Gap(2),
            Flexible(
              child: SizedBox(
                child: Text(
                  'glendonnoyle',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: AmptiveFontSizes.size13,
                    color: AmptiveColors.grey5Color,
                  ),
                ),
              ),
            ),
            const Gap(5),
            
            Align(
              alignment: Alignment.bottomCenter,
              child: AmptiveCircleAvatarWidget(
                diameter: 4,
                color: AmptiveColors.grey5Color,
              ),
            ),
            const Gap(5),
            Text(
              'LIVE',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AmptiveColors.grey5Color,
              ),
            ),
          ],
        )
      ],
    );
  }
}