import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveRowOfPaidShowAndPlayButtonWidget extends StatelessWidget {
  const AmptiveRowOfPaidShowAndPlayButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding:  EdgeInsets.only(top: 18.0.h),
          child: GestureDetector(
            onTap: (){},
            child: Container(
              padding:  EdgeInsets.all(8.5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AmptiveColors.brandBlackColor
              ),
              child: Text(
                AmptiveOtherStrings.paidShow.toUpperCase(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: AmptiveFontWeights.medium,
                  fontSize: AmptiveFontSizes.size10
                )
              ),
            ),
          ),
        ),
        SizedBox(
          height: 45.w,
          width: 45.w,
          child: CircleAvatar(
            backgroundColor: AmptiveColors.authHintColor,
            child: Icon(Icons.play_arrow, color: AmptiveColors.brandBlackColor,
            size: 30.w,)
          ),
        )
      ],
    );
  }
}
