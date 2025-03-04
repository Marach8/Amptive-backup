import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';

class AmptiveRowOfTrendingHashTagTitle extends StatelessWidget {
  final String hashTagTitle,
  hashTagSubTitle;
  final VoidCallback trailingOnpressed;
  const AmptiveRowOfTrendingHashTagTitle({
    super.key,
    required this.hashTagTitle,
    required this.hashTagSubTitle,
    required this.trailingOnpressed
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          ATStrings.HASH,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: ATColors.authHintColor2
          )
        ),
        Gap(10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ATStrings.HASH + hashTagTitle.toLowerCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: AmptiveFontSizes.size15
              ),
            ),
            Text(
              hashTagSubTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: AmptiveFontSizes.size13,
                color: ATColors.grey5Color
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: trailingOnpressed,
          child: Icon(Icons.keyboard_arrow_right_sharp, color: ATColors.authHintColor,)
        )
      ],
    );
  }
}