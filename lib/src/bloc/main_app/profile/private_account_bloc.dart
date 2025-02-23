
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivateAccountBloc extends Cubit<bool>{
  PrivateAccountBloc(): super(false);

  void togglePrivateAcct() => emit(!state);
}