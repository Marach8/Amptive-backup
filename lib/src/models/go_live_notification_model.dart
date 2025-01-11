import 'package:amptive/src/models/host.dart';


class AmptiveGoLiveNotificationModel {
  final HostWithNotifier user;
  final String notificationType;
  final dynamic extraDetail;

  const AmptiveGoLiveNotificationModel({
    required this.user,
    required this.notificationType,
    this.extraDetail,
  });

  @override
  bool operator ==(Object other) {
    return other is AmptiveGoLiveNotificationModel &&
        other.user.host.id == user.host.id &&
        other.notificationType == notificationType &&
        other.extraDetail == extraDetail;
  }

  @override
  int get hashCode => Object.hash(user.host.id, notificationType, extraDetail);
}
