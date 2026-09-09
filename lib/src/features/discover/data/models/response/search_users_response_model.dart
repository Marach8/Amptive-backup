import 'package:amptive/src/shared/global_model_objects.dart';

class SearchUsersResponseModel {
  SearchUsersResponseModel({
    this.data,
    this.total,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory SearchUsersResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final List<dynamic> usersList = data['items'] as List? ?? <dynamic>[];
    return SearchUsersResponseModel(
      data: usersList
          .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: data['total'],
      page: data['page'],
      pageSize: data['page_size'],
      totalPages: data['total_pages'],
    );
  }

  final List<User>? data;
  final int? total;
  final int? page;
  final int? pageSize;
  final int? totalPages;
}
