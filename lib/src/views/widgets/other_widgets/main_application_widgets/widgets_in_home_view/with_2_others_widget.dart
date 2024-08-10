import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveWith2OthersWidget extends StatelessWidget {
  const AmptiveWith2OthersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),                                
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5).r,
        color: AmptiveColors.brandBlackColor.withOpacity(0.6)
      ),
      child: Text(
        'With 2 others',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: AmptiveFontWeights.medium,
          fontSize: AmptiveFontSizes.size10
        )
      )
    );
  }
}
