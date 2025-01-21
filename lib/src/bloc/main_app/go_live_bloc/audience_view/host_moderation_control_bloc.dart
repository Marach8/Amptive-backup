import 'package:flutter_bloc/flutter_bloc.dart';


class AmptiveGoLiveHostModerationToolsBloc extends Cubit<List<bool>>{
  AmptiveGoLiveHostModerationToolsBloc(): super([true, true, true]);

  void allowComments(){
    final newState = List<bool>.from(state);
    newState[0] = true;
    emit(newState);
  }

  void disableComments(){
    final newState = List<bool>.from(state);
    newState[0] = false;
    emit(newState);
  }

  void allowAudienceMic(){
    final newState = List<bool>.from(state);
    newState[1] = true;
    emit(newState);
  }

  void disableAudienceMic(){
    final newState = List<bool>.from(state);
    newState[1] = false;
    emit(newState);
  }

  void allowHandRaising(){
    final newState = List<bool>.from(state);
    newState[2] = true;
    emit(newState);
  }

  void disableHandRaising(){
    final newState = List<bool>.from(state);
    newState[2] = false;
    emit(newState);
  }
}


