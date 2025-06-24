import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/font_sizes.dart';
import '../../../../utils/constants/strings/image_strings.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';

class ShowOrEventIndicatorWithTitle extends StatelessWidget {
  const ShowOrEventIndicatorWithTitle({
    super.key,
    this.title = 'We Can Do Hard Things',
    this.eventOrShowImgPath = ATImgStrings.SHOW_ICON,
  });

  final String eventOrShowImgPath, title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ATImgLoader(imgPath: eventOrShowImgPath),
        const SizedBox(width: 5,),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: ATFontSizes.size15,
            color: ATColors.dimWhiteColor1
          ),
        ),
        const SizedBox(height: 5,),
        const Icon(Icons.arrow_forward_ios_sharp, size: 12, weight: 20,)
      ],
    );
  }
}
