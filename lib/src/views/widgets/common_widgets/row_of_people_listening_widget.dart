import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            const AmptiveCircularContainerWithPictureWidget(
              imagePath: AmptiveImageStrings.jpeg1,
              addBorder: true,
            ),
            const Positioned(
              left: 20,
              child: AmptiveCircularContainerWithPictureWidget(
                imagePath: AmptiveImageStrings.jpeg2,
                addBorder: true,
              )
            ),
            const Positioned(
              left: 40,
              child:AmptiveCircularContainerWithPictureWidget(
                imagePath: AmptiveImageStrings.jpeg3,
                addBorder: true,
              )
            ),

            showNumberInsideContainer ? Positioned(
              left: 60,
              child: AmptiveCustomContainer(
                color: AmptiveColors.grey1Color,
                alignment: Alignment.center,
                height: 30,
                width: 30,
                boxShape: BoxShape.circle,
                child: Text(
                  '+652',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: AmptiveFontSizes.size10
                  )
                ),
              )
            ) : const SizedBox.shrink()
          ],
        ),
    
        showNumberInsideContainer ? const SizedBox.shrink() : Container(
          margin: EdgeInsets.only(left: 46.w),
          child: Text(
            '656 listening',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: AmptiveFontWeights.medium,
              fontSize: AmptiveFontSizes.size10
            )
          ),
        )
      ],
    );
  }
}