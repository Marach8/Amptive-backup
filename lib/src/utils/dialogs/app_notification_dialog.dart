import 'dart:ui';
import 'package:amptive/src/models/generic_response_model.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> showSuccessOrFailureNotification({
  required GenericResponseModel response,
  Widget? child,
  int? duration,
  Color? bgColor
}) async {
  final isSuccessful = response.isSuccessful ?? false;

  final platformDispatcher = PlatformDispatcher.instance;
  final height = (platformDispatcher.views.first.physicalSize.height) * 0.5;

  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: bgColor ?? (isSuccessful ? AmptiveColors.green1 : AmptiveColors.notifRed),
      elevation: 0,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: 15.0, right: 15.0,
        bottom: height - (2 * kToolbarHeight)
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (child != null) child,
          if (child != null) const Gap(10),
          Flexible(
            child: Text(
              response.responseMessage ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AmptiveColors.whiteColor,
                fontSize: AmptiveFontSizes.size14,
                fontWeight: AmptiveFontWeights.medium,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}






Future<void> showNormalNotification({
  Widget? child,
  int? duration,
  required String text,
  Color? bgColor
}) async {

  final platformDispatcher = PlatformDispatcher.instance;
  final height = (platformDispatcher.views.first.physicalSize.height) * 0.5;

  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: bgColor,
      elevation: 0,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: 15.0, right: 15.0,
        bottom: height - (2 * kToolbarHeight)
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (child != null) child,
          if (child != null) const Gap(10),
          Flexible(
            child: Text(
              text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AmptiveColors.whiteColor,
                fontSize: AmptiveFontSizes.size14,
                fontWeight: AmptiveFontWeights.medium,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}