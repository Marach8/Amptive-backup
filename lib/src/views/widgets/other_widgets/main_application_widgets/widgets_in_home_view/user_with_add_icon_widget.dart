import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveUserWithAddIconWidget extends StatelessWidget {
  const AmptiveUserWithAddIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(10.h),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: const AmptiveImageLoaderWidget(
                imagePath: AmptiveImageStrings.jpeg1,
                boxFit: BoxFit.cover,
                height: 60,
                width: 60,
              ),
            ),
            Positioned(
              bottom: -5.h,
              child: GestureDetector(
                onTap: (){},
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(0),
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: AmptiveColors.brandBlueColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AmptiveColors.brandBlackColor,
                      width: 2,
                    )
                  ),
                  child: const Icon(Icons.add, size: 15, applyTextScaling: true,),
                ),
              ),
            )
          ],
        ),
    
        Gap(10.h),
        Text(
          AmptiveOtherStrings.goLive,
          style: Theme.of(context).textTheme.titleSmall
        ),
      ],
    );
  }
}