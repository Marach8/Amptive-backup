import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/animation_widgets/other_animation_widgets/live_user_animation.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/live_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveLiveUserModelWidget extends StatelessWidget {
  const AmptiveLiveUserModelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AmptiveAnimatedPaddingOnPictureWidget(
              imagePath: AmptiveImageStrings.jpeg3,
            ),
            Positioned(
              bottom: -4,
              child: AmptiveLiveIndicatorWidget(),
            )
          ],
        ),
    
        Gap(10.h),
        Text(
          'Emmanuel',
          style: Theme.of(context).textTheme.titleSmall
        ),
      ],
    );
  }
}
