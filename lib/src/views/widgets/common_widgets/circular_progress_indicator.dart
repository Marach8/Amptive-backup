import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';

class AmptiveCircularProgressIndicatorWidget extends StatelessWidget {
  const AmptiveCircularProgressIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: AmptiveColors.brandBlueColor,
      backgroundColor: AmptiveColors.brandBlueColor.withOpacity(0.5),
      strokeWidth: 3,
    );
  }
}
