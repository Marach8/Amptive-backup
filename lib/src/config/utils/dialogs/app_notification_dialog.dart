import 'package:amptive/src/config/utils/colors.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../shared/custom_container_widget.dart';


Future<dynamic> showAppNotification({
  required BuildContext context,
  Widget? icon = const Icon(Icons.check_circle),
  required String text,
  int? duration,
  Color? bgColor
}) async {
  return await Flushbar(
    backgroundColor: ATColors.transparent,
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: duration ?? 5),
    messageText: Center(
      child: ATContainer(
        radius: 10, color: bgColor ?? ATColors.notifBg,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if(icon != null) icon,
            if(icon != null) const SizedBox(width: 10),
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