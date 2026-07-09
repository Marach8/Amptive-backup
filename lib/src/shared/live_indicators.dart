import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/animation_widgets/other_animation_widgets/opacity_animation.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class LiveIndicatorWithAnimatingDot extends StatelessWidget {
  const LiveIndicatorWithAnimatingDot({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 3 : 4,
      ),
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 5,
            cornerSmoothing: 0.6,
          ),
        ),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[ATColors.hexF91880, ATColors.orangeGradientColorB]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ATAnimOpacity(
            child: CircleAvatar(
              radius: compact ? 2 : 2.5,
              backgroundColor: ATColors.white,
            ),
          ),
          SizedBox(width: compact ? 3 : 4),
          Text(ATStrings.live.toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: compact ? 10 : ATSizes.size12,
                    fontWeight: ATFontWeights.w700,
                    height: 0,
                  )),
        ],
      ),
    );
  }
}

class LiveIndicatorWithAnimatinWifiIcon extends StatefulWidget {
  const LiveIndicatorWithAnimatinWifiIcon({
    super.key,
    this.textStyle,
  });

  final TextStyle? textStyle;

  @override
  State<LiveIndicatorWithAnimatinWifiIcon> createState() =>
      _LiveIndicatorWithAnimatinWifiIconState();
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
              return ColorFiltered(
                colorFilter: ColorFilter.mode(
                  color ?? ATColors.hexA8A8A8,
                  BlendMode.srcATop,
                ),
                child: const ATImgLoader(
                  imgPath: ATImgStrings.wifiIcon,
                  height: 24,
                  width: 24,
                ),
              );
            }),
        Text(
          ATStrings.live.toUpperCase(),
          style: widget.textStyle ??
              context.textTheme.bodyMedium?.copyWith(
                color: ATColors.hexA8A8A8,
                fontSize: ATSizes.size14,
              ),
        ),
      ],
    );
  }
}
