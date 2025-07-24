import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ATModalDismisser extends StatelessWidget {
  const ATModalDismisser({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isAndroid = ATHelperFuncs.platformIsAndroid();
    if(isAndroid){
      return GestureDetector(
        onTap: () => context.pop(),
        child: Icon(
          Icons.keyboard_arrow_down_outlined, size: 25,
          color: ATColors.white.withValues(alpha: 0.2)
        ),
      );
    }
    return ATContainer(
      onTap: () => context.pop(),
      height: 5, width: 30, radius: 5,
      color: ATColors.white.withValues(alpha: 0.1),
      child: const SizedBox.shrink()
    );
  }
}