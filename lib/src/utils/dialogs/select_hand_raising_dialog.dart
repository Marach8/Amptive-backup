import 'dart:io';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../constants/strings/other_strings.dart';

Future<void> showHandRaisingDialog(BuildContext context)async{
  final allowNotifier = ValueNotifier(false);
  final doNotAllowNotifier = ValueNotifier(false);
  final activateBtnNotifier = ValueNotifier(false);
  CreateShowService service = GetIt.I<CreateShowService>();

  return await showModalBottomSheet(
    backgroundColor: AmptiveColors.brandBlack,
    constraints: BoxConstraints.expand(height: AmptiveHelperFunctions.getScreenHeight(context)),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    builder: (_){      
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
        child: Column(
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
                  const Icon(Icons.front_hand_outlined),
                  const Gap(5),
                  Text(
                    AmptiveOtherStrings.HAND_RAISING,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const Gap(20),
            Text(
              maxLines: 3,
              AmptiveOtherStrings.CNTRL_HAND_RAISING,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AmptiveColors.hexC2C2C2
              ),
            ),
            const Gap(20),
        
            AmptiveRebuilderWidget(
              notifier: allowNotifier,
              shouldDispose: true,
              builder: (_, value, __) {
                return AmptiveCustomContainer(
                  duration: 100,
                  onTap: (){
                    activateBtnNotifier.value = !value;
                    doNotAllowNotifier.value = false;
                    allowNotifier.value = !value;
                    service.handRaisingController.text=  AmptiveOtherStrings.ALLOW;
                  },
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                  radius: 15,
                  color: AmptiveColors.grey1Color,
                  border: Border.all(
                    width: 2,
                    color: value ? AmptiveColors.brandBlue : AmptiveColors.transparentColor
                  ),
                  child: Row(
                    children: [
                      AmptiveCustomContainer(
                        height: 20, width: 20, radius: 20,
                        padding: const EdgeInsets.all(3),
                        color: value ? AmptiveColors.brandBlue : AmptiveColors.transparentColor,
                        border: Border.all(
                          color: value ? AmptiveColors.brandBlue : AmptiveColors.whiteColor,
                          strokeAlign: 5.0
                        ),
                        child: const SizedBox.shrink()
                      ),
                      const Gap(10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AmptiveOtherStrings.ALLOW,
                              style: Theme.of(context).textTheme.bodyMedium
                            ),
                            Text(
                              maxLines: 5,
                              AmptiveOtherStrings.AUDIENCE_CAN_RAISE_HAND,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AmptiveColors.hexC2C2C2
                              ),
                            ),
                          ],
                        ),
                      ),                      
                    ],
                  ),
                );
              }
            ),
        
            const Gap(15),
        
            AmptiveRebuilderWidget(
              shouldDispose: true,
              notifier: doNotAllowNotifier,
              builder: (_, value, __) {
                return AmptiveCustomContainer(
                  onTap: (){
                    activateBtnNotifier.value = !value;
                    allowNotifier.value = false;
                    doNotAllowNotifier.value = !value;
                    service.handRaisingController.text=  AmptiveOtherStrings.DISALLOW;

                  },
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                  radius: 15, duration: 100,
                  color: AmptiveColors.grey1Color,
                  border: Border.all(
                    width: 2,
                    color: value ? AmptiveColors.brandBlue : AmptiveColors.transparentColor
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          AmptiveCustomContainer(
                            height: 20, width: 20, radius: 20,
                            padding: const EdgeInsets.all(3),
                            color: value ? AmptiveColors.brandBlue : AmptiveColors.transparentColor,
                            border: Border.all(
                              color: value ? AmptiveColors.brandBlue : AmptiveColors.whiteColor,
                              strokeAlign: 5.0
                            ),
                            child: const SizedBox.shrink()
                          ),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AmptiveOtherStrings.DISALLOW,
                                  style: Theme.of(context).textTheme.bodyMedium
                                ),
                                Text(
                                  maxLines: 5,
                                  AmptiveOtherStrings.AUDIENCE_CANNOT_RAISE_HAND,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AmptiveColors.hexC2C2C2
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            ),
            const Spacer(),
        
            AmptiveRebuilderWidget(
              notifier: activateBtnNotifier,
              shouldDispose: true,
              builder: (_, value, __) {
                return AmptiveElevatedButtonWidget(
                  margin: EdgeInsets.zero,
                  onPressed: value ? () async{
                    Navigator.pop(context);
                  } : null,
                  buttonTitle: AmptiveOtherStrings.CONTINUE,
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
