import 'dart:io';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../constants/strings/other_strings.dart';

import 'dart:developer' as marach show log;

Future<void> showEventPaymentFeeDialog({
  required BuildContext context,
  required ValueNotifier<String> notifier
})async{
  final activateSetFeeBtn = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();

  return await showModalBottomSheet(
    constraints: BoxConstraints(maxHeight: 450.h),
    backgroundColor: AmptiveColors.brandBlackColor,
    // constraints: BoxConstraints.expand(height: AmptiveHelperFunctions.getScreenHeight(context)),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15)
      )
    ),
    builder: (_){      
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Platform.isAndroid
                  ? Icon(
                    Icons.keyboard_arrow_down,
                    color: AmptiveColors.whiteColor.withOpacity(0.6),
                  ) : AmptiveCustomContainer(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    radius: 5, height: 4, width: 30,
                    color: AmptiveColors.whiteColor.withOpacity(0.6),
                    child: const SizedBox.shrink(),
                  ),
              ),
            ),
            const Gap(5),
            const Align(
              alignment: Alignment.center,
              child: AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.PADLOCK)
            ),
            const Gap(10),

            Align(
              alignment: Alignment.center,
              child: Text(
                AmptiveOtherStrings.AUDIENCE_ACCESS,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Gap(20),
            Text(
              maxLines: 5,
              AmptiveOtherStrings.AMOUNT_2_CHARGE_4_EVENT,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AmptiveColors.subtitleColor
              ),
            ),
            const Gap(20),

            Form(
              key: formKey,
              child: AmptiveTextFormFieldWidget(
                controller: TextEditingController(),
                disableBlueBorder: true,
                hintText: '0',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                keyboardType: TextInputType.number,
                validator: (text){
                  if(text?.isEmpty ?? false){
                    return AmptiveOtherStrings.EMPTY_FIELD;
                  }
                  return null;
                },
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text('N'),
                ),
                onChanged: (text){
                  text.isNotEmpty ? activateSetFeeBtn.value = true : activateSetFeeBtn.value = false;
                },
                onSaved: (text) => notifier.value = text ?? '',
              ),
            ),

            const Spacer(),
            AmptiveRebuilderWidget(
              notifier: activateSetFeeBtn,
              shouldDispose: true,
              builder: (_, value, __) {
                return AmptiveElevatedButtonWidget(
                  margin: EdgeInsets.zero,
                  onPressed: value ? () async{
                    formKey.currentState?.save();
                    context.pop();
                  } : null,
                  buttonTitle: AmptiveOtherStrings.SET_FEE,
                  bgColor: AmptiveColors.whiteColor,
                  fgColor: AmptiveColors.black,
                );
              }
            )
          ]
        ),
      );
    }
  );
}
