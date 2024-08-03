import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';

class AmptiveLiveIndicatorWidget extends StatelessWidget {
  const AmptiveLiveIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      height: 20,
      width: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AmptiveColors.orangeGradientColorA,
            AmptiveColors.orangeGradientColorB
          ]
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AmptiveColors.brandBlackColor,
          width: 2,
        )
      ),
      child: Text(
        AmptiveOtherStrings.live.toUpperCase(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: AmptiveFontWeights.semiBold
        )
      ),
    );
  }
}