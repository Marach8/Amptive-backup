class SecurityQuestionsResponseModel {
  SecurityQuestionsResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory SecurityQuestionsResponseModel.fromJson(Map<String, dynamic> json) {
    return SecurityQuestionsResponseModel(
      status: json['status'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? SecurityQuestionsData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final SecurityQuestionsData? data;
}

class SecurityQuestionsData {
  SecurityQuestionsData({
    this.securityQuestions,
  });

  factory SecurityQuestionsData.fromJson(Map<String, dynamic> json) {
    return SecurityQuestionsData(
      securityQuestions: json['security_questions'] != null
          ? List<String>.from(json['security_questions'] as List)
          : null,
    );
  }

  final List<String>? securityQuestions;
}
