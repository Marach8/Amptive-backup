import 'package:amptive/src/features/upgrade_account/presentation/screens/subscription_plan_screen.dart';
import 'package:amptive/src/features/upgrade_account/presentation/widgets/row_of_custom_fees.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';


Future<SubscriptionPlanData?> showEventsSubscriptionSetupModal({
  required BuildContext context,
  SubscriptionPlanData? existingSubPlanData,
}) async {
  return await showModalBottomSheet<SubscriptionPlanData>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: ATColors.hex202020,
      barrierColor: ATColors.black.withValues(alpha: 0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14), topRight: Radius.circular(14)),
      ),
      builder: (_) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          builder: (BuildContext context, ScrollController scrollController) {
            return _SubPlanWidget(
              existingSubPlanData: existingSubPlanData,
              scrollController: scrollController,
            );
            // final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
            // final double bottom = bottomInset > 0 ? bottomInset + 10 : 0.0;
            // return AnimatedPadding(
            //   duration: const Duration(milliseconds: 500),
            //   padding: EdgeInsets.fromLTRB(15, 5, 15, bottom),
            //   child: Material(
            //     color: ATColors.transparent,
            //     child: _SubPlanWidget(
            //       existingSubPlanData: existingSubPlanData,
            //       scrollController: scrollController,
            //     ),
            //   ),
            // );
          }
        )
      );
}

class _SubPlanWidget extends StatefulWidget {
  const _SubPlanWidget({
    this.existingSubPlanData,
    required this.scrollController,
  });

  final SubscriptionPlanData? existingSubPlanData;
  final ScrollController scrollController;

  @override
  State<_SubPlanWidget> createState() => _AddSubPlanWidgetState();
}

class _AddSubPlanWidgetState extends State<_SubPlanWidget> {
  late final TextEditingController _subAmountCntrl;
  late final ValueNotifier<bool>_setFeeButtonNotifier;

  final String defaultPrice = '0';

  @override
  void initState() {
    super.initState();
    _subAmountCntrl = TextEditingController(
        text: widget.existingSubPlanData?.subAmount?.toString() ?? defaultPrice)
      ..addListener(_handleSetFeeButtonActivation);

    _setFeeButtonNotifier = ValueNotifier<bool>(
        widget.existingSubPlanData?.subAmount != null ||
            widget.existingSubPlanData?.oneTimePaymentAmount != null);
  }

  void _handleSetFeeButtonActivation() {
    ATHelperFuncs.callDebouncer(500, () {
      final double? subAmount = double.tryParse(_subAmountCntrl.text.trim());
      _setFeeButtonNotifier.value = (subAmount != null && subAmount > 0);
    });
  }

  @override
  void dispose() {
    _subAmountCntrl.dispose();
    _setFeeButtonNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ATModalDismisser(),
          const SizedBox(height: 12),
          const ATImgLoader(imgPath: ATImgStrings.padlock),
          const SizedBox(height: 15),
          Text(ATStrings.audienceAccess, style: context.textTheme.bodyLarge),
          const SizedBox(height: 15),
          Text(ATStrings.enterAmountToChargeForEvent,
              maxLines: 2,
              style: context.textTheme.labelSmall?.copyWith(
                  color: ATColors.hexC2C2C2.withValues(alpha: 0.76))),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                children: <Widget>[
                   ATTextFormField(
                    controller: _subAmountCntrl,
                    fillColor: ATColors.white.withValues(alpha: 0.1),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onTapOutside: (_) {},
                    disableBlueBorder: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: ATColors.transparent)),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(ATStrings.nairaText,
                          style: context.textTheme.headlineMedium),
                    ),
                    contentPadding: EdgeInsets.zero),
                const SizedBox(height: 20),
                RowOfCustomFees(
                  initialSelectedFee: widget.existingSubPlanData?.subAmount?.toInt(),
                  onFeeTap: (int tappedFee) {
                    _subAmountCntrl.text = tappedFee.toString();
                  },
                ),
                ],
              ),
            ),
          ),
      
          Text('Tier 1 (${ATStrings.nairaText}100-${ATStrings.nairaText}4999), Tier 2 (${ATStrings.nairaText}5000-${ATStrings.nairaText}9999), Tier 3 (${ATStrings.nairaText}10k+)',
              maxLines: 2,
              style: context.textTheme.labelSmall?.copyWith(
                color: ATColors.white.withValues(alpha: 0.4),
              )),
          const SizedBox(height: 15),
          ValueListenableBuilder<bool>(
              valueListenable: _setFeeButtonNotifier,
              builder: (_, bool shouldSetFee, __) {
                return ATPlainElevatedBtn(
                    fgColor: ATColors.black,
                    bgColor: ATColors.white,
                    onPressed: shouldSetFee ? () {
                      final double? selectedSubAmount =
                          double.tryParse(_subAmountCntrl.text.trim());
                      context.pop(
                        SubscriptionPlanData(
                          entryPoint: widget.existingSubPlanData!.entryPoint,
                          subAmount: selectedSubAmount,
                        )
                      );
                    }
                  : null,
                  btnTitle: ATStrings.setFee);
              }),
        ],
      ),
    );
  }
}

