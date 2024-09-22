import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import 'custom_container_widget.dart';

class AmptiveCirceAvatarWidget extends StatelessWidget {
  final double diameter;
  final Color? color;
  const AmptiveCirceAvatarWidget({
    super.key,
    required this.diameter,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return AmptiveCustomContainer(
      height: diameter, width: diameter,
      radius: diameter,
      color: color ?? AmptiveColors.whiteColor,
      child: const SizedBox.shrink()
    );
  }
}