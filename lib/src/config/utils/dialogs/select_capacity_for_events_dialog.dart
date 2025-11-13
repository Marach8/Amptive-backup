import 'dart:io';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../services/create_show/create_show_service.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import '../other_strings.dart';


Future<void> showEventCapacitySelectionDialog({
  required BuildContext context,
  // required ValueNotifier<String> notifier
})async{
  //final activateSetFeeBtn = ValueNotifier(false);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CreateShowService service = GetIt.I<CreateShowService>();


  return await showModalBottomSheet(
    constraints: BoxConstraints(maxHeight: 500.h),
    backgroundColor: ATColors.hex0D0D0D,
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
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Platform.isAndroid
                  ? Icon(
                    Icons.keyboard_arrow_down,
                    color: ATColors.white.withOpacity(0.6),
                  )
                  : ATContainer(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    radius: 5, height: 4, width: 30,
                    color: ATColors.white.withOpacity(0.6),
                    child: const SizedBox.shrink(),
                  ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.group_outlined),
                  Text(
                    ATStrings.CAPACITY,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              maxLines: 5,
              ATStrings.MAX_CAPACITY,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ATColors.hexC2C2C2
              ),
            ),
            const SizedBox(height: 20),

            Form(
              key: formKey,
              child: ATTextFormField(
                controller: service.capacityController,
                disableBlueBorder: true,
                //hintText: '0',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                keyboardType: TextInputType.number,
                validator: (String? text){
                  if(text?.isEmpty ?? false){
                    return ATStrings.EMPTY_FIELD;
                  }
                  return null;
                },
                //onSaved: (text) => notifier.value = text ?? '',
              ),
            ),

            const Spacer(),
            Text(
              maxLines: 5,
              ATStrings.MAX_CAPACITY_LIMIT,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ATColors.hexC2C2C2
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AmptiveElevatedButtonWidget(
                  margin: EdgeInsets.zero,
                  onPressed: () async{
                    formKey.currentState?.save();
                    context.pop();
                  },
                  buttonTitle: ATStrings.SET_CAPACITY,
                  bgColor: ATColors.white,
                  fgColor: ATColors.black,
                ),
                const SizedBox(height: 20),

                AmptiveElevatedButtonWidget(
                  margin: EdgeInsets.zero,
                  onPressed: () async{
                    service.capacityController.clear();
                    context.pop();
                  },
                  buttonTitle: ATStrings.REMOVE,
                  bgColor: ATColors.transparent,
                  fgColor: ATColors.white,
                ),
                const SizedBox(height: 10),
              ],
            )
          ]
        ),
      );
    }
  );
}
