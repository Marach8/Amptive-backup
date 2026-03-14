import 'package:amptive/src/shared/global_model_objects.dart';

class AllUsersResponseModel {
  AllUsersResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory AllUsersResponseModel.fromJson(Map<String, dynamic> json) {
  final Map<String, dynamic>? dataMap = json['data'] as Map<String, dynamic>?;

    return AllUsersResponseModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      data: (dataMap?['users'] as List<dynamic>?)
          ?.map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'],
      pageSize: json['page_size'],
      totalPages: json['total_pages'],
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
    int? totalPages,
  }) {
    return AllUsersResponseModel(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  bool get hasMore => (page ?? 0) < (totalPages ?? 0);

  final bool? status;
  final String? message;
  final List<User>? data;
  final int? page, pageSize, statusCode, totalPages;
}
