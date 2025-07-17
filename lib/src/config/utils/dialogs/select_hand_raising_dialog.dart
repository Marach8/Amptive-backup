import 'dart:io';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../other_strings.dart';

Future<void> showHandRaisingDialog(BuildContext context)async{
  final ValueNotifier<bool> allowNotifier = ValueNotifier(false);
  final ValueNotifier<bool> doNotAllowNotifier = ValueNotifier(false);
  final ValueNotifier<bool> activateBtnNotifier = ValueNotifier(false);
  CreateShowService service = GetIt.I<CreateShowService>();

  return await showModalBottomSheet(
    backgroundColor: ATColors.hex0D0D0D,
    constraints: BoxConstraints.expand(height: ATHelperFuncs.getScreenHeight(context)),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    builder: (_){      
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
        child: Column(
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
                  const Icon(Icons.front_hand_outlined),
                  const Gap(5),
                  Text(
                    ATStrings.HAND_RAISING,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const Gap(20),
            Text(
              maxLines: 3,
              ATStrings.CNTRL_HAND_RAISING,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ATColors.hexC2C2C2
              ),
            ),
            const Gap(20),
        
            AmptiveRebuilderWidget(
              notifier: allowNotifier,
              shouldDispose: true,
              builder: (_, bool value, __) {
                return ATContainer(
                  duration: 100,
                  onTap: (){
                    activateBtnNotifier.value = !value;
                    doNotAllowNotifier.value = false;
                    allowNotifier.value = !value;
                    service.handRaisingController.text=  ATStrings.ALLOW;
                  },
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                  radius: 15,
                  color: ATColors.hex2D2D2D,
                  border: Border.all(
                    width: 2,
                    color: value ? ATColors.hex307FE2 : ATColors.trsprnt
                  ),
                  child: Row(
                    children: <Widget>[
                      ATContainer(
                        height: 20, width: 20, radius: 20,
                        padding: const EdgeInsets.all(3),
                        color: value ? ATColors.hex307FE2 : ATColors.trsprnt,
                        border: Border.all(
                          color: value ? ATColors.hex307FE2 : ATColors.white,
                          strokeAlign: 5.0
                        ),
                        child: const SizedBox.shrink()
                      ),
                      const Gap(10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              ATStrings.ALLOW,
                              style: Theme.of(context).textTheme.bodyMedium
                            ),
                            Text(
                              maxLines: 5,
                              ATStrings.AUDIENCE_CAN_RAISE_HAND,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: ATColors.hexC2C2C2
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
              builder: (_, bool value, __) {
                return ATContainer(
                  onTap: (){
                    activateBtnNotifier.value = !value;
                    allowNotifier.value = false;
                    doNotAllowNotifier.value = !value;
                    service.handRaisingController.text=  ATStrings.DISALLOW;

                  },
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                  radius: 15, duration: 100,
                  color: ATColors.hex2D2D2D,
                  border: Border.all(
                    width: 2,
                    color: value ? ATColors.hex307FE2 : ATColors.trsprnt
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ATContainer(
                            height: 20, width: 20, radius: 20,
                            padding: const EdgeInsets.all(3),
                            color: value ? ATColors.hex307FE2 : ATColors.trsprnt,
                            border: Border.all(
                              color: value ? ATColors.hex307FE2 : ATColors.white,
                              strokeAlign: 5.0
                            ),
                            child: const SizedBox.shrink()
                          ),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  ATStrings.DISALLOW,
                                  style: Theme.of(context).textTheme.bodyMedium
                                ),
                                Text(
                                  maxLines: 5,
                                  ATStrings.AUDIENCE_CANNOT_RAISE_HAND,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: ATColors.hexC2C2C2
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
              builder: (_, bool value, __) {
                return AmptiveElevatedButtonWidget(
                  margin: EdgeInsets.zero,
                  onPressed: value ? () async{
                    Navigator.pop(context);
                  } : null,
                  buttonTitle: ATStrings.CONTINUE,
                  bgColor: ATColors.white,
                  fgColor: ATColors.black,
                );
              }
            )
          ]
        ),
      );
    }
  );
}
