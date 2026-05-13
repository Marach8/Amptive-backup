class TransactionModel {
  TransactionModel({
    this.category,
    this.transactionType,
    this.amount,
    this.currency,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      category: json['category'],
      transactionType: json['transaction_type'],
      amount: json['amount'] ,
      currency: json['currency'] ,
      createdAt: json['created_at'],
    );
  }

  final String? currency, category, createdAt, transactionType;
  final double? amount;
  

  Map<String, dynamic> toJson() => <String, dynamic>{
        'category': category,
        'transaction_type': transactionType,
        'amount': amount,
        'currency': currency,
        'created_at': createdAt,

      };
}




