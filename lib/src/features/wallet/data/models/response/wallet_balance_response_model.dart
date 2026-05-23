import 'package:amptive/src/shared/global_model_objects.dart';

class WalletBalanceResponseModel {
  WalletBalanceResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory WalletBalanceResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> dataMap = json['data'] ?? <String, dynamic>{};
    
    return WalletBalanceResponseModel(
      status: json['status'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
      data: WalletBalance.fromJson(dataMap),
    );
  }

  WalletBalanceResponseModel copyWith({
    bool? status,
    int? statusCode,
    String? message,
    WalletBalance? data,
  }) {
    return WalletBalanceResponseModel(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final WalletBalance? data;
}
