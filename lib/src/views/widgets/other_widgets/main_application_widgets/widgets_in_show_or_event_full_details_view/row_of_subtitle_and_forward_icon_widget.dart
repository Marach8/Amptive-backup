import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/font_sizes.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../common_widgets/image_loader_widget.dart';

class AmptiveRowOfSubtitleAndForwardIconWidget extends StatelessWidget {
  const AmptiveRowOfSubtitleAndForwardIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ATImgLoader(imgPath: ATImgStrings.sIcon),
        const Gap(5),
        Text(
          'We Can Do Hard Things',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: ATFontSizes.size15,
            color: ATColors.dimWhiteColor1
          ),
        ),
        const Gap(5),
        const Icon(Icons.arrow_forward_ios_sharp, size: 12, weight: 20,)
      ],
    );
  }
}
