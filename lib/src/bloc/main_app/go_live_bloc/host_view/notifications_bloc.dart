import 'package:amptive/src/models/host.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/go_live_notification_model.dart';
import '../../../../utils/constants/strings/other_strings.dart';

class AmptiveGoLiveNotificationBloc extends Cubit<AmptiveGoLiveNotificationModel>{
  AmptiveGoLiveNotificationBloc(): super(
    AmptiveGoLiveNotificationModel(
      user: ObjectWithNotifier(obj: Host.empty()),
      notificationType: ''
    )
  );

  void addTalkingNotification(ObjectWithNotifier<Host> user) => emit(
    AmptiveGoLiveNotificationModel(
      user: user,
      notificationType: AmptiveOtherStrings.IS_TALKING
    )
  );

  void addGiftingNotification(ObjectWithNotifier<Host> user) => emit(
    AmptiveGoLiveNotificationModel(
      user: user,
      notificationType: AmptiveOtherStrings.IS_GIFTING,
      extraDetail: {AmptiveOtherStrings.GIFTED_AMNT: '10,000'}
    )
  );

  void addPinnedMsgNotification(ObjectWithNotifier<Host> user, String role) => emit(
    AmptiveGoLiveNotificationModel(
      user: user,
      notificationType: AmptiveOtherStrings.PINNED,
      extraDetail: {
        AmptiveOtherStrings.ROLE: role,
        AmptiveOtherStrings.MSG_TITLE: 'Get our newsletter here',
        AmptiveOtherStrings.MSG_CONTENT: 'http://emmanuel.com'
      }
    )
  );

  void removeNotification() => emit(
    AmptiveGoLiveNotificationModel(
      user: ObjectWithNotifier(obj: Host.empty()),
      notificationType: ''
    )
  );
}

