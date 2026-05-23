import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/wallet/data/models/response/wallet_balance_response_model.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletBalanceCubit extends Cubit<ATAppState<WalletBalanceResponseModel>> {
  WalletBalanceCubit ({
    WalletRepo? mockWalletRepo,
  }): walletRepo = mockWalletRepo ?? WalletRepoImpl(), 
  super( const InitialState<WalletBalanceResponseModel>());
  final WalletRepo walletRepo;

  WalletBalanceResponseModel? get currentWalletBalance => switch (state) {
    InitialState<WalletBalanceResponseModel>(:final WalletBalanceResponseModel? initialData) => initialData,
    LoadingState<WalletBalanceResponseModel>(:final WalletBalanceResponseModel? currentData) => currentData,
    SuccessState<WalletBalanceResponseModel>(:final WalletBalanceResponseModel? newData) => newData,
    FailureState<WalletBalanceResponseModel>(:final WalletBalanceResponseModel? oldData) => oldData,
  };

   
  Future<void> fetchWalletBalance() async {
    try{
    emit(const LoadingState<WalletBalanceResponseModel>());
    
    final ApiResponse<WalletBalanceResponseModel> response = await walletRepo.fetchWalletBalance();

    response.when(
      successful: (Successful<WalletBalanceResponseModel> data) {
        emit(SuccessState<WalletBalanceResponseModel>(newData: data.data));
      }, 
      unSuccessful: (Unsuccessful<WalletBalanceResponseModel> error) {
        emit(FailureState<WalletBalanceResponseModel>(error.error.message));
      });
    } catch (e) {
      emit(const FailureState<WalletBalanceResponseModel>('Error fetching wallet balance.'));
    
     }
    
  }
}
