import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveRowOfNumberOfPeopleListeningWidget extends StatelessWidget {
  const AmptiveRowOfNumberOfPeopleListeningWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90.w,
          child: const Stack(
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.none,
            children: [
              AmptiveCircularContainerWithPictureWidget(
                imagePath: AmptiveImageStrings.jpeg1,
                addBorder: true,
              ),
              Positioned(
                left: 20,
                child: AmptiveCircularContainerWithPictureWidget(
                  imagePath: AmptiveImageStrings.jpeg2,
                  addBorder: true,
                )
              ),
              Positioned(
                left: 40,
                child:AmptiveCircularContainerWithPictureWidget(
                  imagePath: AmptiveImageStrings.jpeg3,
                  addBorder: true,
                )
              ),
            ],
          ),
        ),
    
        Text(
          '656 listening',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: AmptiveFontWeights.medium,
            fontSize: AmptiveFontSizes.size10
          )
        )
      ],
    );
  }
}