import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/font_sizes.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import '../../../common_widgets/image_loader_widget.dart';

class AmptiveRowOfLiveAndSocietyTextsWidget extends StatelessWidget {
  final String? text2;
  const AmptiveRowOfLiveAndSocietyTextsWidget({
    super.key,
    this.text2
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AmptiveImageLoaderWidget(
          imagePath: AmptiveImageStrings.spreadNetworkIcon,
          height: 24, width: 24,
        ),
        const Gap(5),
        Text(
          AmptiveOtherStrings.live.toUpperCase(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AmptiveColors.grey5Color,
            fontSize: AmptiveFontSizes.size14
          ),  
        ),
        const Gap(20),
        Icon(Icons.groups, color: AmptiveColors.grey5Color),
        const Gap(5),
        Text(
          text2 ?? AmptiveOtherStrings.society.toUpperCase(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AmptiveColors.grey5Color,
            fontSize: AmptiveFontSizes.size14
          ),  
        ),
      ],
    );
  }
}