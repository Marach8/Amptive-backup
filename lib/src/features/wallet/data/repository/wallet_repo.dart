import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/wallet/data/models/fund_wallet_response_model.dart';

import 'package:amptive/src/features/wallet/data/models/request/set_pin_request.dart';

abstract class WalletRepo {
  Future<ApiResponse<dynamic>> setPin({
    required SetPinData param,
  });

  Future<ApiResponse<FundWalletResponseModel>> fundWallet ({
    required int amount,
    required String channel,
    required String currency,
  });
}
