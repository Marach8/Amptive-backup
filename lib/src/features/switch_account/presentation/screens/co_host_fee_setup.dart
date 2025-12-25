import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/profile/bloc/animation_bloc.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../profile/bloc/fees_setup_bloc.dart';
import '../switch_acct/switch_acct_export.dart';

class CoHostFeeSetupScreen extends StatefulWidget {
  const CoHostFeeSetupScreen({super.key});

  @override
  State<CoHostFeeSetupScreen> createState() => _CoHostFeeSetupScreenState();
}

class _CoHostFeeSetupScreenState extends State<CoHostFeeSetupScreen> {
  late final TextEditingController _cntrl;
  final String defaultFee = '0';
  
  @override 
  void initState(){
    super.initState();
    final int? selectedFee = context.read<CohostFeeSetupBloc>().state.first;
    _cntrl = TextEditingController(
      text: selectedFee != null ? selectedFee.toString() : defaultFee
    )..addListener(_handleBtnActivation);
  }

  void _handleBtnActivation(){
    ATHelperFuncs.callDebouncer(
      500,
      () => context.read<CohostFeeSetupBloc>()
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
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(     
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 56),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(7, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const ATRoundedBackBtn(),
                    Text(
                      ATStrings.COHOST_FEE_SETUP,
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                    const SizedBox(width: 30,),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    BlocSelector<CohostFeeSetupBloc, List<int?>, int?>(
                      selector: (List<int?> state) => state.last,
                      builder: (_, int? state) {
                        if(state == null) return const SizedBox.shrink();
                        return const CohostFeeDescInfo();
                      }
                    ),
                
                    ATTextFormField(
                      controller: _cntrl,
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
                        child: Text(
                          ATStrings.nairaText, 
                          style: context.textTheme.headlineMedium,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero
                    ),
                    const SizedBox(height: 10),
                    BlocSelector<CohostFeeSetupBloc,List<int?>, int?>(
                      selector: (List<int?> state) => state.first,
                      builder: (_, int? state) {
                        return RowOfCustomFees(
                          selectedFee: state,
                          onFeeTap: (int tappedFee){
                            _cntrl.text = tappedFee.toString();
                            context.read<CohostFeeSetupBloc>().selectFee(tappedFee);
                          },
                        );
                      }
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ATStrings.ALLOW_FREE_COHOSTING, maxLines: 2,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: ATSizes.size11,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 60),
          child: _BottomSheetContent(),
        ),
      ),
    );
  }
}



class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CohostFeeSetupBloc, List<int?>, int?>(
      selector: (List<int?> state) => state.first,
      builder: (_, int? state) {
        final bool shouldActivate = state != null && state != 0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Amptive charges 0% fee on payment from creators',
              textAlign: TextAlign.center, maxLines: 2,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: ATColors.white.withValues(alpha: 0.4),
              )
            ),
            const SizedBox(height: 10),
            ATPlainElevatedBtn(
              onPressed: shouldActivate ? (){
                context.read<SwitchAcctSuccessAnimBloc>().reset();
                context.pushNamed(ATRoutes.CREATOR_SUCCESS);
              } : null,
              btnTitle: ATStrings.CONTINUE
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: (){},
              radius: 5,
              child: Text(
                ATStrings.SETUP_LATER,
                style: Theme.of(context).textTheme.bodyLarge
              ),
            ),
          ],
        );
      }
    );
  }
}
