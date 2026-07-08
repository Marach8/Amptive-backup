import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/animation_widgets/other_animation_widgets/opacity_animation.dart';
import 'package:flutter/material.dart';

class LiveIndicatorWithAnimatingDot extends StatelessWidget {
  const LiveIndicatorWithAnimatingDot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.44, 5, 8.44, 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[ATColors.hexF91880, 
            ATColors.orangeGradientColorB]),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ATAnimOpacity(
            child: CircleAvatar(
              radius: 3,
              backgroundColor: ATColors.white,
            ),
          ),
          const SizedBox(width: 4),
          Text(ATStrings.live.toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATSizes.size14,
                    fontWeight: ATFontWeights.w600,
                    height: 0,
                  )),
        ],
      ),
    );
  }
}



class LiveIndicatorWithAnimatinWifiIcon extends StatefulWidget {
  const LiveIndicatorWithAnimatinWifiIcon({super.key});

  @override
  State<LiveIndicatorWithAnimatinWifiIcon> createState() 
    => _LiveIndicatorWithAnimatinWifiIconState();
}

class _LiveIndicatorWithAnimatinWifiIconState 
  extends State<LiveIndicatorWithAnimatinWifiIcon> {
  bool isDone = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TweenAnimationBuilder<Color?>(
          duration: const Duration(seconds: 2),
          tween: ColorTween(
            begin: isDone ? ATColors.white : ATColors.hexA8A8A8,
            end: isDone ? ATColors.hexA8A8A8 : ATColors.white,
          ),
          onEnd: () => setState(() => isDone = !isDone),
          builder: (_, Color? color, __) {
            return ATImgLoader(
              imgPath: ATImgStrings.wifiIcon,
              height: 24,
              width: 24,
              color: color ?? ATColors.hexA8A8A8,
            );
          }
        ),
        Text(
          ATStrings.live.toUpperCase(),
          style: context.textTheme.bodyMedium
              ?.copyWith(color: ATColors.hexA8A8A8, fontSize: 14),
        ),
      ],
    );
  }
}
