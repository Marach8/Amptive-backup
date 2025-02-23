import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveRowOfPaidShowAndPlayButtonWidget extends StatelessWidget {
  final IconData? icon;
  const AmptiveRowOfPaidShowAndPlayButtonWidget({
    super.key,
    this.icon
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
                color: AmptiveColors.brandBlack
              ),
              child: Text(
                AmptiveStrings.PAID_SHOW.toUpperCase(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: AmptiveFontWeights.w500,
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
            child: Icon(icon ?? Icons.play_arrow, color: AmptiveColors.brandBlack,
            size: 30.w,)
          ),
        )
      ],
    );
  }
}
