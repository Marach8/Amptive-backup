import 'dart:io';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/event_payment_fee_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../services/create_show/create_show_service.dart';
import '../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../constants/strings/other_strings.dart';

Future<void> showSelectAudienceAccessForEventsDialog(
    BuildContext context) async {
  final freeAccesNotifier = ValueNotifier(false);
  final paidAccessNotifier = ValueNotifier(false);
  final activateBtnNotifier = ValueNotifier(false);

  CreateShowService service = GetIt.I<CreateShowService>();

  return await showModalBottomSheet(
      backgroundColor: ATColors.brandBlack,
      constraints: BoxConstraints.expand(
          height: ATHelperFuncs.getScreenHeight(context)),
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Platform.isAndroid
                    ? Icon(
                        Icons.keyboard_arrow_down,
                        color: ATColors.whiteColor.withOpacity(0.6),
                      )
                    : ATContainer(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        radius: 5,
                        height: 4,
                        width: 30,
                        color: ATColors.whiteColor.withOpacity(0.6),
                        child: const SizedBox.shrink(),
                      ),
              ),
            ),
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
              ATStrings.EVENT_AUDIENCE_ACCESS_DESC,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: ATColors.hexC2C2C2),
            ),
            const Gap(20),
            AmptiveRebuilderWidget(
                notifier: freeAccesNotifier,
                shouldDispose: true,
                builder: (_, value, __) {
                  return ATContainer(
                    duration: 100,
                    onTap: () {
                      activateBtnNotifier.value = !value;
                      paidAccessNotifier.value = false;
                      freeAccesNotifier.value = !value;
                    },
                    padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                    radius: 15,
                    color: ATColors.hex2D2D2D,
                    border: Border.all(
                        width: 2,
                        color: value
                            ? ATColors.hex307FE2
                            : ATColors.trspntColor),
                    child: Row(
                      children: [
                        const AmptiveImageLoaderWidget(
                            imagePath: ATImgStrings.PEOPLE),
                        const Gap(10),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ATStrings.FREE,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              Text(
                                maxLines: 5,
                                ATStrings.EVENT_FREE_ACCESS,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: ATColors.hexC2C2C2),
                              ),
                            ],
                          ),
                        ),
                        const Gap(15),
                        ATContainer(
                            height: 20,
                            width: 20,
                            radius: 20,
                            padding: const EdgeInsets.all(3),
                            color: value
                                ? ATColors.hex307FE2
                                : ATColors.trspntColor,
                            border: Border.all(
                                color: value
                                    ? ATColors.hex307FE2
                                    : ATColors.whiteColor,
                                strokeAlign: 5.0),
                            child: const SizedBox.shrink())
                      ],
                    ),
                  );
                }),
            const Gap(15),
            AmptiveRebuilderWidget(
                shouldDispose: true,
                notifier: paidAccessNotifier,
                builder: (_, value, __) {
                  return ATContainer(
                    onTap: () {
                      activateBtnNotifier.value = !value;
                      freeAccesNotifier.value = false;
                      paidAccessNotifier.value = !value;
                    },
                    padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                    radius: 15,
                    duration: 100,
                    color: ATColors.hex2D2D2D,
                    border: Border.all(
                        width: 2,
                        color: value
                            ? ATColors.hex307FE2
                            : ATColors.trspntColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const AmptiveImageLoaderWidget(
                                imagePath: ATImgStrings.PADLOCK),
                            const Gap(10),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ATStrings.PAID,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  Text(
                                    maxLines: 5,
                                    ATStrings.PAID_ACCESS,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color: ATColors.hexC2C2C2),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(15),
                            ATContainer(
                                height: 20,
                                width: 20,
                                radius: 20,
                                padding: const EdgeInsets.all(3),
                                color: value
                                    ? ATColors.hex307FE2
                                    : ATColors.trspntColor,
                                border: Border.all(
                                    color: value
                                        ? ATColors.hex307FE2
                                        : ATColors.whiteColor,
                                    strokeAlign: 5.0),
                                child: const SizedBox.shrink())
                          ],
                        ),
                        const Gap(15),
                        const Divider(height: 0.5),
                        const Gap(15),
                        Row(
                          children: [
                            ATContainer(
                              onTap: () async {
                                freeAccesNotifier.value = false;
                                paidAccessNotifier.value = true;
                                await showEventPaymentFeeDialog(
                                    context: context,
                                );
                              },
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              color: ATColors.grey2Color,
                              radius: 5,
                              child: Text(ATStrings.SETUP_PAYMENT_FEE,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                            const Spacer(),
                            AmptiveRebuilderWidget(
                                notifier: service.eventPaymentController,
                                builder: (_, val, __) {
                                  return Text('₦${service.eventPaymentController.text}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium);
                                }),
                          ],
                        )
                      ],
                    ),
                  );
                }),
            const Spacer(),
            AmptiveRebuilderWidget(
                notifier: activateBtnNotifier,
                shouldDispose: true,
                builder: (_, value, __) {
                  return AmptiveElevatedButtonWidget(
                    margin: EdgeInsets.zero,
                    onPressed: value
                        ? () async {
                            if (paidAccessNotifier.value) {
                              service.audienceAccessController.text =
                                  "${ATStrings.PAY} • ₦${service.userEventFee}";
                            } else if (freeAccesNotifier.value) {
                              service.audienceAccessController.text =
                                  ATStrings.FREE;
                            }

                            Navigator.pop(context);
                          }
                        : null,
                    buttonTitle: ATStrings.CONTINUE,
                    bgColor: ATColors.whiteColor,
                    fgColor: ATColors.black,
                  );
                })
          ]),
        );
      });
}
