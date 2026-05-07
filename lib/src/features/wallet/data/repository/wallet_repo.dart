import 'package:amptive/src/config/api_response_and_app_state.dart';

import 'package:amptive/src/features/wallet/data/models/request/set_pin_request.dart';

abstract class WalletRepo {
  Future<ApiResponse<dynamic>> setPin({
    required SetPinData param,
  });

  Future<ApiResponse<dynamic>> fetchWalletBalance();
}
