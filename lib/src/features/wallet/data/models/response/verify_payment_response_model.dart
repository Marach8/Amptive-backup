class VerifyPaymentResponseModel {
  VerifyPaymentResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory VerifyPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentResponseModel(
      status: json['status'] ,
      statusCode: json['status_code'] ,
      message: json['message'] ,
      data: json['data'] != null
          ? VerifyPaymentData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  VerifyPaymentResponseModel copyWith({
    bool? status,
    int? statusCode,
    String? message,
    VerifyPaymentData? data,
  }) {
    return VerifyPaymentResponseModel(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final VerifyPaymentData? data;
}

class VerifyPaymentData {
  VerifyPaymentData({
    this.status,
    this.data,
    this.purchase,
    this.transaction,
  });

  factory VerifyPaymentData.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentData(
      status: json['status'] as bool?,
      data: json['data'] != null
          ? PaystackTransactionData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
      purchase: json['purchase'],
      transaction: json['transaction'] != null
          ? LocalTransaction.fromJson(
              json['transaction'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  VerifyPaymentData copyWith({
    bool? status,
    PaystackTransactionData? data,
    dynamic purchase,
    LocalTransaction? transaction,
  }) {
    return VerifyPaymentData(
      status: status ?? this.status,
      data: data ?? this.data,
      purchase: purchase ?? this.purchase,
      transaction: transaction ?? this.transaction,
    );
  }

  final bool? status;
  final PaystackTransactionData? data;
  final dynamic purchase;
  final LocalTransaction? transaction;
}

class LocalTransaction {
  LocalTransaction({
    this.id,
    this.status,
    this.amount,
    this.reference,
  });

  factory LocalTransaction.fromJson(Map<String, dynamic> json) {
    return LocalTransaction(
      id: json['id'] as String?,
      status: json['status'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      reference: json['reference'] as String?,
    );
  }

  LocalTransaction copyWith({
    String? id,
    String? status,
    double? amount,
    String? reference,
  }) {
    return LocalTransaction(
      id: id ?? this.id,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      reference: reference ?? this.reference,
    );
  }

  final String? id;
  final String? status;
  final double? amount;
  final String? reference;
}

class PaystackTransactionData {
  PaystackTransactionData({
    this.id,
    this.domain,
    this.status,
    this.reference,
    this.receiptNumber,
    this.amount,
    this.message,
    this.gatewayResponse,
    this.responseCode,
    this.paidAt,
    this.createdAt,
    this.channel,
    this.currency,
    this.ipAddress,
    this.metadata,
    this.authorization,
    this.customer,
    this.fees,
    this.feesSplit,
    this.plan,
    this.split,
    this.orderId,
  });

  factory PaystackTransactionData.fromJson(Map<String, dynamic> json) {
    return PaystackTransactionData(
      id: (json['id'] as num?)?.toInt(),
      domain: json['domain'] as String?,
      status: json['status'] as String?,
      reference: json['reference'] as String?,
      receiptNumber: json['receipt_number'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      message: json['message'] as String?,
      gatewayResponse: json['gateway_response'] as String?,
      responseCode: json['response_code'] as String?,
      paidAt: json['paid_at'] as String?,
      createdAt: json['created_at'] as String?,
      channel: json['channel'] as String?,
      currency: json['currency'] as String?,
      ipAddress: json['ip_address'] as String?,
      metadata: json['metadata'] as String?,
      authorization: json['authorization'] != null
          ? PaystackAuthorization.fromJson(
              json['authorization'] as Map<String, dynamic>,
            )
          : null,
      customer: json['customer'] != null
          ? PaystackCustomer.fromJson(
              json['customer'] as Map<String, dynamic>,
            )
          : null,
      fees: json['fees'] as int?,
      feesSplit: json['fees_split'],
      plan: json['plan'],
      split: json['split'],
      orderId: json['order_id'] as String?,
    );
  }

  PaystackTransactionData copyWith({
    int? id,
    String? domain,
    String? status,
    String? reference,
    String? receiptNumber,
    int? amount,
    String? message,
    String? gatewayResponse,
    String? responseCode,
    String? paidAt,
    String? createdAt,
    String? channel,
    String? currency,
    String? ipAddress,
    String? metadata,
    PaystackAuthorization? authorization,
    PaystackCustomer? customer,
    int? fees,
    dynamic feesSplit,
    dynamic plan,
    dynamic split,
    String? orderId,
  }) {
    return PaystackTransactionData(
      id: id ?? this.id,
      domain: domain ?? this.domain,
      status: status ?? this.status,
      reference: reference ?? this.reference,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      amount: amount ?? this.amount,
      message: message ?? this.message,
      gatewayResponse: gatewayResponse ?? this.gatewayResponse,
      responseCode: responseCode ?? this.responseCode,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
      channel: channel ?? this.channel,
      currency: currency ?? this.currency,
      ipAddress: ipAddress ?? this.ipAddress,
      metadata: metadata ?? this.metadata,
      authorization: authorization ?? this.authorization,
      customer: customer ?? this.customer,
      fees: fees ?? this.fees,
      feesSplit: feesSplit ?? this.feesSplit,
      plan: plan ?? this.plan,
      split: split ?? this.split,
      orderId: orderId ?? this.orderId,
    );
  }

  final int? id;
  final String? domain;
  final String? status;
  final String? reference;
  final String? receiptNumber;
  final int? amount;
  final String? message;
  final String? gatewayResponse;
  final String? responseCode;
  final String? paidAt;
  final String? createdAt;
  final String? channel;
  final String? currency;
  final String? ipAddress;
  final String? metadata;
  final PaystackAuthorization? authorization;
  final PaystackCustomer? customer;
  final int? fees;
  final dynamic feesSplit;
  final dynamic plan;
  final dynamic split;
  final String? orderId;
}

class PaystackAuthorization {
  PaystackAuthorization({
    this.authorizationCode,
    this.bin,
    this.last4,
    this.expMonth,
    this.expYear,
    this.channel,
    this.cardType,
    this.bank,
    this.countryCode,
    this.brand,
    this.reusable,
    this.signature,
    this.accountName,
  });

  factory PaystackAuthorization.fromJson(Map<String, dynamic> json) {
    return PaystackAuthorization(
      authorizationCode: json['authorization_code'] as String?,
      bin: json['bin'] as String?,
      last4: json['last4'] as String?,
      expMonth: json['exp_month'] as String?,
      expYear: json['exp_year'] as String?,
      channel: json['channel'] as String?,
      cardType: json['card_type'] as String?,
      bank: json['bank'] as String?,
      countryCode: json['country_code'] as String?,
      brand: json['brand'] as String?,
      reusable: json['reusable'] as bool?,
      signature: json['signature'] as String?,
      accountName: json['account_name'] as String?,
    );
  }

  PaystackAuthorization copyWith({
    String? authorizationCode,
    String? bin,
    String? last4,
    String? expMonth,
    String? expYear,
    String? channel,
    String? cardType,
    String? bank,
    String? countryCode,
    String? brand,
    bool? reusable,
    String? signature,
    String? accountName,
  }) {
    return PaystackAuthorization(
      authorizationCode: authorizationCode ?? this.authorizationCode,
      bin: bin ?? this.bin,
      last4: last4 ?? this.last4,
      expMonth: expMonth ?? this.expMonth,
      expYear: expYear ?? this.expYear,
      channel: channel ?? this.channel,
      cardType: cardType ?? this.cardType,
      bank: bank ?? this.bank,
      countryCode: countryCode ?? this.countryCode,
      brand: brand ?? this.brand,
      reusable: reusable ?? this.reusable,
      signature: signature ?? this.signature,
      accountName: accountName ?? this.accountName,
    );
  }

  final String? authorizationCode;
  final String? bin;
  final String? last4;
  final String? expMonth;
  final String? expYear;
  final String? channel;
  final String? cardType;
  final String? bank;
  final String? countryCode;
  final String? brand;
  final bool? reusable;
  final String? signature;
  final String? accountName;
}

class PaystackCustomer {
  PaystackCustomer({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.customerCode,
    this.phone,
    this.metadata,
    this.riskAction,
    this.internationalFormatPhone,
  });

  factory PaystackCustomer.fromJson(Map<String, dynamic> json) {
    return PaystackCustomer(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      customerCode: json['customer_code'] as String?,
      phone: json['phone'] as String?,
      metadata: json['metadata'],
      riskAction: json['risk_action'] as String?,
      internationalFormatPhone: json['international_format_phone'] as String?,
    );
  }

  PaystackCustomer copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? customerCode,
    String? phone,
    dynamic metadata,
    String? riskAction,
    String? internationalFormatPhone,
  }) {
    return PaystackCustomer(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      customerCode: customerCode ?? this.customerCode,
      phone: phone ?? this.phone,
      metadata: metadata ?? this.metadata,
      riskAction: riskAction ?? this.riskAction,
      internationalFormatPhone:
          internationalFormatPhone ?? this.internationalFormatPhone,
    );
  }

  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? customerCode;
  final String? phone;
  final dynamic metadata;
  final String? riskAction;
  final String? internationalFormatPhone;
}
