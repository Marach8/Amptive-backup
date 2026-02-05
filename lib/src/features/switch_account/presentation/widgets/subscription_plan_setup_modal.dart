import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/profile/bloc/fees_setup_bloc.dart';
import 'package:amptive/src/views/widgets/common_widgets/modal_dismisser.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/switch_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../switch_acct/switch_acct_export.dart';


void showSubPlanSetupModal(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => const _SubPlanWidget()
  );
}

class _SubPlanWidget extends StatefulWidget {
  const _SubPlanWidget();

  @override
  State<_SubPlanWidget> createState() => _AddSubPlanWidgetState();
}

class _AddSubPlanWidgetState extends State<_SubPlanWidget> {
  late final TextEditingController _newPlanCntrl;
  final TextEditingController _oneTimePaymentCntrl = TextEditingController();
  final ValueNotifier<bool> _oneTimePaymentNotifier = ValueNotifier<bool>(false);
  final String defaultPrice = '0';
  
  @override 
  void initState(){
    super.initState();
    final int? selectedPrice = context.read<SubPlanSetupBloc>().state.last;
    _newPlanCntrl = TextEditingController(
      text: selectedPrice != null ? selectedPrice.toString() : defaultPrice
    )..addListener(_handleBtnActivation);
  }

  void _handleBtnActivation(){
    ATHelperFuncs.callDebouncer(
      500,
      () => context.read<SubPlanSetupBloc>()
        .selectAFee(int.tryParse(_newPlanCntrl.text.trim()))
    );
  }

  @override 
  void dispose(){
    _newPlanCntrl.dispose();
    _oneTimePaymentCntrl.dispose();
    _oneTimePaymentNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ATColors.transparent,
      child: Builder(
        builder: (BuildContext context) {
          final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
          final double bottom = bottomInset == 0 ? 50.0 : bottomInset +15.0;
          return Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, bottom),
            decoration: BoxDecoration(
              color: ATColors.hex202020,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14) 
              )
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ATModalDismisser(),
                  const SizedBox(height: 20),
                  const ATImgLoader(imgPath: ATImgStrings.PADLOCK),
                  const SizedBox(height: 15),
                  Text(
                    ATStrings.ADD_NEW_PLAN,
                    style: context.textTheme.bodyLarge
                  ),
                  const SizedBox(height: 15),
                  Text(
                    ATStrings.SPECIFY_FEE, maxLines: 2,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                    )
                  ),
                  const SizedBox(height: 20),
                  ATTextFormField(
                    controller: _newPlanCntrl,
                    fillColor: ATColors.white.withValues(alpha: 0.1),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    disableBlueBorder: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: ATColors.transparent)
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(ATStrings.nairaText, style: context.textTheme.headlineMedium),
                    ),
                    contentPadding: EdgeInsets.zero
                  ),
                  const SizedBox(height: 20),
                  BlocSelector<SubPlanSetupBloc,List<int?>, int?>(
                    selector: (List<int?> state) => state.first,
                    builder: (_, int? state) {
                      return RowOfCustomFees(
                        selectedFee: state,
                        onFeeTap: (int tappedFee){
                          _newPlanCntrl.text = tappedFee.toString();
                          context.read<SubPlanSetupBloc>().selectAFee(tappedFee);
                        },
                      );
                    }
                  ),
                  const SizedBox(height: 20),
                  const ATDivider(),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Accept One Time Payment',
                        style: context.textTheme.bodySmall?.copyWith(fontSize: ATSizes.size15)
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _oneTimePaymentNotifier,
                        builder: (_, bool? state, __) {
                          return ATSwitch(
                            value: state ?? false,
                            onChanged: (bool? val){
                              _oneTimePaymentNotifier.value = val ?? false;
                            }
                          );
                        }
                      )
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
                          color: ATColors.white.withValues(alpha: isActive ? 0.4 : 0.1)
                        )
                      );
                    }
                  ),
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: context.screenWidth * 0.4,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _oneTimePaymentNotifier,
                        builder: (_, bool? state, __) {
                          final bool isActive = state ?? false;
                          return ATTextFormField(
                            controller: _oneTimePaymentCntrl,
                            fillColor: isActive ? null : ATColors.hex202020,
                            enabled: isActive, keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
                              color: isActive ? null : ATColors.hex313131
                            ),
                            hintText: '100 (1%)',
                            disableBlueBorder: true,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: ATColors.hex313131)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: ATColors.transparent)
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                ATStrings.nairaText, 
                                style: context.textTheme.headlineMedium?.copyWith(
                                  color: isActive ? null : ATColors.hex313131
                                )
                              ),
                            ),
                            contentPadding: EdgeInsets.zero
                          );
                        }
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Text(
                    'Amptive charges a 0% fee on subscription',
                    maxLines: 2,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: ATColors.white.withValues(alpha: 0.4),
                    )
                  ),
                  const SizedBox(height: 15),
                  BlocSelector<SubPlanSetupBloc,List<int?>, int?>(
                    selector: (List<int?> state) => state.first,
                    builder: (_, int? state) {
                      final bool shouldActivate = state != null && state != 0;
                      return ATPlainElevatedBtn(
                        fgColor: ATColors.black, bgColor: ATColors.white,
                        onPressed: shouldActivate ? (){
                          final int? selectdFee = int.tryParse(_newPlanCntrl.text.trim());
                          context.read<SubPlanSetupBloc>().setSelectedFee(selectdFee);
                          context.pop();
                        } : null,
                        btnTitle: ATStrings.SET_FEE
                      );
                    }
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
