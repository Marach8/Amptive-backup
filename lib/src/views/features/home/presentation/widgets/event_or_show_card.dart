import 'package:amptive/src/utils/dialogs/options_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../../widgets/common_widgets/custom_container_widget.dart';

class ATEventOrShowCard extends StatelessWidget {
  const ATEventOrShowCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topRight,
      height: 360, radius: 16,
      decorationImagePath: ATImgStrings.weCanDoHardThingsBgImage,
      child: GestureDetector(                      
        onTap: () => showProgramOptions(context),
        child: ATContainer(
          height: 32, width: 32,
          boxShape: BoxShape.circle,
          color: ATColors.brandBlack.withValues(alpha: 0.7),
          child: const Icon(Icons.more_horiz),
        ),
      ),
    );
  }
}
