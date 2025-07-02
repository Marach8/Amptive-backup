import 'package:amptive/src/models/host.dart';


class AmptiveGoLiveNotificationModel {

  const AmptiveGoLiveNotificationModel({
    required this.user,
    required this.notificationType,
    this.extraDetail,
  });
  final ObjectWithNotifier<Host> user;
  final String notificationType;
  final dynamic extraDetail;

  @override
  bool operator ==(Object other) {
    return other is AmptiveGoLiveNotificationModel &&
        other.user.obj.id == user.obj.id &&
        other.notificationType == notificationType &&
        other.extraDetail == extraDetail;
  }

  @override
  int get hashCode => Object.hash(user.obj.id, notificationType, extraDetail);
}
