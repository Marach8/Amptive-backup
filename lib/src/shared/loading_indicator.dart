import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../config/utils/colors.dart';

class ATLoadingIndicator extends StatelessWidget {
  const ATLoadingIndicator({
    super.key, this.color, this.size = 25, this.strokeWidth = 3});
  final Color? color;
  final double size, strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: CupertinoActivityIndicator(
          radius: size / 2,
          color: color ?? ATColors.white,
        ),
      ),
    );
  }
}
