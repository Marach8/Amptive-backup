import 'dart:developer';

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/wallet/data/models/fund_wallet_response_model.dart';
import 'package:amptive/src/features/wallet/data/models/request/set_pin_request.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo.dart';
import 'package:dio/dio.dart';

class WalletRepoImpl implements WalletRepo {
  WalletRepoImpl({NetworkService? mockNetworkService})
      : networkService = mockNetworkService ?? DioNetworkServiceImpl();
      final NetworkService networkService;
  
  
  @override
Future<ApiResponse<dynamic>> setPin({required SetPinData param}) async {
  try {

    final Response<dynamic> response = await networkService.post(
      ATEndpoints.setWalletPin,
      data: param.toJson(),
     
    );

    final String message = response.data['message'] as String;
    return Successful<dynamic>(data: message);
  } catch (e) {
    log('Set wallet pin error: $e');
    return Unsuccessful<dynamic>(
      error: ATException.resolveException(e),
    );
  }
}

  @override
  Future<ApiResponse<FundWalletResponseModel>> fundWallet({
    required int amount,
    required String channel,
    required String currency,
  }) async {
    try {
      final Response<dynamic> response = await networkService.post(
        ATEndpoints.fundWallet,
        data: <String, Object>{
          'amount': amount,
          'channel': channel,
          'currency': currency,
        },
      );

     
      return Successful<FundWalletResponseModel>(
        data: FundWalletResponseModel.fromJson(response.data as Map<String, dynamic>),
      );
    } catch (e) {
      log('Error funding wallet: $e');
      return Unsuccessful<FundWalletResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }
}
