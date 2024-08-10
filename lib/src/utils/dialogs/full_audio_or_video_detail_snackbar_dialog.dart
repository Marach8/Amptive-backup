import 'package:flutter/material.dart';
import '../../views/screens/main_application_screens/sub_views/new_screen.dart';
import '../constants/colors.dart';


void showAudioOrVideoFullDetails(BuildContext context)
  => ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      backgroundColor: AmptiveColors.brandBlackColor,
      elevation: 0,
      padding: EdgeInsets.zero,
      duration: const Duration(hours: 12),
      content: const NewScreen(),
    )
  );