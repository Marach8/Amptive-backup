import 'dart:io';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/event_payment_fee_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../constants/strings/other_strings.dart';

import 'dart:developer' as marach show log;

Future<void> showSelectAudienceAccessForEventsDialog(BuildContext context)async{
  final freeAccesNotifier = ValueNotifier(false);
  final paidAccessNotifier = ValueNotifier(false);
  final activateBtnNotifier = ValueNotifier(false);
  final subAmntNotifier = ValueNotifier('');

  return await showModalBottomSheet(
    backgroundColor: AmptiveColors.brandBlackColor,
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
              child: Text(
                AmptiveOtherStrings.AUDIENCE_ACCESS,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Gap(20),
            Text(
              maxLines: 5,
              AmptiveOtherStrings.EVENT_AUDIENCE_ACCESS_DESC,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AmptiveColors.subtitleColor
              ),
            ),
            const Gap(20),
        
            AmptiveRebuilderWidget(
              notifier: freeAccesNotifier,
              shouldDispose: true,
              builder: (_, value, __) {
                return AmptiveCustomContainer(
                  duration: 100,
                  onTap: (){
                    activateBtnNotifier.value = !value;
                    paidAccessNotifier.value = false;
                    freeAccesNotifier.value = !value;
                  },
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                  radius: 15,
                  color: AmptiveColors.grey1Color,
                  border: Border.all(
                    width: 2,
                    color: value ? AmptiveColors.brandBlueColor : AmptiveColors.transparentColor
                  ),
                  child: Row(
                    children: [
                      const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.sIcon),
                      const Gap(10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AmptiveOtherStrings.FREE,
                              style: Theme.of(context).textTheme.bodyMedium
                            ),
                            Text(
                              maxLines: 5,
                              AmptiveOtherStrings.EVENT_FREE_ACCESS,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AmptiveColors.subtitleColor
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(15),
                      AmptiveCustomContainer(
                        height: 20, width: 20, radius: 20,
                        padding: const EdgeInsets.all(3),
                        color: value ? AmptiveColors.brandBlueColor : AmptiveColors.transparentColor,
                        border: Border.all(
                          color: value ? AmptiveColors.brandBlueColor : AmptiveColors.whiteColor,
                          strokeAlign: 5.0
                        ),
                        child: const SizedBox.shrink()
                      )
                    ],
                  ),
                );
              }
            ),
        
            const Gap(15),
        
            AmptiveRebuilderWidget(
              shouldDispose: true,
              notifier: paidAccessNotifier,
              builder: (_, value, __) {
                return AmptiveCustomContainer(
                  onTap: (){
                    activateBtnNotifier.value = !value;
                    freeAccesNotifier.value = false;
                    paidAccessNotifier.value = !value;
                  },
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                  radius: 15, duration: 100,
                  color: AmptiveColors.grey1Color,
                  border: Border.all(
                    width: 2,
                    color: value ? AmptiveColors.brandBlueColor : AmptiveColors.transparentColor
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.sIcon),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AmptiveOtherStrings.PAID,
                                  style: Theme.of(context).textTheme.bodyMedium
                                ),
                                Text(
                                  maxLines: 5,
                                  AmptiveOtherStrings.PAID_ACCESS,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AmptiveColors.subtitleColor
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(15),
                          AmptiveCustomContainer(
                            height: 20, width: 20, radius: 20,
                            padding: const EdgeInsets.all(3),
                            color: value ? AmptiveColors.brandBlueColor : AmptiveColors.transparentColor,
                            border: Border.all(
                              color: value ? AmptiveColors.brandBlueColor : AmptiveColors.whiteColor,
                              strokeAlign: 5.0
                            ),
                            child: const SizedBox.shrink()
                          )
                        ],
                      ),
                        
                      const Gap(15),
                      const Divider(height: 0.5),
                      const Gap(15),
                      Row(
                        children: [
                          AmptiveCustomContainer(
                            onTap: ()async{
                              await showEventPaymentFeeDialog(context: context, notifier: subAmntNotifier);
                            },
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            color: AmptiveColors.grey2Color,
                            radius: 5,
                            child: Text(
                              AmptiveOtherStrings.SETUP_PAYMENT_FEE,
                              style: Theme.of(context).textTheme.titleMedium
                            ),
                          ),
                          const Spacer(),
                          AmptiveRebuilderWidget(
                            notifier: subAmntNotifier,
                            shouldDispose: true,
                            builder: (_, value, __) {
                              return Text(
                                value.isEmpty ? value : 'N$value',
                                style: Theme.of(context).textTheme.bodyMedium
                              );
                            }
                          ),
                        ],
                      )
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
                  onPressed: value ? () async{} : null,
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

