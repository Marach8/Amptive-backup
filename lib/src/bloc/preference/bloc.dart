import 'package:amptive/src/bloc/preference/states.dart';
import 'package:bloc/bloc.dart';

import 'events.dart';

class PreferenceBloc
    extends Bloc<PreferenceEvent, PreferenceState> {
  PreferenceBloc() : super(InitialState()) {
    on<SelectPreferenceEvent>((event, emit) {

      emit(SelectPreferenceState());
    });
  }
}