import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveLiveIndicatorWidget extends StatelessWidget {
  const AmptiveLiveIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      height: 22.h,
      width: 38.w,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                ATColors.hexF91880,
                ATColors.orangeGradientColorB
              ]),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: ATColors.hex0D0D0D,
            width: 2,
          )),
      child: Text(ATStrings.LIVE.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: ATFontWeights.w600)),
    );
  }
}
