import 'package:amptive/src/shared/global_model_objects.dart';

class NotificationsResponseModel {
  const NotificationsResponseModel({
    this.notifications,
    this.unreadCount,
    this.message,
    this.total,
    this.page,
    this.pageSize,
    this.totalPages,
    this.hasMore,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
       final dataObj = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final List<dynamic> notificationsList = (dataObj['notifications'] as List? ?? <dynamic>[]);
    return NotificationsResponseModel(
      notifications: notificationsList
          .map((dynamic e) => Notifications.fromJson(e as Map<String, dynamic>))
          .toList(),
          message: json['message'],
      unreadCount: (dataObj['unread_count'] as List?)?.isNotEmpty == true 
        ? (dataObj['unread_count'] as List).first
        : 0,
      total: json['total'] ,
      page: json['page'],
      pageSize: json['page_size'] ,
      totalPages: json['total_pages'],
      hasMore: (json['page'] ?? 0) < (json['total_pages'] ?? 0),

     
    );
  }

  final List<Notifications>? notifications;
  final String? message;
  final int? unreadCount, total, page, pageSize, totalPages;
  final bool? hasMore;
}
