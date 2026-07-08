import 'package:amptive/src/config/routing/routes.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../../../shared/custom_container_widget.dart';

Future<dynamic> showAppNotification(
    {required BuildContext context,
    Widget? icon = const Icon(Icons.check_circle),
    required String text,
    int? duration,
    Color? bgColor}) async {
  return await Flushbar<dynamic>(
    backgroundColor: ATColors.transparent,
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: duration ?? 5),
    messageText: Center(
      child: ATContainer(
        radius: 10,
        color: bgColor ?? ATColors.notifBg,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) icon,
            if (icon != null) const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    ),
  ).show(context);
}

enum NotificationType { normal, success, failure }

Future<dynamic> showAppNotification2({
  BuildContext? context,
  required String text,
  NotificationType type = NotificationType.normal,
  int? duration,
}) async {
  final BuildContext? ctx = navigatorKey.currentContext ?? context;
  if(ctx == null) return;

  return await Flushbar<dynamic>(
    backgroundColor: ATColors.transparent,
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: duration ?? 5),
    messageText: Center(
      child: ATContainer(
        radius: 10,
        color: switch (type) {
          NotificationType.normal => ATColors.notifBg,
          NotificationType.success => ATColors.successColor,
          NotificationType.failure => ATColors.textRedColor,
        },
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            switch (type) {
              NotificationType.normal => Icon(
                  Icons.info_outline,
                  color: ATColors.white,
                ),
              NotificationType.success => Icon(
                  Icons.check_circle,
                  color: ATColors.white,
                ),
              NotificationType.failure => Icon(
                  Icons.warning_rounded,
                  color: ATColors.white,
                ),
            },
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                maxLines: 2,
                style: ctx.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    ),
  ).show(ctx);
}
