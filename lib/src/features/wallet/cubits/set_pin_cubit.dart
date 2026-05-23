import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/wallet/data/models/request/set_pin_request.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetPinCubit extends Cubit <ATAppState<dynamic>> {
  SetPinCubit ({ WalletRepo? mockWalletRepo}) :
  walletRepo = mockWalletRepo ?? WalletRepoImpl(),
  super (const InitialState<dynamic>());

  final WalletRepo walletRepo;

  Future<void> setPin({required SetPinData param}) async {
    emit(const LoadingState<dynamic>());
    try {
      final ApiResponse<dynamic> response = await walletRepo.setPin(
        param: param,
      );

      response.when(
        successful: (Successful<dynamic> data) {
          emit(SuccessState<dynamic>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<dynamic>(error.error.message));
        });
    } catch (e) {
      emit(FailureState<dynamic>('Unable to fetch wallet balance: $e'));
    }
  }
}
