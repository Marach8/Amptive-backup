import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/wallet/data/models/response/security_questions_response_model.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletSecurityQuestionsCubit extends Cubit<ATAppState<SecurityQuestionsResponseModel>> {
  WalletSecurityQuestionsCubit({WalletRepo? mockWalletRepo})
      : walletRepo = mockWalletRepo ?? WalletRepoImpl(),
        super(const InitialState<SecurityQuestionsResponseModel>());

  final WalletRepo walletRepo;
  SecurityQuestionsResponseModel? get currentSecurityQuestions => switch (state) {
        InitialState<SecurityQuestionsResponseModel>(:final SecurityQuestionsResponseModel? initialData) =>
          initialData,
        LoadingState<SecurityQuestionsResponseModel>(:final SecurityQuestionsResponseModel? currentData) =>
          currentData,
        SuccessState<SecurityQuestionsResponseModel>(:final SecurityQuestionsResponseModel? newData) =>
          newData,
        FailureState<SecurityQuestionsResponseModel>(:final SecurityQuestionsResponseModel? oldData) =>
          oldData,
      };

  

  Future<void> fetchSecurityQuestions() async {
    emit(const LoadingState<SecurityQuestionsResponseModel>());
    try {
      final ApiResponse<SecurityQuestionsResponseModel> response =
          await walletRepo.getSecurityQuestions();

      response.when(successful: (Successful<SecurityQuestionsResponseModel> data) {
        emit(SuccessState<SecurityQuestionsResponseModel>(newData: data.data));
      }, unSuccessful: (Unsuccessful<SecurityQuestionsResponseModel> error) {
        emit(FailureState<SecurityQuestionsResponseModel>(error.error.message));
      });
    } catch (e) {
      emit(
          FailureState<SecurityQuestionsResponseModel>('Error fetching security questions : $e'));
    }
  }
}
