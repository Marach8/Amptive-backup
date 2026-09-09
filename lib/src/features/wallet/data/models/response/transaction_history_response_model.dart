import 'package:amptive/src/features/wallet/wallet_export.dart';

class TransactionHistoryResponseModel {
  TransactionHistoryResponseModel({
    this.transactions,
    this.nextCursor,
    this.hasMore,
  });

  factory TransactionHistoryResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final Map<String, dynamic> data =
        json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final List<dynamic> transactionsList =
        data['transactions'] as List? ?? <dynamic>[];

    return TransactionHistoryResponseModel(
      transactions: transactionsList
          .map(
            (dynamic e) => TransactionModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      nextCursor: json['next_cursor'] as String?,
      hasMore: json['has_more'] as bool?,
    );
  }

  final List<TransactionModel>? transactions;
  final String? nextCursor;
  final bool? hasMore;
}
