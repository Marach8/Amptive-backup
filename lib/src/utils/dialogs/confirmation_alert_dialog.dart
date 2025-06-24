import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
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
      backgroundColor: ATColors.hex252525.withOpacity(0.82),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: ATFontSizes.size17,
              ),
            ),
          ),
          if(content.isNotEmpty)Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              content, maxLines: 3, textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: ATFontSizes.size13,
              ),
            ),
          ),
          const ATDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
              const ATDivider(axis: AxisType.vertical, height: 50),
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
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
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
              bgColor: ATColors.white,
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