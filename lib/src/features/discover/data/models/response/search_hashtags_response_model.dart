import 'package:amptive/src/shared/global_model_objects.dart';

class SearchHashtagsResponseModel {
  const SearchHashtagsResponseModel({
    this.query,
    this.resource,
    this.hashtags,
    this.total,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory SearchHashtagsResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return SearchHashtagsResponseModel(
      query: data['query'] as String?,
      resource: data['resource'] as String?,
      hashtags: (data['items'] as List<dynamic>?)
          ?.map((dynamic e) => HashTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: data['total'] as int?,
      page: data['page'] as int?,
      pageSize: data['page_size'] as int?,
      totalPages: data['total_pages'] as int?,
    );
  }

  final String? query;
  final String? resource;
  
  final List<HashTag>? hashtags;
  final int? total;
  final int? page;
  final int? pageSize;
  final int? totalPages;
}