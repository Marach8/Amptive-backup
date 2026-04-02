import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';

class SearchEventsResponseModel {

  factory SearchEventsResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return SearchEventsResponseModel(
      query: data['query'] as String?,
      resource: data['resource'] as String?,
      events: (data['items'] as List<dynamic>?)
          ?.map((dynamic e) => HostedEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: data['total'] as int?,
      page: data['page'] as int?,
      pageSize: data['page_size'] as int?,
      totalPages: data['total_pages'] as int?,
    );
  }
  final String? query;
  final String? resource;
  final List<HostedEvent>? events;
  final int? total;
  final int? page;
  final int? pageSize;
  final int? totalPages;

  const SearchEventsResponseModel({
    this.query,
    this.resource,
    this.events,
    this.total,
    this.page,
    this.pageSize,
    this.totalPages,
  });
}
