import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../views/widgets/common_widgets/custom_container_widget.dart';
import '../../views/widgets/common_widgets/image_loader_widget.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String yesString,
  required String noString
}) async{
  return await showDialog<bool?>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: ATColors.indicatorDark.withOpacity(0.82),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      title: Text(
        title, maxLines: 3, textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: ATFontSizes.size17,
        ),
      ),
      content: content.isNotEmpty ? Text(
        content, maxLines: 3, textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: ATFontSizes.size13,
        ),
      ): const SizedBox.shrink(),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        GestureDetector(
          onTap: () => context.pop(true),
          child: Text(
            yesString,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: ATFontSizes.size17,
              color: ATColors.hex307FE2
            ),
          ),
        ),
        GestureDetector(
          onTap: () => context.pop(false),
          child: Text(
            noString,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: ATFontSizes.size17,
              color: ATColors.hex307FE2
            ),
          ),
        ),
      ],
    )
  );
}





Future<bool?> showKickOutConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required ObjectWithNotifier<Host> listener
}) async{
  return await showDialog<bool?>(
    context: context,
    barrierColor: ATColors.black.withOpacity(0.8),
    builder: (_) => AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      backgroundColor: ATColors.hex202020,
      contentPadding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ATContainer(
                clipBehavior: Clip.hardEdge,
                height: 43, width: 43, radius: 30,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: AmptiveImageLoaderWidget(
                    imagePath: listener.obj.profilePicture ?? ''
                  )
                ),
              ),
              Positioned(
                top: -1, right: -5, 
                child: ATContainer(
                  color: ATColors.hexECO404,
                  height: 17, width: 17,
                  boxShape: BoxShape.circle,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(Icons.close)
                  ),
                ),
              )
            ],
          ),
          const Gap(15),
          Text(
            title, maxLines: 3, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: ATFontSizes.size17,
            ),
          ),
          const Gap(10),
          Text(
            content, maxLines: 3, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: ATFontSizes.size13,
            ),
          ),
          const Gap(20),
          SizedBox(
            width: ATHelperFuncs.getScreenWidth(context),
            child: AmptiveElevatedButtonWidget(
              bgColor: ATColors.whiteColor,
              fgColor: ATColors.black,
              onPressed: () => context.pop(true),
              buttonTitle: ATStrings.KICK_OUT_LISTENER,
            ),
          ),
          const Gap(20),
          GestureDetector(
            onTap: () => context.pop(false),
            child: Text(
              ATStrings.CANCEL,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: ATFontSizes.size15,

              ),
            ),
          ),
        ],
      ),
    )
  );
}