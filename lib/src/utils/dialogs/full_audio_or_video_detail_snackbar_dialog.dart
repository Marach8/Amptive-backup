import 'package:flutter/material.dart';
import '../../views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/audio_full_details_view.dart';
import '../constants/colors.dart';


void showAudioOrVideoFullDetails({
  required BuildContext context,
  required Animation<double> snackBarAnimation,
  required AnimationController controller
}) {
  controller.forward();
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      animation: snackBarAnimation,
      backgroundColor: AmptiveColors.brandBlackColor,
      elevation: 0,
      padding: EdgeInsets.zero,
      duration: const Duration(hours: 12),
      content: const NewScreen(),
    )
  );
}