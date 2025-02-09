import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveProfileFollowersBloc extends Cubit<List<ObjectWithNotifier<Host>>>{
  AmptiveProfileFollowersBloc(): super(getHostList());

  void removeFollower(String profilePic){
    final newState = List<ObjectWithNotifier<Host>>.from(state);
    newState.removeWhere((follower) => follower.obj.profilePicture == profilePic);
    emit(newState);
  }
}