import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/features/wallet/cubits/one_time_payment_cubit.dart';
import 'package:amptive/src/features/wallet/cubits/verify_payment_cubit.dart';
import 'package:amptive/src/features/wallet/data/models/response/one_time_payment_response_model.dart';
import 'package:amptive/src/features/wallet/data/models/response/verify_payment_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<bool?> oneTimePaymentDialog({
  required BuildContext context,
  required String paymentMethod, // 'wallet', 'paystack', etc.
  required String contentId,
  required OneTimePaymentCubit oneTimePaymentCubit,
  required VerifyPaymentCubit verifyPaymentCubit,
  required int amount,
}) {
  final bool isWalletPayment = paymentMethod.toLowerCase() == 'wallet';

  return showCupertinoModalPopup<bool>(
    context: context,
    barrierColor: ATColors.black.withValues(alpha: 0.95),
    builder: (BuildContext dialogContext) {
      return MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<OneTimePaymentCubit>.value(
            value: oneTimePaymentCubit..oneTimePayment(
              contentId: contentId, channel: paymentMethod),
          ),
          BlocProvider<VerifyPaymentCubit>.value(
            value: verifyPaymentCubit,
          ),
        ],
        child: Builder(builder: (BuildContext context) {
          return BlocConsumer<OneTimePaymentCubit, ATAppState<OneTimePaymentResponseModel>>(
            listener: (_, ATAppState<OneTimePaymentResponseModel> state) {
              if (state is SuccessState<OneTimePaymentResponseModel>) {
                final String? url = state.newData?.data?.paymentUrl;
                // Only launch URL if it exists (e.g., Paystack). Wallet payments won't have this.
                if (url != null) {
                  launchUrlString(
                    url,
                    mode: LaunchMode.externalApplication,
                    webOnlyWindowName: '_blank',
                  );
                }
              } else if (state is FailureState<OneTimePaymentResponseModel>) {
                showAppNotification2(
                  context: context,
                  text: state.message,
                  type: NotificationType.failure,
                );
              }
            },
            builder: (_, ATAppState<OneTimePaymentResponseModel> paymentState) {
              return BlocConsumer<VerifyPaymentCubit, ATAppState<VerifyPaymentResponseModel>>(
                listener: (_, ATAppState<VerifyPaymentResponseModel> state) {
                  if (state is FailureState<VerifyPaymentResponseModel>) {
                    showAppNotification2(
                      context: context,
                      text: state.message,
                      type: NotificationType.failure,
                    );
                  } else if (state is SuccessState<VerifyPaymentResponseModel>) {
                    final String? status = state.newData?.data?.transaction?.status;
                    if (status != 'successful') {
                      showAppNotification2(
                        context: context,
                        text: 
                            state.newData?.message ??
                            'Payment was not successful',
                        type: NotificationType.failure,
                      );
                    }
                  }
                },
                builder: (_, ATAppState<VerifyPaymentResponseModel> verifyState) {
                  final bool isLoading = paymentState is InitialState<OneTimePaymentResponseModel> || 
                                        paymentState is LoadingState<OneTimePaymentResponseModel>;

                  final bool? didInitiate = paymentState is SuccessState<OneTimePaymentResponseModel>
                      ? true
                      : paymentState is FailureState<OneTimePaymentResponseModel>
                          ? false
                          : null;

                  final String? reference = paymentState is SuccessState<OneTimePaymentResponseModel>
                      ? paymentState.newData?.data?.reference
                      : null;

                  // If it's wallet, a SuccessState on paymentState means it's fully done.
                  // If it's web checkout, we look for explicit verification success.
                  final bool paymentSuccess = isWalletPayment 
                      ? (paymentState is SuccessState<OneTimePaymentResponseModel>)
                      : (verifyState is SuccessState<VerifyPaymentResponseModel> &&
                          verifyState.newData?.data?.transaction?.status == 'successful');

                  final bool paymentFailed = paymentState is FailureState<OneTimePaymentResponseModel> ||
                      (!isWalletPayment && (
                        verifyState is FailureState<VerifyPaymentResponseModel> ||
                        (verifyState is SuccessState<VerifyPaymentResponseModel> &&
                            verifyState.newData?.data?.transaction?.status != 'successful')
                      ));

                  
                  final String? verificationErrorMessage = verifyState
                          is FailureState<VerifyPaymentResponseModel>
                      ? verifyState.message
                      : (verifyState
                                  is SuccessState<VerifyPaymentResponseModel> &&
                              verifyState.newData?.data?.transaction?.status !=
                                  'successful')
                          ?  verifyState.newData?.message ??
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
                                  if (didInitiate == null) ...<Widget>[
                                    const ATLoadingIndicator(),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Processing your payment...',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: context.textTheme.bodySmall,
                                    ),
                                  ],
                                  if (didInitiate != null && paymentSuccess)
                                    const Icon(Icons.check_circle, size: 50, color: Colors.green),
                                  if (didInitiate != null && paymentFailed)
                                    CircleAvatar(
                                      backgroundColor: ATColors.textRedColor,
                                      radius: 25,
                                      child: Icon(Icons.close, size: 35, color: ATColors.white),
                                    ),
                                  if (didInitiate == true && !paymentSuccess && !paymentFailed)
                                    const Icon(Icons.payment_outlined, size: 50),
                                  const SizedBox(height: 20),
                                  if (didInitiate != null) ...<Widget>[
                                    Text(
                                      paymentSuccess
                                          ? 'Payment Successful'
                                          : paymentFailed
                                              ? 'Payment Failed'
                                              : 'Payment Initiated',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: context.textTheme.displaySmall?.copyWith(fontSize: ATSizes.size23),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      paymentSuccess
                                          ? (isWalletPayment 
                                              ? 'The amount has been deducted from your wallet balance.' 
                                              : 'Your payment was successfully completed and verified.')
                                          : paymentFailed
                                              ? (verificationErrorMessage ?? 'Please try checking out again.')
                                              : 'Complete your payment layout in the browser window, then verify.',
                                      style: context.textTheme.bodySmall?.copyWith(color: ATColors.hexC2C2C2),
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),
                          // Only show manual verify button for external gateways (like Paystack)
                          if (!isWalletPayment && 
                              didInitiate == true &&
                              reference != null &&
                              !paymentSuccess)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: BlocBuilder<VerifyPaymentCubit, ATAppState<VerifyPaymentResponseModel>>(
                                builder: (_, ATAppState<VerifyPaymentResponseModel> vs) {
                                  return ATPlainElevatedBtn(
                                    isLoading: vs is LoadingState<VerifyPaymentResponseModel>,
                                    onPressed: () {
                                      context.read<VerifyPaymentCubit>().verifyPayment(reference: reference);
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
                                onPressed: () => Navigator.of(dialogContext).pop(paymentSuccess),
                                btnTitle: ATStrings.goToLive,
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
