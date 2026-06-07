import 'package:flutter_bloc/flutter_bloc.dart';

class HostModerationCubit extends Cubit<List<bool>> {
  HostModerationCubit() : super(<bool>[true, true, true]);

  void allowComments() {
    final List<bool> newState = List<bool>.from(state);
    newState[0] = true;
    emit(newState);
  }

  void disableComments() {
    final List<bool> newState = List<bool>.from(state);
    newState[0] = false;
    emit(newState);
  }

  void allowAudienceMic() {
    final List<bool> newState = List<bool>.from(state);
    newState[1] = true;
    emit(newState);
  }

  void disableAudienceMic() {
    final List<bool> newState = List<bool>.from(state);
    newState[1] = false;
    emit(newState);
  }

  void allowHandRaising() {
    final List<bool> newState = List<bool>.from(state);
    newState[2] = true;
    emit(newState);
  }

  void disableHandRaising() {
    final List<bool> newState = List<bool>.from(state);
    newState[2] = false;
    emit(newState);
  }
}
