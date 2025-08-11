import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/views/widgets/animation_widgets/other_animation_widgets/live_user_animation.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/live_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LiveUserWidget extends StatelessWidget {
  const LiveUserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedPicPaddingWidget(
              imagePath: ATImgStrings.jpeg3,
            ),
            Positioned(
              bottom: -4,
              child: AmptiveLiveIndicatorWidget(),
            )
          ],
        ),
    
        const Gap(10),
        Text(
          'emmanuel',
          style: Theme.of(context).textTheme.titleSmall
        ),
      ],
    );
  }
}
