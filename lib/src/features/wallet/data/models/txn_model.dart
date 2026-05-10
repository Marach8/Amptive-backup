class TransactionModel {
  TransactionModel({
    this.category,
    this.transactionType,
    this.amount,
    this.currency,
    this.createdAt,
    this.profilePicture,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      category: json['category'] as String?,
      transactionType: json['transaction_type'] as String?,
      amount: json['amount'] as String?,
      currency: json['currency'] as String?,
      createdAt: json['created_at'] as String?,
      profilePicture: json['profile_picture'] as String?,
    );
  }

  final String? category;
  final String? transactionType;
  final String? amount;
  final String? currency;
  final String? createdAt;
  final String? profilePicture;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'category': category,
        'transaction_type': transactionType,
        'amount': amount,
        'currency': currency,
        'created_at': createdAt,
        'profile_picture': profilePicture,
      };
}



