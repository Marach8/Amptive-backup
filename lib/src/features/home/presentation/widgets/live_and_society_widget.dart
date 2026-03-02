import 'package:amptive/src/config/config_export.dart';
import 'package:flutter/material.dart';
import '../../../../shared/image_loader_widget.dart';

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
        const SizedBox(width: 5,),
        Text(
          ATStrings.LIVE.toUpperCase(),
          style: context.textTheme.bodyMedium?.copyWith(
            color: ATColors.hexA8A8A8,
            fontSize: ATSizes.size14
          ),  
        ),
        const SizedBox(width: 20,),
        const ATImgLoader(
          imgPath: ATImgStrings.GROUP_ICON,
          height: 24, width: 24,
        ),
        const SizedBox(width: 5,),
        Text(
          (text2 ?? ATStrings.SOCIETY).toUpperCase(),
          style: context.textTheme.bodyMedium?.copyWith(
            color: ATColors.hexA8A8A8,
            fontSize: ATSizes.size14
          ),  
        ),
      ],
    );
  }
}



class ScheduleDateIndicator extends StatelessWidget {
  const ScheduleDateIndicator({
    super.key,
    this.text2 = ATStrings.SOCIETY,
    this.text1 = '27 Sep, 2025 at 18:00'
  });

  final String text1, text2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ATImgLoader(imgPath: ATImgStrings.FILLED_CALENDER_ICON,),
        const SizedBox(width: 5,),
        Flexible(
          child: Text(
            text1,
            style: context.textTheme.bodyMedium?.copyWith(
              color: ATColors.hexA8A8A8,
              fontSize: ATSizes.size14
            ),  
          ),
        ),
        const SizedBox(width: 20),
        const ATImgLoader(
          imgPath: ATImgStrings.GROUP_ICON,
          height: 24, width: 24,
        ),
        const SizedBox(width: 5,),
        Text(
          text2.toUpperCase(),
          style: context.textTheme.bodyMedium?.copyWith(
            color: ATColors.hexA8A8A8,
            fontSize: ATSizes.size14
          ),  
        ),
      ],
    );
  }
}