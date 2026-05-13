import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/wallet/cubits/fund_wallet_cubit.dart';
import 'package:amptive/src/shared/animated_slide.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<bool?> processWalletFundingDialog({
  required BuildContext context,
  required String paymentMethod,
  required int amount,
  String currency = 'NGN',
}) {
  return showCupertinoModalPopup<bool>(
    context: context,
    barrierColor: ATColors.black.withValues(alpha: 0.95),
    builder: (BuildContext dialogContext) {
      return BlocProvider<FundWalletCubit>(
        create: (_) => FundWalletCubit()
          ..fundWallet(
            amount: amount,
            channel: paymentMethod.normalizePaymentChannel(paymentMethod),
            currency: currency,
          ),
        child: Builder(
          builder: (BuildContext blocContext) => SizedBox(
            height: ATHelperFuncs.getScreenHeight(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: BlocBuilder<FundWalletCubit, ATAppState<dynamic>>(
                builder: (_, ATAppState<dynamic> state) {
                  final bool? didFund = state is SuccessState<dynamic>
                      ? true
                      : state is FailureState<dynamic>
                          ? false
                          : null;

                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (didFund == null) ...<Widget>[
                                const ATLoadingIndicator(),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  ATStrings.fundingWallet,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: context.textTheme.bodySmall,
                                ),
                              ],
                              if (didFund == true)
                                const Icon(
                                  Icons.check_circle,
                                  size: 50,
                                ),
                              if (didFund == false)
                                CircleAvatar(
                                  backgroundColor: ATColors.textRedColor,
                                  radius: 25,
                                  child: Icon(Icons.close,
                                      size: 35, color: ATColors.white),
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (didFund != null) ...<Widget>[
                                Text(
                                  didFund
                                      ? ATStrings.walletFundingSuccess
                                      : ATStrings.walletFundingFailed,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: context.textTheme.displaySmall
                                      ?.copyWith(fontSize: ATSizes.size23),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  didFund
                                      ? 'Your wallet balance has been updated'
                                      : state is FailureState<dynamic>
                                          ? state.message
                                          : 'Check your payment method and try again',
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(color: ATColors.hexC2C2C2),
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                      BlocBuilder<FundWalletCubit, ATAppState<dynamic>>(
                        builder: (_, ATAppState<dynamic> state) {
                          final bool isLoading = state is InitialState<dynamic> ||
                              state is LoadingState<dynamic>;
                          return ATAnimatedSlide(
                            shouldSlide: isLoading,
                            endOffset: const Offset(0, 1.5),
                            startOffset: const Offset(0, 0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: ATPlainElevatedBtn(
                                onPressed: () => dialogContext.pop(didFund),
                                btnTitle: ATStrings.backToSite,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}
