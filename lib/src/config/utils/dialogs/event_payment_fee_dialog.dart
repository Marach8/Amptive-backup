import 'dart:io';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../services/create_show/create_show_service.dart';
import '../../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import '../other_strings.dart';

Future<void> showEventPaymentFeeDialog({
  required BuildContext context,
}) async {
  final ValueNotifier<bool> activateSetFeeBtn = ValueNotifier(false);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CreateShowService service = GetIt.I<CreateShowService>();

  return await showModalBottomSheet(
      constraints: BoxConstraints(maxHeight: 450.h),
      backgroundColor: ATColors.hex0D0D0D,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (_) {
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
                            radius: 5,
                            height: 4,
                            width: 30,
                            color: ATColors.white.withOpacity(0.6),
                            child: const SizedBox.shrink(),
                          ),
                  ),
                ),
                const Gap(5),
                const Align(
                    alignment: Alignment.center,
                    child: ATImgLoader(
                        imgPath: ATImgStrings.PADLOCK)),
                const Gap(10),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    ATStrings.AUDIENCE_ACCESS,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const Gap(20),
                Text(
                  maxLines: 5,
                  ATStrings.AMOUNT_2_CHARGE_4_EVENT,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: ATColors.hexC2C2C2),
                ),
                const Gap(20),
                Form(
                  key: formKey,
                  child: ATTextFormField(
                    controller: service.eventPaymentController,
                    disableBlueBorder: true,
                    hintText: '0',
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    keyboardType: TextInputType.number,
                    validator: (String? text) {
                      if (text?.isEmpty ?? false) {
                        return ATStrings.EMPTY_FIELD;
                      }
                      return null;
                    },
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('₦'),
                    ),
                    onChanged: (String text) {
                      text.isNotEmpty
                          ? activateSetFeeBtn.value = true
                          : activateSetFeeBtn.value = false;
                    },
                    onSaved: (String? text) {
                      if (text == null || text == "") return;

                      service.userEventFee =
                          double.parse(service.eventPaymentController.text);
                    },
                  ),
                ),
                const Spacer(),
                AmptiveRebuilderWidget(
                    notifier: activateSetFeeBtn,
                    shouldDispose: true,
                    builder: (_, bool value, __) {
                      return AmptiveElevatedButtonWidget(
                        margin: EdgeInsets.zero,
                        onPressed: value
                            ? () async {
                                formKey.currentState?.save();
                                context.pop();
                              }
                            : null,
                        buttonTitle: ATStrings.SET_FEE,
                        bgColor: ATColors.white,
                        fgColor: ATColors.black,
                      );
                    })
              ]),
        );
      });
}
