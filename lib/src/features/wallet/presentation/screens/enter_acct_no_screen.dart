import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/dialog_export.dart';
import 'package:amptive/src/features/wallet/presentation/screens/transaction_amount_screen.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/elevated_button_widget.dart';

class ATEnterAccountNoScreen extends StatelessWidget {
  const ATEnterAccountNoScreen({super.key, required this.bankName});

  final String bankName;
  static String acctNo = '';

  @override
  Widget build(BuildContext _) {
    return ATAnnotatedRegion(
      child: BlocProvider(
        create: (_) => _EnterAccountNoBloc(),
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: ATAppBar(
                leading: const ATRoundedBackBtn(),
                leadingWidth: 30,
                padding: const EdgeInsets.only(left: 7),
                titleText: bankName
              ),
            
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      maxLines: 2,
                      ATStrings.UR_ACCT_NO,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<_EnterAccountNoBloc, (String?, int?)>(
                      buildWhen: ((String?, int?) prev, (String?, int?) curr) => prev.$2 != curr.$2,
                      builder: (_, (String?, int?) state){
                        return ATTextFormField(
                          keyboardType: TextInputType.number,
                          enabled: state.$2 != 0,
                          fillColor: ATColors.white.withValues(alpha: 0.1),
                          hintText: ATStrings.ENTER_10_DIGIT_ACCT_NO,
                          suffixIcon: const _SuffixIcon(),
                          onChanged: (String text){
                            if(text.length == 9 || text.length == 10 || text.length == 11){
                              context.read<_EnterAccountNoBloc>().checkAccountNo(text);
                              acctNo = text;
                            }
                          },
                        );
                      }
                    ),
                    const SizedBox(height: 10),
                    BlocSelector<_EnterAccountNoBloc, (String?, int?), int?>(
                      selector: ((String?, int?) state) => state.$2,
                      builder: (_, int? state){
                        if(state == null){
                          return const SizedBox.shrink();
                        }
                        else if(state == 0){
                          return Text(
                            ATStrings.CHECKER_LOADING,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: ATSizes.size11
                            ),
                          );
                        }
                        else if(state == 1){
                          final String? name = context.read<_EnterAccountNoBloc>().state.$1;
                          return Text(
                            name ?? '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: ATSizes.size11
                            ),
                          );
                        }
                        else {
                          return Text(
                            ATStrings.INVALID_ACCT_NO,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: ATSizes.size11,
                              color: ATColors.textRedColor
                            ),
                          );
                        }
                      }
                    ),
                  ],
                ),
              ),

              bottomSheet: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: BlocSelector<_EnterAccountNoBloc, (String?, int?), String?>(
                  selector: ((String?, int?) state) => state.$1,
                  builder: (_, String? state){
                    return ATPlainElevatedBtn(
                      onPressed: state == null ? null : 
                        ()async{
                          final BankDetails bankDetail = BankDetails(
                            bankName: bankName,
                            accountNo: acctNo,
                            accountName: state
                          );

                          final bool? shouldSave = await showConfirmationDialog(
                            context: context,
                            title: ATStrings.SAVE_BANK_DETAILS,
                            content: ATStrings.SAVE_BANK_DETAILS_DESC,
                            yesString: ATStrings.SAVE,
                            noString: ATStrings.cancel
                          );

                          if(context.mounted){
                            final String? amount = await context.pushNamed(
                              ATRoutes.transactionAmountScreen,
                              extra: TransactionAmountScreenParams(
                                transactionType: TransactionType.withdraw,
                                title: '${ATStrings.withdraw} to ${bankDetail.accountName.toUpperCase()}',
                                slidingNotif: ATStrings.AMPTIVE_WITHDRAWAL_CHARGES,
                                btnTitle: ATStrings.ENTER_PIN,
                                flushBarNotif: (shouldSave ?? false) ? ATStrings.BANK_DETAIL_SAVED : null
                              ),
                            ) as String?;

                            if(context.mounted && (amount != null)){
                              final bool? shouldProceed = await inputTxnPinDialog(context: context, object: bankDetail);
                              if(context.mounted && (shouldProceed ?? false)){
                                final bool? didPassQuest = await context.pushNamed(ATRoutes.PASS_SECURITY_QUEST) as bool?;
                                if(context.mounted && (didPassQuest ?? false)){
                                  await context.pushNamed(
                                    ATRoutes.PAPER_PLANE_SUCCESS,
                                    extra: <String>[ATStrings.WITHDRAWAL_REQUEST_SENT, ATStrings.WITHDRAWAL_REQUEST_DESC]
                                  );
                                  if(context.mounted){
                                    context.pop();
                                  }
                                }
                              }
                            }
                          }
                        },
                      btnTitle: ATStrings.CONTINUE,
                    );
                  }
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

class _SuffixIcon extends StatelessWidget {
  const _SuffixIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocSelector<_EnterAccountNoBloc, (String?, int?), int?>(
        selector: ((String?, int?) state) => state.$2,
        builder: (_, int? state){
          if(state == null){
            return const SizedBox.shrink();
          }
          else if(state == 0){
            return const Padding(
              padding: EdgeInsets.only(right: 10),
              child: ATLoadingIndicator(size: 20,),
            );
          }
          else if(state == 1){
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.check,
                color: ATColors.successColor,
              ),
            );
          }
          else {
            return Icon(
              Icons.close,
              color: ATColors.textRedColor,
            );
          }
        },
      ),
    );
  }
}


class _EnterAccountNoBloc extends Cubit<(String?, int?)> {
  _EnterAccountNoBloc() : super((null, null));

  void checkAccountNo(String accountNo)async{ 
    if(accountNo.length == 9 || accountNo.length == 11){
      emit((null, null));
      return;
    }
    emit((null, 0));
    await Future.delayed(const Duration(seconds: 3));
    if(accountNo == '2070357374'){
      emit(('ACHILONU JOSEPH IKENNA', 1));
    }
    else{
      emit((null, 2));
    }
  }
}



class BankDetails {

  BankDetails({
    required this.bankName,
    required this.accountNo,
    required this.accountName,
    this.amount
  });
  final String bankName, accountNo, accountName;
  String? amount;
}