import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/wallet/data/models/models_export.dart';
import 'package:amptive/src/features/wallet/data/models/response/transaction_history_response_model.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo.dart';
import 'package:amptive/src/features/wallet/data/repository/wallet_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionHistoryCubit
    extends Cubit<ATAppState<TransactionHistoryResponseModel>> {
  TransactionHistoryCubit({WalletRepo? mockWalletRepo})
      : walletRepo = mockWalletRepo ?? WalletRepoImpl(),
        super(const InitialState<TransactionHistoryResponseModel>());

  final WalletRepo walletRepo;

  TransactionHistoryResponseModel? get currentTransactionHistoryData =>
      switch (state) {
        InitialState<TransactionHistoryResponseModel>(
          :final TransactionHistoryResponseModel? initialData
        ) =>
          initialData,
        LoadingState<TransactionHistoryResponseModel>(
          :final TransactionHistoryResponseModel? currentData
        ) =>
          currentData,
        SuccessState<TransactionHistoryResponseModel>(
          :final TransactionHistoryResponseModel? newData
        ) =>
          newData,
        FailureState<TransactionHistoryResponseModel>(
          :final TransactionHistoryResponseModel? oldData
        ) =>
          oldData,
      };

  Future<void> fetchTransactionHistory() async {
    final bool hasMore = currentTransactionHistoryData?.hasMore ?? true;
    if (state is LoadingState<TransactionHistoryResponseModel> || !hasMore) {
      return;
    }

    emit(LoadingState<TransactionHistoryResponseModel>(
        currentData: currentTransactionHistoryData));

    try {
      final ApiResponse<dynamic> response =
          await walletRepo.getTransactionHistory(
        cursor: currentTransactionHistoryData?.nextCursor ?? '',
        pageSize: 20,
      );
      response.when(
        successful: (Successful<dynamic> data) {
          final TransactionHistoryResponseModel newResponse =
              data.data as TransactionHistoryResponseModel;
          final List<TransactionModel>? oldTransactions =
              currentTransactionHistoryData?.transactions;
          final  List<TransactionModel>? newTransactions =
              newResponse.transactions;

          final List<TransactionModel> mergedTransactions =
              <TransactionModel>[]..addAll(oldTransactions ?? []);
          if (newTransactions != null) {
            newTransactions.forEach((TransactionModel value) {
              mergedTransactions.add(value);
            });
          }

          final TransactionHistoryResponseModel mergedData =
              TransactionHistoryResponseModel(
            transactions: mergedTransactions,
            nextCursor: newResponse.nextCursor,
            hasMore: newResponse.hasMore ?? false,
          );
          emit(SuccessState<TransactionHistoryResponseModel>(
              newData: mergedData));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<TransactionHistoryResponseModel>(
              error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<TransactionHistoryResponseModel>(
          'Failed to fetch transaction history $e'));
    }
  }

  Future<void> refreshTransactionHistory() async {
    if (state is LoadingState<TransactionHistoryResponseModel>) return;
    emit(LoadingState<TransactionHistoryResponseModel>(
        currentData: currentTransactionHistoryData));

    try {
      final ApiResponse<dynamic> response =
          await walletRepo.getTransactionHistory(
        cursor: '',
        pageSize: 20,
      );
      response.when(
        successful: (Successful<dynamic> data) {
          emit(SuccessState<TransactionHistoryResponseModel>(
              newData: data.data as TransactionHistoryResponseModel));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<TransactionHistoryResponseModel>(
              error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<TransactionHistoryResponseModel>(
          'Failed to refresh transaction history $e'));
    }
  }
}
