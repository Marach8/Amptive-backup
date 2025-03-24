import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';

class ATLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;
  const ATLoadingIndicator({
    super.key,
    this.color,
    this.size = 25
  });

  @override
  Widget build(context) {
    return SizedBox(
      height: size, width: size,
      child: CircularProgressIndicator(
        color: color ?? ATColors.hex307FE2,
        backgroundColor: ATColors.hex307FE2.withOpacity(0.5),
        strokeWidth: 3,
      ),
    );
  }
}
