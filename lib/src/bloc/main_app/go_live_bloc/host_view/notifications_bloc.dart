import 'package:amptive/src/models/host.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/utils/other_strings.dart';
import '../../../../models/go_live_notification_model.dart';

class AmptiveGoLiveNotificationBloc
    extends Cubit<AmptiveGoLiveNotificationModel> {
  AmptiveGoLiveNotificationBloc()
      : super(AmptiveGoLiveNotificationModel(
            user: ObjectWithNotifier(obj: Host.empty()), notificationType: ''));

  void addTalkingNotification(ObjectWithNotifier<Host> user) =>
      emit(AmptiveGoLiveNotificationModel(
          user: user, notificationType: ATStrings.isTalking));

  void addGiftingNotification(ObjectWithNotifier<Host> user) =>
      emit(AmptiveGoLiveNotificationModel(
          user: user,
          notificationType: ATStrings.IS_GIFTING,
          extraDetail: <String, String>{ATStrings.GIFTED_AMNT: '10,000'}));

  void addPinnedMsgNotification(ObjectWithNotifier<Host> user, String role) =>
      emit(AmptiveGoLiveNotificationModel(
          user: user,
          notificationType: ATStrings.PINNED,
          extraDetail: <String, String>{
            ATStrings.ROLE: role,
            ATStrings.MSG_TITLE: 'Get our newsletter here',
            ATStrings.MSG_CONTENT: 'http://emmanuel.com'
          }));

  void removeNotification() => emit(AmptiveGoLiveNotificationModel(
      user: ObjectWithNotifier(obj: Host.empty()), notificationType: ''));
}
