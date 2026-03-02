import 'package:amptive/src/features/home/presentation/widgets/program_options_modal.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/custom_container_widget.dart';

class ATEventOrShowCard extends StatelessWidget {
  const ATEventOrShowCard({
    super.key,
    this.imgPath = ATImgStrings.weCanDoHardThingsBgImage,
  });

  final dynamic imgPath;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topRight,
      height: 360, radius: 16,
      decorImage: imgPath,
      child: ATContainer(
        onTap: () => showProgramOptions(context),
        height: 32, width: 32,
        boxShape: BoxShape.circle,
        color: ATColors.hex0D0D0D.withValues(alpha: 0.7),
        child: const Icon(Icons.more_horiz),
      ),
    );
  }
}
