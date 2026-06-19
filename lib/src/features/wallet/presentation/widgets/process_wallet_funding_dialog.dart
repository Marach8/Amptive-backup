import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/features/wallet/cubits/fund_wallet_cubit.dart';
import 'package:amptive/src/features/wallet/cubits/verify_payment_cubit.dart';
import 'package:amptive/src/features/wallet/data/models/response/fund_wallet_response_model.dart';
import 'package:amptive/src/features/wallet/data/models/response/verify_payment_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      return MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<FundWalletCubit>(
            create: (_) => FundWalletCubit()
              ..fundWallet(
                amount: amount,
                channel: paymentMethod,
                currency: currency,
              ),
          ),
          BlocProvider<VerifyPaymentCubit>(
            create: (_) => VerifyPaymentCubit(),
          ),
        ],
        child: Builder(builder: (BuildContext context) {
          return BlocConsumer<FundWalletCubit,
              ATAppState<FundWalletResponseModel>>(
            listener: (_, ATAppState<FundWalletResponseModel> state) {
              if (state is SuccessState<FundWalletResponseModel>) {
                final String? url = state.newData?.data?.paymentUrl;
                if (url != null) {
                  launchUrlString(
                    url,
                    mode: LaunchMode.externalApplication,
                    webOnlyWindowName: '_blank',
                  );
                }
              }
            },
            builder: (_, ATAppState<FundWalletResponseModel> fundState) {
              return BlocConsumer<VerifyPaymentCubit,
                  ATAppState<VerifyPaymentResponseModel>>(
                listener: (_, ATAppState<VerifyPaymentResponseModel> state) {
                  if (state is FailureState<VerifyPaymentResponseModel>) {
                    showAppNotification2(
                      context: context,
                      text: state.message,
                      type: NotificationType.failure,
                    );
                  } else if (state
                      is SuccessState<VerifyPaymentResponseModel>) {
                    final String? status = state.newData?.data?.data?.status;
                    if (status != 'success') {
                      showAppNotification2(
                        context: context,
                        text: state.newData?.data?.data?.gatewayResponse ??
                            state.newData?.data?.data?.message ??
                            state.newData?.message ??
                            'Payment was not successful',
                        type: NotificationType.failure,
                      );
                    }
                  }
                },
                builder:
                    (_, ATAppState<VerifyPaymentResponseModel> verifyState) {
                  final bool isLoading =
                      fundState is InitialState<FundWalletResponseModel> ||
                          fundState is LoadingState<FundWalletResponseModel>;

                  final bool? didFund =
                      fundState is SuccessState<FundWalletResponseModel>
                          ? true
                          : fundState is FailureState<FundWalletResponseModel>
                              ? false
                              : null;

                  final String? reference =
                      fundState is SuccessState<FundWalletResponseModel>
                          ? fundState.newData?.data?.reference
                          : null;

                  final bool paymentVerified =
                      verifyState is SuccessState<VerifyPaymentResponseModel> &&
                          verifyState.newData?.data?.data?.status == 'success';

                  final bool verificationFailed = verifyState
                          is FailureState<VerifyPaymentResponseModel> ||
                      (verifyState
                              is SuccessState<VerifyPaymentResponseModel> &&
                          verifyState.newData?.data?.data?.status != 'success');

                  final String? verificationErrorMessage = verifyState
                          is FailureState<VerifyPaymentResponseModel>
                      ? verifyState.message
                      : (verifyState
                                  is SuccessState<VerifyPaymentResponseModel> &&
                              verifyState.newData?.data?.data?.status !=
                                  'success')
                          ? verifyState.newData?.data?.data?.gatewayResponse ??
                              verifyState.newData?.data?.data?.message ??
                              verifyState.newData?.message ??
                              'Payment was not successful'
                          : null;

                  return SizedBox(
                    height: ATHelperFuncs.getScreenHeight(context),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (didFund == null) ...<Widget>[
                                    const ATLoadingIndicator(),
                                    const SizedBox(height: 20),
                                    Text(
                                      ATStrings.fundingWallet,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: context.textTheme.bodySmall,
                                    ),
                                  ],
                                  if (didFund == true && paymentVerified)
                                    const Icon(Icons.check_circle, size: 50),
                                  if (didFund == true && verificationFailed)
                                    CircleAvatar(
                                      backgroundColor: ATColors.textRedColor,
                                      radius: 25,
                                      child: Icon(Icons.close,
                                          size: 35, color: ATColors.white),
                                    ),
                                  if (didFund == true &&
                                      !paymentVerified &&
                                      !verificationFailed)
                                    const Icon(
                                        Icons.account_balance_wallet_outlined,
                                        size: 50),
                                  if (didFund == false)
                                    CircleAvatar(
                                      backgroundColor: ATColors.textRedColor,
                                      radius: 25,
                                      child: Icon(Icons.close,
                                          size: 35, color: ATColors.white),
                                    ),
                                  const SizedBox(height: 20),
                                  if (didFund != null) ...<Widget>[
                                    Text(
                                      didFund
                                          ? (paymentVerified
                                              ? ATStrings.walletFundingSuccess
                                              : verificationFailed
                                                  ? ATStrings
                                                      .walletFundingFailed
                                                  : 'Payment initiated')
                                          : ATStrings.walletFundingFailed,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: context.textTheme.displaySmall
                                          ?.copyWith(fontSize: ATSizes.size23),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      didFund
                                          ? (paymentVerified
                                              ? 'Your wallet balance has been updated'
                                              : verificationErrorMessage ??
                                                  'Complete payment in the browser, then verify.')
                                          : 'Check your payment method and try again',
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(color: ATColors.hexC2C2C2),
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),
                          if (didFund == true &&
                              reference != null &&
                              !paymentVerified)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: BlocBuilder<VerifyPaymentCubit,
                                  ATAppState<VerifyPaymentResponseModel>>(
                                builder: (_,
                                    ATAppState<VerifyPaymentResponseModel> vs) {
                                  return ATPlainElevatedBtn(
                                    isLoading: vs is LoadingState<
                                        VerifyPaymentResponseModel>,
                                    onPressed: () {
                                      context
                                          .read<VerifyPaymentCubit>()
                                          .verifyPayment(reference: reference);
                                    },
                                    btnTitle: 'Verify Payment',
                                  );
                                },
                              ),
                            ),
                          ATAnimatedSlide(
                            shouldSlide: isLoading,
                            endOffset: const Offset(0, 1.5),
                            startOffset: const Offset(0, 0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: ATPlainElevatedBtn(
                                onPressed: () =>
                                    dialogContext.pop(paymentVerified),
                                btnTitle: ATStrings.backToSite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
      );
    },
  );
}
