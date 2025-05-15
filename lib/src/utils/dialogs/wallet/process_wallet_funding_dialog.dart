import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/features/main_app/wallet/bloc/new_file.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_slide.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<bool?> processWalletFundingDialog({
  required BuildContext context,
  required String? paymentMethod
}){
  return showCupertinoModalPopup<bool>(
    context: context,
    barrierColor: ATColors.black.withValues(alpha: 0.95),
    builder: (dialogContext) {
      return BlocProvider(
        create: (_) => _WalletFundingBloc()..processWalletFunding(),
        child: Builder(
          builder: (blocContext) => SizedBox(
            height: ATHelperFuncs.getScreenHeight(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: BlocBuilder<_WalletFundingBloc, bool?>(
                builder: (_, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if(state == null) const ATLoadingIndicator(),
                              if(state == null) const SizedBox(height: 20,),
                              if(state == null) Text(
                                ATStrings.FUNDING_WALLET,
                                textAlign: TextAlign.center, maxLines: 2,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                                                
                              if(state == true) const Icon(Icons.check_circle, size: 50,), 
                              if(state == false) Icon(Icons.cancel, size: 50, color: ATColors.textRedColor),
                              const SizedBox(height: 20,),
                                                
                              if(state != null) Text(
                                state ? ATStrings.WALLET_FUNDING_SUCCESS : ATStrings.WALLET_FUNDIND_FAILED,
                                textAlign: TextAlign.center, maxLines: 2,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: ATFontSizes.size23
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
              
                      BlocBuilder<_WalletFundingBloc, bool?>(
                        builder: (_, state) {
                          return ATAnimatedSlide(
                            condition: state == null,
                            startOffset: const Offset(0, 1.5), 
                            endOffset: const Offset(0, 0),
                            child: ATPlainElevatedBtn(
                              onPressed: () => dialogContext.pop(state),
                              btnTitle: ATStrings.BACK_2_WALLET,
                            ),
                          );
                        }
                      ),
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      );
    }
  );
}




class _WalletFundingBloc extends Cubit<bool?>{
  _WalletFundingBloc(): super(null);
  
  void processWalletFunding()async{
    await Future.delayed(const Duration(seconds: 3));
    emit(true);
  }
} 