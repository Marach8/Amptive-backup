import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/wallet/data/models/response/fund_wallet_response_model.dart';

import 'package:amptive/src/features/wallet/data/models/request/set_pin_request.dart';
import 'package:amptive/src/features/wallet/data/models/response/security_questions_response_model.dart';
import 'package:amptive/src/features/wallet/data/models/response/transaction_history_response_model.dart';
import 'package:amptive/src/features/wallet/data/models/response/verify_payment_response_model.dart';
import 'package:amptive/src/features/wallet/presentation/screens/wallet_transactions_history_screen.dart';
import 'package:amptive/src/features/wallet/data/models/response/wallet_balance_response_model.dart';

abstract class WalletRepo {
  Future<ApiResponse<dynamic>> setPin({
    required SetPinData param,
  });

  Future<ApiResponse<TransactionHistoryResponseModel>> getTransactionHistory({
    required String cursor,
    required int pageSize,
  });
  Future<ApiResponse<FundWalletResponseModel>> fundWallet({
    required int amount,
    required String channel,
    required String currency,
  });
  Future<ApiResponse<WalletBalanceResponseModel>> fetchWalletBalance();

  Future<ApiResponse<VerifyPaymentResponseModel>> verifyPayment({
    required String reference,
  });

  Future<ApiResponse<SecurityQuestionsResponseModel>> getSecurityQuestions();
}
