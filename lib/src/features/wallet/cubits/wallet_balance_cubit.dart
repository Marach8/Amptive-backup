import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletBalanceCubit extends Cubit<ATAppState<dynamic>> {
  WalletBalanceCubit ({
    WalletRepo? mockWalletRepo,
  }): walletRepo = mockWalletRepo ?? WalletRepoImpl(), 
  super( const InitialState<dynamic>());
  final WalletRepo walletRepo;

  Future<void> fetchWalletBalance() async {
    try{
    emit(const LoadingState<dynamic>());
    final ApiResponse<dynamic> response = await walletRepo.fetchWalletBalance();

    response.when(
      successful: (Successful<dynamic> data) {
        emit(SuccessState<dynamic>(newData: data.data));
      }, 
      unSuccessful: (Unsuccessful<dynamic> error) {
        emit(FailureState<dynamic>(error.error.message));
      });
    } catch (e) {
      emit(const FailureState<dynamic>('Error fetching wallet balance.'));
    
     }
    
  }
}
