import 'package:amptive/src/shared/global_model_objects.dart';

class AllUsersResponseModel {
  AllUsersResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
    this.page,
    this.pageSize,
    this.hasMore,
  });

  factory AllUsersResponseModel.fromJson(Map<String, dynamic> json) {
    return AllUsersResponseModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
          ?.map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'],
      pageSize: json['page_size'],
      hasMore: json['has_more'],
    );
  }


  AllUsersResponseModel copyWith({
    bool? status,
    String? message,
    List<User>? data,
    int? page,
    int? pageSize,
    int? statusCode,
    bool? hasMore,
  }) {
    return AllUsersResponseModel(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  final bool? status;
  final String? message;
  final List<User>? data;
  final int? page, pageSize, statusCode;
  final bool? hasMore;
}
