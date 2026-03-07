import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveProfileFollowersBloc
    extends Cubit<List<ObjectWithNotifier<Host>>> {
  AmptiveProfileFollowersBloc() : super(getHostList());

  void removeFollower(String profilePic) {
    final List<ObjectWithNotifier<Host>> newState =
        List<ObjectWithNotifier<Host>>.from(state);
    newState.removeWhere((ObjectWithNotifier<Host> follower) =>
        follower.obj.profilePicture == profilePic);
    emit(newState);
  }
}
