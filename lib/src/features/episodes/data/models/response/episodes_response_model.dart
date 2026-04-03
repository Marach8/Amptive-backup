import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';

// class EpisodesResponseModel {
//   EpisodesResponseModel({
//     this.episodes,
//     this.total,
//     this.page,
//     this.pageSize,
//     this.hasMore,
//   });

//   factory EpisodesResponseModel.fromJson(Map<String, dynamic> json) {
//     final Map<String, dynamic>? data = json['data'] as Map<String, dynamic>?;
//     final int? page = json['page'] as int?;
//     final int? totalPages = json['total_pages'] as int?;
//     return EpisodesResponseModel(
//       episodes: (data?['episodes'] as List<dynamic>?)
//           ?.map((dynamic e) => Episode.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       total: json['total'] as int?,
//       page: page,
//       pageSize: json['page_size'] as int?,
//       hasMore: page != null && totalPages != null && page < totalPages,
//     );
//   }

//   final List<Episode>? episodes;
//   final int? total, page, pageSize;
//   final bool? hasMore;
// }


class EpisodesResponseModel {
  EpisodesResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.episodes,
    this.total,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory EpisodesResponseModel.fromJson(Map<String, dynamic> json) {
    return EpisodesResponseModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      episodes: (json['data']?['episodes'] as List<dynamic>?)
          ?.map((dynamic e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'],
      page: json['page'],
      pageSize: json['page_size'],
      totalPages: json['total_pages'],
    );
  }

  bool get hasMore => (page ?? 0) < (totalPages ?? 0);
  
  final bool? status;
  final int? statusCode, total, page, pageSize, totalPages;
  final String? message;
  final List<Episode>? episodes;
}
