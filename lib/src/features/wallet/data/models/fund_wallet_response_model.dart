class FundWalletResponseModel {
  FundWalletResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory FundWalletResponseModel.fromJson(Map<String, dynamic> json) {
    return FundWalletResponseModel(
      status: json['status'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? FundWalletData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final FundWalletData? data;
}

class FundWalletData {
  FundWalletData({
    this.reference,
    this.paymentUrl,
    this.accessCode,
  });

  factory FundWalletData.fromJson(Map<String, dynamic> json) {
    return FundWalletData(
      reference: json['reference'] as String?,
      paymentUrl: json['payment_url'] as String?,
      accessCode: json['access_code'] as String?,
    );
  }

  final String? reference;
  final String? paymentUrl;
  final String? accessCode;
}
