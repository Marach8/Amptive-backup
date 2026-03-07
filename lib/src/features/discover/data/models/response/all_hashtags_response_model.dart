import 'package:amptive/src/shared/global_model_objects.dart';

class AllHashtagsResponseModel {
  const AllHashtagsResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.hashtags,
    this.total,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory AllHashtagsResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? data = json['data'];
    final List<dynamic>? hashtagsList = data?['Hashtags'];

    return AllHashtagsResponseModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      hashtags: hashtagsList
          ?.map((dynamic e) => HashTag.fromJson(e))
          .toList(),
      total: json['total'],
      page: json['page'],
      pageSize: json['page_size'],
      totalPages: json['total_pages'],
    );
  }

  final bool? status;
  final int? statusCode, total, page, pageSize, totalPages;
  final String? message;
  final List<HashTag>? hashtags;
  bool get hasMore => (page ?? 0) < (totalPages ?? 0);

  AllHashtagsResponseModel copyWith({
    bool? status,
    int? statusCode,
    String? message,
    List<HashTag>? hashtags,
    int? total,
    int? page,
    int? pageSize,
    int? totalPages,
  }) {
    return AllHashtagsResponseModel(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      hashtags: hashtags ?? this.hashtags,
      total: total ?? this.total,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
