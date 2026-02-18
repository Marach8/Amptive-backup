class CommunitiesResponseModel {
  CommunitiesResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
    this.totalItems,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory CommunitiesResponseModel.fromJson(Map<String, dynamic> json) {
    return CommunitiesResponseModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      data: json['data'] != null
          ? CommunitiesData.fromJson(json['data'])
          : null,
      totalItems: json['total'],
      page: json['page'],
      pageSize: json['page_size'],
      totalPages: json['total_pages'],
    );
  }

  bool get hasMore {
    if (page == null || totalPages == null) return false;
    return page! < totalPages!;
  }

  final bool? status;
  final int? statusCode, totalItems, page, pageSize, totalPages;
  final String? message;
  final CommunitiesData? data;
}

class CommunitiesData {
  CommunitiesData({
    this.communities,
  });

  factory CommunitiesData.fromJson(Map<String, dynamic> json) {
    return CommunitiesData(
      communities: (json['communities'] as List<dynamic>?)
          ?.map((dynamic e) => Community.fromJson(e))
          .toList(),
    );
  }

  final List<Community>? communities;
}

class Community {
  Community({
    this.id,
    this.name,
    this.image,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  final String? id, name, image;
}


