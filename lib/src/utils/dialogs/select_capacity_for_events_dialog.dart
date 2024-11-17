import 'dart:io';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../constants/strings/other_strings.dart';


Future<void> showEventCapacitySelectionDialog({
  required BuildContext context,
  // required ValueNotifier<String> notifier
})async{
  //final activateSetFeeBtn = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();

  return await showModalBottomSheet(
    constraints: BoxConstraints(maxHeight: 500.h),
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
                  )
                  : AmptiveCustomContainer(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    radius: 5, height: 4, width: 30,
                    color: AmptiveColors.whiteColor.withOpacity(0.6),
                    child: const SizedBox.shrink(),
                  ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.group_outlined),
                  Text(
                    AmptiveOtherStrings.CAPACITY,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const Gap(20),
            Text(
              maxLines: 5,
              AmptiveOtherStrings.MAX_CAPACITY,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AmptiveColors.subtitleColor
              ),
            ),
            const Gap(20),

            Form(
              key: formKey,
              child: AmptiveTextFormFieldWidget(
                controller: TextEditingController(text: '1'),
                disableBlueBorder: true,
                //hintText: '0',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                keyboardType: TextInputType.number,
                validator: (text){
                  if(text?.isEmpty ?? false){
                    return AmptiveOtherStrings.EMPTY_FIELD;
                  }
                  return null;
                },
                //onSaved: (text) => notifier.value = text ?? '',
              ),
            ),

            const Spacer(),
            Text(
              maxLines: 5,
              AmptiveOtherStrings.MAX_CAPACITY_LIMIT,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AmptiveColors.subtitleColor
              ),
            ),
            const Gap(20),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AmptiveElevatedButtonWidget(
                  margin: EdgeInsets.zero,
                  onPressed: () async{
                    formKey.currentState?.save();
                    context.pop();
                  },
                  buttonTitle: AmptiveOtherStrings.SET_CAPACITY,
                  bgColor: AmptiveColors.whiteColor,
                  fgColor: AmptiveColors.black,
                ),
                const Gap(20),
                Text(
                  AmptiveOtherStrings.REMOVE,
                  style: Theme.of(context).textTheme.headlineMedium
                ),
                const Gap(10),
              ],
            )
          ]
        ),
      );
    }
  );
}
