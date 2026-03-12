import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/extensions/context_extensions.dart';

class PaidShowAndPlayBtnWidget extends StatelessWidget {
  const PaidShowAndPlayBtnWidget({super.key, this.icon});
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Container(
            padding: const EdgeInsets.all(8.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ATColors.hex0D0D0D),
            child: Text(ATStrings.paidShow.toUpperCase(),
                style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: ATFontWeights.w500, fontSize: ATSizes.size10)),
          ),
        ),
        SizedBox(
          height: 45,
          width: 45,
          child: CircleAvatar(
              backgroundColor: ATColors.hexB6B6B6,
              child: Icon(icon ?? Icons.play_arrow,
                  color: ATColors.hex0D0D0D, size: 30)),
        )
      ],
    );
  }
}
