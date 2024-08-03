import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/colors.dart';

class AmptiveCircularProgressIndicatorWidget extends StatelessWidget {
  const AmptiveCircularProgressIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 17.h),
      width: 32.w,
      height: 32.h,
      child: CircularProgressIndicator(
        color: AmptiveColors.brandBlueColor,
        backgroundColor: AmptiveColors.brandBlueColor.withOpacity(0.5),
        strokeWidth: 5.w,
      ),
    );
  }
}
