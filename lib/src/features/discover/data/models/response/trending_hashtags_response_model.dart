// File: trending_tags_response_model.dart
import 'package:amptive/src/shared/global_model_objects.dart';

class TrendingTagsResponseModel {
  const TrendingTagsResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.trendingHashtag
  });

  factory TrendingTagsResponseModel.fromJson(Map<String, dynamic> json) {
    return TrendingTagsResponseModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      trendingHashtag: (json['data'] as List<dynamic>?)
          ?.map((dynamic e) => HashTag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final List<HashTag>? trendingHashtag;
}
