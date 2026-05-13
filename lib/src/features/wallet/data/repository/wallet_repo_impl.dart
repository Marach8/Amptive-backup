import 'dart:developer';

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/endpoints.dart';
import 'package:amptive/src/config/exception.dart';
import 'package:amptive/src/config/services/network_service/dio_network_service_impl.dart';
import 'package:amptive/src/config/services/network_service/network_service.dart';
import 'package:amptive/src/features/wallet/data/models/fund_wallet_response_model.dart';
import 'package:amptive/src/features/wallet/data/models/request/set_pin_request.dart';
import 'package:amptive/src/features/wallet/data/models/response/transaction_history_response_model.dart';
import 'package:amptive/src/features/wallet/data/models/response/wallet_balance_response_model.dart';
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
  Future<ApiResponse<TransactionHistoryResponseModel>> getTransactionHistory({
    required String cursor,
    required int pageSize,
  }) async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.getTransactionHistory,
        queryParameters: <String, dynamic>{
          'cursor': cursor,
          'page_size': pageSize,
        },
      );

      final TransactionHistoryResponseModel transactionHistory =
          TransactionHistoryResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Successful<TransactionHistoryResponseModel>(data: transactionHistory);
    } catch (e) {
      log('Error getting transaction history: $e');
      return Unsuccessful<TransactionHistoryResponseModel>(
        error: ATException.resolveException(e),
      );
    }
  }

@override
  Future<ApiResponse<WalletBalanceResponseModel>> fetchWalletBalance() async {
    try {
      final Response<dynamic> response = await networkService.get(
        ATEndpoints.getWalletBalance,
      );


      return Successful<WalletBalanceResponseModel>(data:  WalletBalanceResponseModel.fromJson(response.data));
    } catch (e) {
      log('Get wallet balance error: $e');
      return Unsuccessful<WalletBalanceResponseModel>(
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
