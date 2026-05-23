import 'dart:developer';

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/wallet/data/models/fund_wallet_response_model.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FundWalletCubit extends Cubit<ATAppState<FundWalletResponseModel>>{
  FundWalletCubit ({ 
    WalletRepo? mockWalletRepo
    }) : walletRepo = mockWalletRepo ?? WalletRepoImpl(),
     super(const InitialState<FundWalletResponseModel>());
     final WalletRepo walletRepo;

  Future<void> fundWallet({
    required int amount,
    required String channel,
    required String currency,
  }) async {
    emit(const LoadingState<FundWalletResponseModel>());
    try {
      final ApiResponse<FundWalletResponseModel> response = await walletRepo.fundWallet(
        amount: amount,
        channel: channel,
        currency: currency,
      );
      response.when(
        successful: (Successful<FundWalletResponseModel> data) {
          emit(SuccessState<FundWalletResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<FundWalletResponseModel> error) {
          emit(FailureState<FundWalletResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      log('Error funding wallet: $e');
      emit(FailureState<FundWalletResponseModel>('Error funding wallet: $e'));
    }
  }
}
