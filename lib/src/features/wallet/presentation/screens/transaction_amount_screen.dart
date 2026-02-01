import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/dialog_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/wallet/bloc/wallet_bloc_export.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_align_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../../../views/widgets/common_widgets/back_button.dart';
import '../../../../shared/custom_container_widget.dart';

enum TransactionType {fundWallet, transfer, withdraw}
class TransactionAmountScreenParams{

  TransactionAmountScreenParams({
    required this.title,
    required this.slidingNotif,
    required this.btnTitle,
    required this.transactionType,
    this.flushBarNotif,
    this.imgPath
  });
  final String title, slidingNotif,
  btnTitle;
  final TransactionType transactionType;
  final String? imgPath, flushBarNotif;
}

class TransactionAmountScreen extends StatelessWidget {
  const TransactionAmountScreen({super.key, required this.params});

  final TransactionAmountScreenParams params;

  static String digits = '123456789.0<';

  @override
  Widget build(BuildContext context) {
    if(params.flushBarNotif != null){
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => showAppNotification(context: context, text: params.flushBarNotif!)
      );
    }

    return ATAnnotatedRegion(
      child: BlocProvider<EnterAmountBloc>(
        create: (_) => EnterAmountBloc(),
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: ATAppBar(
                leading: const ATRoundedBackBtn(),
                leadingWidth: 30,
                padding: const EdgeInsets.only(left: 7),
                titleText: params.title,
              ),
              body: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      if(params.imgPath != null)Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ATCircularImage(
                          imagePath: params.imgPath!,
                          diameter: 50,
                        ),
                      ),

                      BlocBuilder<EnterAmountBloc, (String, bool)>(
                        builder: (_, (String, bool) state) {
                          return Column(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ATRichText(
                                maxLines: 1,
                                items: <String, TextStyle>{
                                  ATStrings.nairaText: context.textTheme.displayMedium!.copyWith(
                                    fontSize: 35,
                                    color: state.$2 == false 
                                      ? ATColors.textRedColor : ATColors.white.withValues(alpha: 0.7),
                                  ),
                                  state.$1.isEmpty ? '0' : state.$1.formatPrice(): context.textTheme.displayMedium!.copyWith(
                                    fontSize: 50,
                                    color: state.$2 == false ? ATColors.textRedColor : null,
                                  ),
                                },
                              ),
                              if(state.$2 == false)Text(
                                ATStrings.insufficientFunds,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: ATColors.textRedColor
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                
                      const SizedBox(height: 50,),
                
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.5
                        ),
                        
                        children: digits.characters.map(
                          (String digit){
                            if(digits.indexOf(digit) == 11){
                              return BlocBuilder<EnterAmountBloc, (String, bool)>(
                                builder: (_, (String, bool) state) {
                                  final bool shouldDisable = state.$1.isEmpty;
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () => shouldDisable ? null : context.read<EnterAmountBloc>().removeLast(),                          
                                    child: Center(
                                      child: Icon(
                                        Icons.keyboard_arrow_left_outlined, size: 30,
                                        color: shouldDisable ? ATColors.white.withValues(alpha: 0.3) : null,
                                      )
                                    ),
                                  );
                                }
                              );
                            }
                            return InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () => context.read<EnterAmountBloc>().grabInput(digit),                            
                              child: Center(
                                child: Text(
                                  digit,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontWeight: ATFontWeights.w500
                                  )
                                ),
                              ),
                            );
                          }
                        ).toList()
                      )
                    ],
                  ),
                ),
              ),
              
              bottomNavigationBar: Column(
                spacing:10,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FutureBuilder<void>(
                    future: Future<void>.delayed(const Duration(seconds: 5)),
                    builder: (_, AsyncSnapshot<void> snapshot) {
                      final bool isDone = snapshot.connectionState == ConnectionState.done;
                      return ATAnimatedAlign(
                        condition: !isDone,
                        startAlignment: Alignment(-ATHelperFuncs.getScreenWidth(context), 0),
                        endAlignment: Alignment.center,
                        child: ATContainer(
                          radius: 14,
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          width: context.screenWidth * 0.92,
                          color: ATColors.white.withValues(alpha: 0.05),
                          child: Row(
                            spacing: 10,
                            children: <Widget>[
                              Icon(Icons.info_outline, color: ATColors.hexC2C2C2),
                              Flexible(
                                child: Text(
                                  params.slidingNotif, maxLines: 3,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: ATSizes.size13,
                                    color: ATColors.hexC2C2C2
                                  )
                                ),
                              ),
                            ],
                          )
                        ),
                      );
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 60),
                    child: BlocBuilder<EnterAmountBloc, (String, bool)>(
                      builder: (_, (String, bool) state) {
                        return ATPlainElevatedBtn(
                          onPressed: (state.$1.isNotEmpty && state.$1 != '0' && state.$2 == true) 
                            ? ()async{
                              switch(params.transactionType){
                                case TransactionType.fundWallet:
                                  final String? selectedPaymentMethod = await selectPaymentMethodDialog(context: context, amount: state.$1);
                                  if(context.mounted && selectedPaymentMethod != null){
                                    final bool? processPayment = await processWalletFundingDialog(
                                      context: context,
                                      paymentMethod: selectedPaymentMethod
                                    );
                                  }
                                  break;
                                case TransactionType.transfer:
                                case TransactionType.withdraw:
                              }
                            } : null,
                          btnTitle: params.btnTitle
                        );
                      }
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
