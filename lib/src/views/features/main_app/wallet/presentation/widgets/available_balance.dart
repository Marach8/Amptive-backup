import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/wallet/process_wallet_funding_dialog.dart';
import 'package:amptive/src/utils/dialogs/wallet/select_payment_method_dialog.dart';
import 'package:amptive/src/views/features/main_app/wallet/presentation/views/enter_amount_screen.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer';

class AvailableBalanceWidget extends StatelessWidget {
  const AvailableBalanceWidget({super.key});

  static const list = [ATStrings.FUND_WALLET, ATStrings.TRSF, ATStrings.WITHDRAW];

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      color: ATColors.white.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(15),
      radius: 15,
      child: BlocProvider(
        create: (_) => _VisibilityBloc(),
        child: Builder(
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => context.read<_VisibilityBloc>().toggleBalanceVisibility(),
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Text(
                            ATStrings.AVAILABLE_BAL,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ATColors.hexC2C2C2
                            )
                          ),
                          const SizedBox(width: 5,),
                          BlocBuilder<_VisibilityBloc, bool>(
                            builder: (_, state) {
                              return Icon(
                                state ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: ATColors.hexC2C2C2
                              );
                            }
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    const ATCircularImage(
                      imagePath: ATImgStrings.jpeg2,
                    )
                  ],
                ),
                
                BlocBuilder<_VisibilityBloc, bool>(
                  builder: (_, state) {
                    return Text(
                      state ? 'N 2,345,737.18' : '******',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: ATFontSizes.size30
                      )
                    );
                  }
                ),
                const SizedBox(height: 5),
                BlocBuilder<_VisibilityBloc, bool>(
                  builder: (_, state) {
                    return Text(
                      'Pending balance: ${state ? 'N13,438.00' : '******'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ATColors.hexC2C2C2
                      )
                    );
                  }
                ),
                const SizedBox(height: 10,),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: list.map(
                    (item){
                      IconData icon;
                      switch(item){
                        case ATStrings.FUND_WALLET:
                          icon = Icons.add;
                          break;
                        case ATStrings.TRSF:
                          icon = Icons.sync;
                          break;
                        case ATStrings.WITHDRAW:
                          icon = Icons.arrow_upward;
                          break;
                        default:
                          icon = Icons.add;
                      }
                      return InkWell(
                        onTap: ()async{
                          if(item == ATStrings.FUND_WALLET){                            
                            final inputPrice = await context.pushNamed(
                              ATRoutes.ENTER_AMOUNT_2_TRSF,
                              extra: EnterAmountScreenParams(
                                title: ATStrings.FUND_WALLET,
                                slidingNotif: ATStrings.AMPTIVE_FUNDING_CHARGES,
                                btnTitle: ATStrings.SELECT_PAYMENT_METHOD
                              )
                            ) as String?;

                            if(context.mounted && inputPrice != null){
                              final selectedPaymentMethod = await selectPaymentMethodDialog(context: context, amount: inputPrice);
                              if(context.mounted && selectedPaymentMethod != null){
                                final processPayment = await processWalletFundingDialog(
                                  context: context,
                                  paymentMethod: inputPrice
                                );
                              }
                            }
                          }

                          else if(item == ATStrings.TRSF){
                            final recipientName = await context.pushNamed(ATRoutes.SELECT_RECIPIENT) as String?;
                            if(recipientName != null && context.mounted){
                              context.pushNamed(
                                ATRoutes.PAPER_PLANE_SUCCESS,
                                extra: [ATStrings.TRSF_SUCCESS, '${ATStrings.TRSF_SUCCESS_DESC}$recipientName']
                              );
                            }
                          }
                          
                          else if(item == ATStrings.WITHDRAW){
                            final result = await context.pushNamed(ATRoutes.WITHDRAWAL_LANDING) as bool?;
                            log(result.toString());
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: ATContainer(                          
                          color: ATColors.white.withValues(alpha: 0.1),
                          radius: 20,
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          child: Row(
                            children: [
                              Icon(icon, size: 15,),
                              Text(
                                item,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ).toList()
                )
              ],
            );
          }
        ),
      )
    );
  }
}



class _VisibilityBloc extends Cubit<bool>{
  _VisibilityBloc() : super(false);

  void toggleBalanceVisibility() => emit(!state);
}