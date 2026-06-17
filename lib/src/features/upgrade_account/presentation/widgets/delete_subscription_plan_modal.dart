import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Future<bool?> showDeleteSubscriptionPlanOptionModal(
    BuildContext context) async {
  return await showCupertinoModalPopup<bool>(
    context: context,
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    builder: (BuildContext modalContext) => Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 70),
      decoration: BoxDecoration(
          color: ATColors.hex202020,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Align(
              alignment: Alignment.center, child: ATModalDismisser()),
          const SizedBox(height: 5),
          Material(
            color: ATColors.transparent,
            child: InkWell(
              onTap: () => Navigator.pop(modalContext, true),
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.remove_circle_outline,
                      color: ATColors.hexC2C2C2),
                  const SizedBox(width: 10),
                  Text(ATStrings.deletePlan,
                      style: context.textTheme.labelMedium
                          ?.copyWith(fontSize: ATSizes.size17)),
                ],
              ),
            ),
          ),
        ],
      ),
    )
  );
}
