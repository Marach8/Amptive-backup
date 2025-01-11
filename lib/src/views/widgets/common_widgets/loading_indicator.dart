import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';

class AmptiveLoadingIndicatorWidget extends StatelessWidget {
  const AmptiveLoadingIndicatorWidget({
    super.key,
  });

  @override
  Widget build(context) {
    return CircularProgressIndicator(
      color: AmptiveColors.brandBlueColor,
      backgroundColor: AmptiveColors.brandBlueColor.withValues(alpha: 0.5),
      strokeWidth: 3,
    );
  }
}
