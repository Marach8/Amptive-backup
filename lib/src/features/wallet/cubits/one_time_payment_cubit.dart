import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/wallet/data/models/response/one_time_payment_response_model.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OneTimePaymentCubit extends Cubit<ATAppState<OneTimePaymentResponseModel>> {
  OneTimePaymentCubit({WalletRepo? mockWalletRepo})
      : walletRepo = mockWalletRepo ?? WalletRepoImpl(),
        super(const InitialState<OneTimePaymentResponseModel>());

  final WalletRepo walletRepo;

  Future<void> oneTimePayment({
    required String contentId,
    required String channel,
  }) async {
    emit(const LoadingState<OneTimePaymentResponseModel>());
    try {
      final ApiResponse<OneTimePaymentResponseModel> response = await walletRepo.oneTimePayment(
        contentId: contentId,
        channel: channel,
      );
      response.when(
        successful: (Successful<OneTimePaymentResponseModel> data) {
          emit(SuccessState<OneTimePaymentResponseModel>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<OneTimePaymentResponseModel> error) {
          emit(FailureState<OneTimePaymentResponseModel>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<OneTimePaymentResponseModel>('Unable to process payment: $e'));
    }
  }
}
