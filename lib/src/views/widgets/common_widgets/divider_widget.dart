import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/constants/colors.dart';
import 'custom_container_widget.dart';

class ATDivider extends StatelessWidget {
  const ATDivider({
    super.key,
  });

  @override
  Widget build(context) {
    return Container(
      color: ATColors.white.withValues(alpha: 0.1),
      height: 0.5,
      width: ATHelperFuncs.getScreenWidth(context),
      child: const SizedBox.shrink(),
    );
  }
}
