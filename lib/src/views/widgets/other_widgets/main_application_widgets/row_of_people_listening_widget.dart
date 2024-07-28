import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/container_with_picture_widget.dart';
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
              AmptiveCircularContainerWithPIctureWidget(
                imagePath: AmptiveImageStrings.jpeg1,
              ),
              Positioned(
                left: 20,
                child: AmptiveCircularContainerWithPIctureWidget(
                  imagePath: AmptiveImageStrings.jpeg2,
                )
              ),
              Positioned(
                left: 40,
                child:AmptiveCircularContainerWithPIctureWidget(
                  imagePath: AmptiveImageStrings.jpeg3,
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