import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../views/widgets/common_widgets/custom_container_widget.dart';
import '../constants/colors.dart';



Future<bool?> showAddedOrRemovedSnackbar({
  required BuildContext context,
  required String content
}) async {
  return await Flushbar<bool?>(
    backgroundColor: ATColors.trsprnt,
    flushbarPosition: FlushbarPosition.BOTTOM,
    duration: const Duration(seconds: 10),
    messageText: Center(
      child: ATContainer(
        radius: 15, color: ATColors.snackBarBgColor,
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            const Icon(Icons.check_circle), 
            const SizedBox(width: 10,),
            Expanded(
              child: Text(
                content, maxLines: 2,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(width: 10,),
            InkWell(
              onTap: () => context.pop(true),
              child: Row(
                children: [
                  Text(
                    ATStrings.VIEW,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ATColors.hex307FE2
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right_sharp, color: ATColors.hex307FE2)
                ],
              ),
            )
          ],
        ),
      ),
    ),
  ).show(context);
}