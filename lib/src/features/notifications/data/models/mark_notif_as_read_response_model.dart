import 'package:amptive/src/shared/global_model_objects.dart';

class MarkNotificationAsReadResponseModel {
  MarkNotificationAsReadResponseModel({
    this.notification,
    this.message,
  });

  factory MarkNotificationAsReadResponseModel.fromJson(Map<String, dynamic> json) {
    return MarkNotificationAsReadResponseModel(
      notification: json['data']
          ? Notifications.fromJson(json['data'] as Map<String, dynamic>) 
          : null,
      message: json['message'],
    );
  }

  final Notifications? notification;
  final String? message;
}
