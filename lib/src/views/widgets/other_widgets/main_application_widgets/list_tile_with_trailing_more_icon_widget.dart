import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveListTileWithTrailingMoreIconWidget extends StatelessWidget {
  const AmptiveListTileWithTrailingMoreIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
      child: Row(
        children: [
          const AmptiveCircularContainerWithPictureWidget(
            imagePath: AmptiveImageStrings.jpeg3,
            //diameter: 40,
          ),
          Gap(10.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'emmanuelnnanna',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: AmptiveFontWeights.medium
                ),
              ),
              Text(
                'emmanuelnnanna',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AmptiveColors.subtitleColor,
                  fontWeight: AmptiveFontWeights.medium,
                  fontSize: AmptiveFontSizes.size13
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){},
            child: const Icon(Icons.more_horiz),
          )
        ],
      ),
    );
  }
}
