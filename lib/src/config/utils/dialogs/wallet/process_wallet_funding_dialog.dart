import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/shared/animated_slide.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
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
    builder: (BuildContext dialogContext) {
      return BlocProvider(
        create: (_) => _WalletFundingBloc()..processWalletFunding(),
        child: Builder(
          builder: (BuildContext blocContext) => SizedBox(
            height: ATHelperFuncs.getScreenHeight(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: BlocBuilder<_WalletFundingBloc, bool?>(
                builder: (_, bool? state) {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
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
                                  fontSize: ATSizes.size23
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
              
                      BlocBuilder<_WalletFundingBloc, bool?>(
                        builder: (_, bool? state) {
                          return ATAnimatedSlide(
                            shouldSlide: state == null,
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