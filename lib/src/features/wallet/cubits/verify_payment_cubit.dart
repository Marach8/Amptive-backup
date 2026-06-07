import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/wallet/data/models/response/verify_payment_response_model.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyPaymentCubit extends Cubit<ATAppState<VerifyPaymentResponseModel>> {
  VerifyPaymentCubit ({
    WalletRepo? mockWalletRepo
    }) : walletRepo = mockWalletRepo ?? WalletRepoImpl(),
     super(const InitialState<VerifyPaymentResponseModel>());
  
  final WalletRepo walletRepo;

  Future<void> verifyPayment({
    required String reference,
  }) async {
    emit(const LoadingState<VerifyPaymentResponseModel>());
    try {
      final ApiResponse<VerifyPaymentResponseModel> response = await walletRepo.verifyPayment(
        reference: reference,
      );
      response.when(
        successful: (Successful<VerifyPaymentResponseModel> data) {
          emit(SuccessState<VerifyPaymentResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<VerifyPaymentResponseModel> error) {
          emit(FailureState<VerifyPaymentResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<VerifyPaymentResponseModel>('Error verifying payment: $e'));
    }
  }

}
