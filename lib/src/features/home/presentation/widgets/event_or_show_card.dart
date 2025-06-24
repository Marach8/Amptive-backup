import 'package:amptive/src/utils/dialogs/options_dialog.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/strings/image_strings.dart';
import '../../../../views/widgets/common_widgets/custom_container_widget.dart';

class ATEventOrShowCard extends StatelessWidget {
  const ATEventOrShowCard({
    super.key,
    this.imgPath = ATImgStrings.weCanDoHardThingsBgImage
  });
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topRight,
      height: 360, radius: 16,
      decorationImagePath: imgPath,
      child: GestureDetector(                      
        onTap: () => showProgramOptions(context),
        child: ATContainer(
          height: 32, width: 32,
          boxShape: BoxShape.circle,
          color: ATColors.hex0D0D0D.withValues(alpha: 0.7),
          child: const Icon(Icons.more_horiz),
        ),
      ),
    );
  }
}
