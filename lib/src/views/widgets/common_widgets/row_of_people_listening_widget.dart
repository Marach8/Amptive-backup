import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';

class AmptiveRowOfNumberOfPeopleListeningWidget extends StatelessWidget {
  final double? pictureDiameter;
  final bool showNumberInsideContainer;
  
  const AmptiveRowOfNumberOfPeopleListeningWidget({
    super.key,
    this.pictureDiameter,
    this.showNumberInsideContainer = false
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.none,
          children: [
            const ATRoundedImage(
              imagePath: ATImgStrings.jpeg1,
              addBorder: true,
            ),
            const Positioned(
              left: 18,
              child: ATRoundedImage(
                imagePath: ATImgStrings.jpeg2,
                addBorder: true,
              )
            ),
            const Positioned(
              left: 36,
              child:ATRoundedImage(
                imagePath: ATImgStrings.jpeg3,
                addBorder: true,
              )
            ),

            showNumberInsideContainer ? Positioned(
              left: 52,
              child: ATContainer(
                color: ATColors.hex2D2D2D,
                alignment: Alignment.center,
                height: 30,
                width: 30,
                boxShape: BoxShape.circle,
                child: Text(
                  '+652',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: ATFontSizes.size13
                  )
                ),
              )
            ) : const SizedBox.shrink()
          ],
        ),
    
        showNumberInsideContainer ? const SizedBox.shrink() : Container(
          margin: const EdgeInsets.only(left: 46),
          child: Text(
            '656 listening',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: ATFontSizes.size13
            )
          ),
        )
      ],
    );
  }
}