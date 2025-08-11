import 'package:flutter/material.dart';
import '../../../config/utils/colors.dart';

class ATLoadingIndicator extends StatelessWidget {
  const ATLoadingIndicator({
    super.key,
    this.color,
    this.size = 25
  });
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size, width: size,
      child: CircularProgressIndicator(
        color: color ?? ATColors.hex307FE2,
        backgroundColor: (color ?? ATColors.hex307FE2).withValues(alpha: 0.5),
        strokeWidth: 3,
      ),
    );
  }
}
