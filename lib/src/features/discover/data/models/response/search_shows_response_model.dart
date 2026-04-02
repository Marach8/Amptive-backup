import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';

class SearchShowsResponseModel {

  factory SearchShowsResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return SearchShowsResponseModel(
      query: data['query'] as String?,
      resource: data['resource'] as String?,
      shows: (data['items'] as List<dynamic>?)
          ?.map((dynamic e) => HostedShow.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: data['total'] as int?,
      page: data['page'] as int?,
      pageSize: data['page_size'] as int?,
      totalPages: data['total_pages'] as int?,
    );
  }
  final String? query;
  final String? resource;
  final List<HostedShow>? shows;
  final int? total;
  final int? page;
  final int? pageSize;
  final int? totalPages;

  const SearchShowsResponseModel({
    this.query,
    this.resource,
    this.shows,
    this.total,
    this.page,
    this.pageSize,
    this.totalPages,
  });
}
