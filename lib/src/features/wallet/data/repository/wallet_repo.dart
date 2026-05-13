import 'package:amptive/src/config/api_response_and_app_state.dart';

import 'package:amptive/src/features/wallet/data/models/request/set_pin_request.dart';
import 'package:amptive/src/features/wallet/data/models/response/transaction_history_response_model.dart';
import 'package:amptive/src/features/wallet/presentation/screens/wallet_transactions_history_screen.dart';

abstract class WalletRepo {
  Future<ApiResponse<dynamic>> setPin({
    required SetPinData param,
  });

  Future<ApiResponse<TransactionHistoryResponseModel>> getTransactionHistory({
    required String cursor,
    required int pageSize,
  });
}
