import 'package:flutter_bloc/flutter_bloc.dart';

class AccountTypeBloc extends Cubit<bool>{
  //Initially, we assume creator
  AccountTypeBloc(): super(true);

  void setAcctType(bool type) => emit(type);
}