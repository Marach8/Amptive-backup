import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/font_sizes.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import '../../../../widgets/common_widgets/image_loader_widget.dart';

class LiveIndicatorRow extends StatelessWidget {
  const LiveIndicatorRow({
    super.key,
    this.text2
  });

  final String? text2;

  @override
  Widget build(BuildContext context) {
    bool isDone = false;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StatefulBuilder(
          builder: (_, void Function(void Function()) setter) {
            return TweenAnimationBuilder<Color?>(
              duration: const Duration(seconds: 2),
              tween: ColorTween(
                begin: isDone ? ATColors.white : ATColors.hexA8A8A8,
                end: isDone ? ATColors.hexA8A8A8 : ATColors.white,
              ),
              onEnd: () => setter(() => isDone = !isDone),
              builder: (_, Color? color, __) {
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    color ?? ATColors.hexA8A8A8,
                    BlendMode.srcATop,
                  ),
                  child: const ATImgLoader(
                    imgPath: ATImgStrings.WIFI_ICON,
                    height: 24, width: 24,
                  ),
                );
              }
            );
          }
        ),
        const Gap(5),
        Text(
          ATStrings.LIVE.toUpperCase(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ATColors.hexA8A8A8,
            fontSize: ATFontSizes.size14
          ),  
        ),
        const Gap(20),
        const ATImgLoader(
          imgPath: ATImgStrings.GROUP_ICON,
          height: 24, width: 24,
        ),
        const Gap(5),
        Text(
          text2?.toUpperCase() ?? ATStrings.SOCIETY.toUpperCase(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ATColors.hexA8A8A8,
            fontSize: ATFontSizes.size14
          ),  
        ),
      ],
    );
  }
}