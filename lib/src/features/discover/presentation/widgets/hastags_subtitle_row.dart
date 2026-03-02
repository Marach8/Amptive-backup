import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';

class HashTagsSubtitleRow extends StatelessWidget {
  const HashTagsSubtitleRow({
    super.key,
    required this.hashTagTitle,
    required this.hashTagSubTitle,
    required this.trailingOnpressed
  });

  final String hashTagTitle,
  hashTagSubTitle;
  final VoidCallback trailingOnpressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const ATImgLoader(
          imgPath: ATImgStrings.HASH_ICON,
          height: 25, width: 25,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[            
            Text(
              '#${hashTagTitle.toLowerCase()}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: ATSizes.size15
              ),
            ),
            Text(
              hashTagSubTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: ATSizes.size13,
                color: ATColors.hexC2C2C2
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: trailingOnpressed,
          child: Icon(Icons.keyboard_arrow_right_sharp, color: ATColors.hexC2C2C2)
        )
      ],
    );
  }
}