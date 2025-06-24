import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/features/profile/bloc/fees_setup_bloc.dart';
import 'package:amptive/src/features/profile/presentation/views/profile_views_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/dismiss_modal.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


void showCreatorSubPlans(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => const _AddSubPlanWidget()
  );
}

class _AddSubPlanWidget extends StatefulWidget {
  const _AddSubPlanWidget();

  @override
  State<_AddSubPlanWidget> createState() => _AddSubPlanWidgetState();
}

class _AddSubPlanWidgetState extends State<_AddSubPlanWidget> {
  late final TextEditingController _cntrl;
  final defaultPrice = '0';
  
  @override 
  void initState(){
    super.initState();
    final selectedPrice = context.read<SubPlanSetupBloc>().state.last;
    _cntrl = TextEditingController(
      text: selectedPrice != null ? selectedPrice.toString() : defaultPrice
    )..addListener(_handleBtnActivation);
  }

  void _handleBtnActivation(){
    ATHelperFuncs.callDebouncer(
      500,
      () => context.read<SubPlanSetupBloc>()
        .selectFee(int.tryParse(_cntrl.text.trim()))
    );
  }

  @override 
  void dispose(){
    _cntrl.removeListener(_handleBtnActivation);
    _cntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
      decoration: BoxDecoration(
        color: ATColors.hex202020,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14) 
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ATModalDismisser(),
          const SizedBox(height: 20),
          const ATImgLoader(imgPath: ATImgStrings.PADLOCK),
          const SizedBox(height: 15),
          Text(
            ATStrings.ADD_NEW_PLAN,
            style: Theme.of(context).textTheme.bodyLarge
          ),
          const SizedBox(height: 15),
          Text(
            ATStrings.SPECIFY_FEE, maxLines: 2,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
            )
          ),
          const SizedBox(height: 20),
          Material(
            color: ATColors.trsprnt,
            child: ATTextFormField(
              controller: _cntrl,
              fillColor: ATColors.white.withValues(alpha: 0.1),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              disableBlueBorder: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: ATColors.trsprnt)
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('N', style: Theme.of(context).textTheme.headlineMedium),
              ),
              contentPadding: EdgeInsets.zero
            ),
          ),
          const SizedBox(height: 20),
          BlocSelector<SubPlanSetupBloc,List<int?>, int?>(
            selector: (state) => state.first,
            builder: (_, state) {
              return RowOfCustomFees(
                selectedFee: state,
                onFeeTap: (tappedFee){
                  _cntrl.text = tappedFee.toString();
                  context.read<SubPlanSetupBloc>().selectFee(tappedFee);
                },
              );
            }
          ),
          const SizedBox(height: 80),
          Text(
            ATStrings.AMPTIVE_CHARGES_4_CREATORS, maxLines: 2,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ATColors.white.withValues(alpha: 0.4),
            )
          ),
          const SizedBox(height: 15),
          BlocSelector<SubPlanSetupBloc,List<int?>, int?>(
            selector: (state) => state.first,
            builder: (_, state) {
              final shouldActivate = state != null && state != 0;
              return ATPlainElevatedBtn(
                fgColor: ATColors.black, bgColor: ATColors.white,
                onPressed: shouldActivate ? (){
                  final selectdFee = int.tryParse(_cntrl.text.trim());
                  context.read<SubPlanSetupBloc>().setSelectedFee(selectdFee);
                  context.pop();
                } : null,
                btnTitle: ATStrings.SET_FEE
              );
            }
          ),
        ],
      ),
    );
  }
}
