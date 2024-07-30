import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_events.dart';
import 'auth_states.dart';

class AmptiveAuthBloc extends Bloc<AmptiveAuthEvent, AmptiveAuthState> {
  AmptiveAuthBloc() : super(InitialAuthState()) {
    on<EditDOBAuthEvent>((event, emit) {
      emit(EditDOBAuthState());
    });

  }
}
