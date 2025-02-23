import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';

class AmptiveLoadingIndicatorWidget extends StatelessWidget {
  final Color? color;
  final double size;
  const AmptiveLoadingIndicatorWidget({
    super.key,
    this.color,
    this.size = 25
  });

  @override
  Widget build(context) {
    return SizedBox(
      height: size, width: size,
      child: CircularProgressIndicator(
        color: color ?? AmptiveColors.hex307FE2,
        backgroundColor: AmptiveColors.hex307FE2.withOpacity(0.5),
        strokeWidth: 3,
      ),
    );
  }
}
