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
        GestureDetector(
          onTap: (){},
          child: Container(
            padding: const EdgeInsets.all(5),                                
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5).r,
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
        CircleAvatar(
          backgroundColor: AmptiveColors.authHintColor,
          child: Icon(Icons.play_arrow, color: AmptiveColors.brandBlackColor)
        )
      ],
    );
  }
}
