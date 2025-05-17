import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/features/profile/bloc/animation_bloc.dart';
import 'package:amptive/src/views/features/profile/presentation/views/profile_views_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../bloc/fees_setup_bloc.dart';

class CoHostFeeSetupScreen extends StatefulWidget {
  const CoHostFeeSetupScreen({super.key});

  @override
  State<CoHostFeeSetupScreen> createState() => _CoHostFeeSetupScreenState();
}

class _CoHostFeeSetupScreenState extends State<CoHostFeeSetupScreen> {
  late final TextEditingController _cntrl;
  final defaultFee = '0';
  
  @override 
  void initState(){
    super.initState();
    final selectedFee = context.read<CohostFeeSetupBloc>().state.first;
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
  Widget build(context) {
    return ATAnnotatedRegion(
      child: Scaffold(     
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, kToolbarHeight * 0.8, 0, kBottomNavigationBarHeight),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(7, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: ATColors.black,
                      child: const ATRoundedBackBtn()
                    ),
                    Text(
                      ATStrings.COHOST_FEE_SETUP,
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                    const Visibility(visible: false, child: ATRoundedBackBtn()),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocSelector<CohostFeeSetupBloc, List<int?>, int?>(
                      selector: (state) => state.last,
                      builder: (_, state) {
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
                        borderSide: BorderSide(color: ATColors.trsprnt)
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text('N', style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      contentPadding: EdgeInsets.zero
                    ),
                    const SizedBox(height: 10),
                    BlocSelector<CohostFeeSetupBloc,List<int?>, int?>(
                      selector: (state) => state.first,
                      builder: (_, state) {
                        return RowOfCustomFees(
                          selectedFee: state,
                          onFeeTap: (tappedFee){
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
                        fontSize: ATFontSizes.size11,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      
        bottomSheet: const Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
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
      selector: (state) => state.first,
      builder: (_, state) {
        final shouldActivate = state != null && state != 0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ATStrings.AMTPIVE_CHARGES_4_COHOSTING, maxLines: 2,
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
            if(!shouldActivate) const SizedBox(height: 15),
            shouldActivate ? const SizedBox.shrink() : InkWell(
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
