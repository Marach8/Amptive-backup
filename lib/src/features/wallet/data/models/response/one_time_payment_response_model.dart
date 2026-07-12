class OneTimePaymentResponseModel {
  OneTimePaymentResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory OneTimePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return OneTimePaymentResponseModel(
      status: json['status'] as bool?,
      statusCode: json['status_code'] ,
      message: json['message'] ,
      data: json['data'] != null
          ? OneTimePaymentData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final OneTimePaymentData? data;
}

class OneTimePaymentData {
  OneTimePaymentData({
    this.reference,
    this.paymentUrl,
    this.accessCode,
    this.transactionStatus,
    this.amount,
    this.currency,
  });

  factory OneTimePaymentData.fromJson(Map<String, dynamic> json) {
    return OneTimePaymentData(
      reference: json['reference'] ,
      paymentUrl: json['payment_url'],
      accessCode: json['access_code'],
      transactionStatus: json['transaction_status'],
      amount: json['amount'],
      currency: json['currency'],
    );
  }

  final String? reference, paymentUrl,accessCode, transactionStatus;
  final num? amount;
  final String? currency;
}
