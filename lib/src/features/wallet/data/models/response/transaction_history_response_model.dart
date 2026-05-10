import 'package:amptive/src/features/wallet/data/models/models_export.dart';

class TransactionHistoryResponseModel {
  TransactionHistoryResponseModel({
    this.transactions,
    this.nextCursor,
    this.hasMore,
  });

  factory TransactionHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponseModel(
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((dynamic item) =>
              TransactionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
      hasMore: json['has_more'] as bool?,
    );
  }

  final List<TransactionModel>? transactions;
  final String? nextCursor;
  final bool? hasMore;
}
