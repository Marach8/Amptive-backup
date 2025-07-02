import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveRowOfPaidShowAndPlayButtonWidget extends StatelessWidget {
  const AmptiveRowOfPaidShowAndPlayButtonWidget({
    super.key,
    this.icon
  });
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.only(top: 18.0.h),
          child: Container(
            padding:  EdgeInsets.all(8.5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ATColors.hex0D0D0D
            ),
            child: Text(
              ATStrings.PAID_SHOW.toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: ATFontWeights.w500,
                fontSize: ATFontSizes.size10
              )
            ),
          ),
        ),
        SizedBox(
          height: 45,
          width: 45,
          child: CircleAvatar(
            backgroundColor: ATColors.hexB6B6B6,
            child: Icon(icon ?? Icons.play_arrow, color: ATColors.hex0D0D0D,
            size: 30)
          ),
        )
      ],
    );
  }
}
