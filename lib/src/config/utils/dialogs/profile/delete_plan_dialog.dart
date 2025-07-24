import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/dismiss_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



Future<bool?> showDeletePlanOption(BuildContext context)async{
  return await showCupertinoModalPopup<bool>(
    context: context,
    builder: (_) => Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
      decoration: BoxDecoration(
        color: ATColors.hex202020,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14) 
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Align(
            alignment: Alignment.center,
            child: ATModalDismisser()
          ),
          const SizedBox(height: 5),
          Material(
            color: ATColors.trsprnt,
            child: InkWell(
              onTap: () => context.pop(true),
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.remove_circle_outline, color: ATColors.hexC2C2C2),
                  const SizedBox(width: 10),
                  Text(
                    ATStrings.DELETE_PLAN,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: ATFontSizes.size17
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
  );
}
