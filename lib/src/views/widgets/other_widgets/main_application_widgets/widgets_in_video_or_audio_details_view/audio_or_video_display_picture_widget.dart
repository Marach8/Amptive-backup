import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../common_widgets/container_for_rendering_other_widgets.dart';

class AmptiveAudioOrVideoDisplayPictureWithMoreIconWidget extends StatelessWidget {
  const AmptiveAudioOrVideoDisplayPictureWithMoreIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AmptiveCustomContainer(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topRight,
      height: 360.h,
      radius: 16,
      decorationImagePath: AmptiveImageStrings.weCanDoHardThingsBgImage,
      child: GestureDetector(                      
        onTap: (){context.pop();},
        child: AmptiveCustomContainer(
          height: 32, width: 32,
          boxShape: BoxShape.circle,
          color: AmptiveColors.brandBlackColor.withOpacity(0.7),
          child: const Icon(Icons.more_horiz),
        ),
      ),
    );
  }
}
