import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart' show ATImgLoader;
import 'package:flutter/material.dart';
import '../../../config/utils/image_strings.dart';

class ATShowIcon extends StatelessWidget {
  const ATShowIcon({super.key, this.size});
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ATImgLoader(
      height: size ?? 16, width: size ?? 16,
      imgPath: ATImgStrings.SHOW_ICON,
    );
  }
}


class EventIcon extends StatelessWidget {
  const EventIcon({super.key, this.size});
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ATImgLoader(
      height: size ?? 16, width: size ?? 16,
      imgPath: ATImgStrings.SHOW_ICON,
    );
  }
}


class ATPaidIndicatorIcon extends StatelessWidget {
  const ATPaidIndicatorIcon({
    super.key,
    this.size,
    this.color,
    this.radius
  });

  final double? size, radius;
  final Color? color;


  @override
  Widget build(BuildContext context) {
    return ATContainer(
      color: color ?? ATColors.white, radius: radius ?? 2,
      height: size ?? 14, width: size ?? 14,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'P',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: ATFontWeights.w800,
            color: ATColors.black
          )
        ),
      ),
    );
  }
}