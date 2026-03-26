import 'package:amptive/src/shared/global_model_objects.dart';

class CommunitiesResponseModel {
  CommunitiesResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.communities,
    this.communityIds,
    this.totalItems,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory CommunitiesResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, Community> communitiesMap = <String, Community>{};
    final List<String> communityIds = <String>[];

    final List<dynamic>? rawList =
        (json['data']?['communities'] as List<dynamic>?);

    if (rawList != null) {
      for (final dynamic communityEntry in rawList) {
        final String? id = communityEntry['community_id'];
        if (id != null) {
          communitiesMap[id] = Community.fromJson(communityEntry);
          communityIds.add(id);
        }
      }
    }

    return CommunitiesResponseModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      communities: communitiesMap,
      communityIds: communityIds,
      totalItems: json['total'],
      page: json['page'],
      pageSize: json['page_size'],
      totalPages: json['total_pages'],
    );
  }

  CommunitiesResponseModel copyWith({
    bool? status,
    int? statusCode,
    String? message,
    Map<String, Community>? communities,
    List<String>? communityIds,
    int? totalItems,
    int? page,
    int? pageSize,
    int? totalPages,
  }) {
    return CommunitiesResponseModel(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      communities: communities ?? this.communities,
      communityIds: communityIds ?? this.communityIds,
      totalItems: totalItems ?? this.totalItems,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  bool get hasMore {
    if (page == null || totalPages == null) return false;
    return page! < totalPages!;
  }

  final bool? status;
  final int? statusCode, totalItems, page, pageSize, totalPages;
  final String? message;

  final Map<String, Community>? communities;
  final List<String>? communityIds;
}
