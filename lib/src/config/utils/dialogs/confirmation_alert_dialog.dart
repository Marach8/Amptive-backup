import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/custom_container_widget.dart';
import '../../../views/widgets/common_widgets/image_loader_widget.dart';

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
      backgroundColor: ATColors.hex252525,
      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text(
              title, maxLines: 3, textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: ATSizes.size17,
              ),
            ),
          ),
          if(content.isNotEmpty)Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              content, maxLines: 3, textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                fontSize: ATSizes.size13,
              ),
            ),
          ),
          const ATDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () => context.pop(true),
                child: Text(
                  yesString,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: ATSizes.size17,
                    color: ATColors.hex307FE2
                  ),
                ),
              ),
              const ATDivider(axis: AxisType.vertical, height: 50),
              GestureDetector(
                onTap: () => context.pop(false),
                child: Text(
                  noString,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: ATSizes.size17,
                    color: ATColors.hex307FE2
                  ),
                ),
              ),
            ],
          )
        ],
      )
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
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              ATContainer(
                clipBehavior: Clip.hardEdge,
                height: 43, width: 43, radius: 30,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: ATImgLoader(
                    imgPath: listener.obj.profilePicture ?? ''
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
          const SizedBox(height: 15),
          Text(
            title, maxLines: 3, textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: ATSizes.size17,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content, maxLines: 3, textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              fontSize: ATSizes.size13,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: ATHelperFuncs.getScreenWidth(context),
            child: AmptiveElevatedButtonWidget(
              bgColor: ATColors.white,
              fgColor: ATColors.black,
              onPressed: () => context.pop(true),
              buttonTitle: ATStrings.KICK_OUT_LISTENER,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => context.pop(false),
            child: Text(
              ATStrings.cancel,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: ATSizes.size15,
              ),
            ),
          ),
        ],
      ),
    )
  );
}