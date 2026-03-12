import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/switch_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../switch_acct/switch_acct_export.dart';

Future<SubscriptionPlanData?> showSubPlanSetupModal({
  required BuildContext context,
  SubscriptionPlanData? existingSubPlanData,
}) async {
  return await showModalBottomSheet<SubscriptionPlanData>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: ATColors.hex202020,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14), topRight: Radius.circular(14)),
      ),
      builder: (_) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.93,
          builder: (BuildContext context, ScrollController scrollController) {
            final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
            final double bottom = bottomInset > 0 ? bottomInset + 10 : 0.0;
            return AnimatedPadding(
              duration: const Duration(milliseconds: 500),
              padding: EdgeInsets.fromLTRB(15, 5, 15, bottom),
              child: Material(
                color: ATColors.transparent,
                child: _SubPlanWidget(
                  existingSubPlanData: existingSubPlanData,
                  scrollController: scrollController,
                ),
              ),
            );
          }));
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
  late final TextEditingController _subAmountCntrl, _oneTimePaymentCntrl;
  late final ValueNotifier<bool> _oneTimePaymentNotifier, _setFeeButtonNotifier;

  final String defaultPrice = '0';

  @override
  void initState() {
    super.initState();
    _oneTimePaymentCntrl = TextEditingController(
        text: widget.existingSubPlanData?.oneTimePaymentAmount?.toString() 
          ?? defaultPrice)
      ..addListener(_handleSetFeeButtonActivation);

    _subAmountCntrl = TextEditingController(
        text: widget.existingSubPlanData?.subAmount?.toString() ?? defaultPrice)
      ..addListener(_handleSetFeeButtonActivation);

    _oneTimePaymentNotifier = ValueNotifier<bool>(
        (widget.existingSubPlanData?.oneTimePaymentAmount ?? 0) > 0)
        ..addListener(
          (){
            if(_oneTimePaymentNotifier.value == false){
              _oneTimePaymentCntrl.clear();
            }
          }
        );

    _setFeeButtonNotifier = ValueNotifier<bool>(
        widget.existingSubPlanData?.subAmount != null ||
            widget.existingSubPlanData?.oneTimePaymentAmount != null);
  }

  void _handleSetFeeButtonActivation() {
    ATHelperFuncs.callDebouncer(500, () {
      final double? isOneTimePaymentAmount =
          double.tryParse(_oneTimePaymentCntrl.text.trim());
      final double? subAmount = double.tryParse(_subAmountCntrl.text.trim());

      _setFeeButtonNotifier.value = (subAmount != null && subAmount > 0) ||
          (isOneTimePaymentAmount != null && isOneTimePaymentAmount > 0);
    });
  }

  @override
  void dispose() {
    _subAmountCntrl.dispose();
    _oneTimePaymentCntrl.dispose();
    _oneTimePaymentNotifier.dispose();
    _setFeeButtonNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ATModalDismisser(),
          const SizedBox(height: 20),
          const ATImgLoader(imgPath: ATImgStrings.padlock),
          const SizedBox(height: 15),
          Text(ATStrings.addNewPlan, style: context.textTheme.bodyLarge),
          const SizedBox(height: 15),
          Text(ATStrings.specifyFee,
              maxLines: 2,
              style: context.textTheme.labelSmall?.copyWith(
                  color: ATColors.hexC2C2C2.withValues(alpha: 0.76))),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          const ATDivider(),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Accept One Time Payment',
                  style: context.textTheme.bodySmall
                      ?.copyWith(fontSize: ATSizes.size15)),
              ValueListenableBuilder<bool>(
                  valueListenable: _oneTimePaymentNotifier,
                  builder: (_, bool state, __) {
                    return ATSwitch(
                        value: state,
                        onChanged: (bool val) {
                          _oneTimePaymentNotifier.value = val;
                        });
                  })
            ],
          ),
          ValueListenableBuilder<bool>(
              valueListenable: _oneTimePaymentNotifier,
              builder: (_, bool? state, __) {
                final bool isActive = state ?? false;
                return Text(
                    maxLines: 4,
                    'Let non-subscribers access a single live show without subscribing. They will need to pay to join any episode',
                    style: context.textTheme.labelSmall?.copyWith(
                        color: ATColors.white
                            .withValues(alpha: isActive ? 0.4 : 0.1)));
              }),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: context.screenWidth * 0.4,
              child: ValueListenableBuilder<bool>(
                  valueListenable: _oneTimePaymentNotifier,
                  builder: (_, bool isActive, __) {
                    return ATTextFormField(
                        controller: _oneTimePaymentCntrl,
                        fillColor: isActive ? null : ATColors.hex202020,
                        enabled: isActive,
                        onTapOutside: (_){},
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        hintStyle: Theme.of(context)
                            .inputDecorationTheme
                            .hintStyle
                            ?.copyWith(
                                color: isActive ? null : ATColors.hex313131),
                        hintText: '100 (1%)',
                        disableBlueBorder: true,
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: ATColors.hex313131)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                BorderSide(color: ATColors.transparent)),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(ATStrings.nairaText,
                              style: context.textTheme.headlineMedium?.copyWith(
                                  color: isActive ? null : ATColors.hex313131)),
                        ),
                        contentPadding: EdgeInsets.zero);
                  }),
            ),
          ),
          const SizedBox(height: 80),
          Text('Amptive charges a 0% fee on subscription',
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
                      final double? selectedOneTimePayment =
                          double.tryParse(_oneTimePaymentCntrl.text.trim());
                      
                      if(_oneTimePaymentNotifier.value == true){
                        context.pop(
                          SubscriptionPlanData(
                            entryPoint: widget.existingSubPlanData!.entryPoint,
                            oneTimePaymentAmount: selectedOneTimePayment,
                          )
                        );
                      }
                      else {
                        context.pop(
                          SubscriptionPlanData(
                            entryPoint: widget.existingSubPlanData!.entryPoint,
                            subAmount: selectedSubAmount,
                          )
                        );
                      }
                    }
                  : null,
                  btnTitle: ATStrings.setFee);
              }),
        ],
      ),
    );
  }
}
