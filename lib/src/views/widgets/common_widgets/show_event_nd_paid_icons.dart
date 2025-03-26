import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart' show ATImgLoader;
import 'package:flutter/material.dart';
import '../../../utils/constants/strings/image_strings.dart';

class ShowIcon extends StatelessWidget {
  final double? size;
  const ShowIcon({super.key, this.size});

  @override
  Widget build(context) {
    return ATImgLoader(
      height: size ?? 16, width: size ?? 16,
      imgPath: ATImgStrings.SHOW_ICON,
    );
  }
}


class EventIcon extends StatelessWidget {
  final double? size;
  const EventIcon({super.key, this.size});

  @override
  Widget build(context) {
    return ATImgLoader(
      height: size ?? 16, width: size ?? 16,
      imgPath: ATImgStrings.SHOW_ICON,
    );
  }
}


class PaidIndicatorIcon extends StatelessWidget {
  final double? size;
  const PaidIndicatorIcon({super.key, this.size});

  @override
  Widget build(context) {
    return ATContainer(
      color: ATColors.white, radius: 2,
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