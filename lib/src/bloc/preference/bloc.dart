import 'package:amptive/src/bloc/preference/states.dart';
import 'package:bloc/bloc.dart';

import 'events.dart';

class AmptivePreferenceBloc
    extends Bloc<AmptivePreferenceEvent, AmptivePreferenceState> {
  AmptivePreferenceBloc() : super(InitialState()) {
    on<SelectPreferenceEvent>((event, emit) {

      emit(SelectPreferenceState());
    });
  }
}