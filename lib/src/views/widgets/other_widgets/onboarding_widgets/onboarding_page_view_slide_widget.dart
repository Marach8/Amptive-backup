import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/other_widgets/onboarding_widgets/heading_and_description_texts_column_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../common_widgets/image_loader_widget.dart';

class AmptiveCustomOnboardingPageViewSlideWidget extends StatelessWidget {

  const AmptiveCustomOnboardingPageViewSlideWidget({
    super.key,
    required this.title,
    required this.description,
    required this.pictureBgColor
  });
  final String title;
  final String description;
  final Color? pictureBgColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: pictureBgColor,
          width: ATHelperFuncs.getScreenWidth(context),
          height: ATHelperFuncs.getScreenHeight(context) * 0.65,
          child: const ATImgLoader(
            imgPath: ATImgStrings.emptyImage,
            boxFit: BoxFit.scaleDown,
          )
        ),
        Gap(20.r),
        Padding(
          padding: const EdgeInsets.all(20).r,
          child: AmptiveOnboardingHeadingAndDescriptionTextsColumnWidget(
            title: title,
            description: description,
          ),
        ),
      ],
    );
  }
}

