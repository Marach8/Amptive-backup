import 'package:amptive/src/utils/constants/colors.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../views/widgets/common_widgets/custom_container_widget.dart';

Future<dynamic> showAppNotification({
  required BuildContext context,
  required Widget? icon,
  required String text,
  int? duration,
  Color? bgColor
}) async {
  return await Flushbar(
    backgroundColor: AmptiveColors.transparentColor,
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: duration ?? 5),
    messageText: Center(
      child: AmptiveContainer(
        radius: 10, color: bgColor ?? AmptiveColors.notifBg,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(icon != null) icon,
            if(icon != null) const Gap(10),
            Flexible(
              child: Text(
                text, maxLines: 2,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    ),
  ).show(context);
}