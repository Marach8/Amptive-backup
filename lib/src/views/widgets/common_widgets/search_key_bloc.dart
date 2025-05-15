import 'package:flutter_bloc/flutter_bloc.dart';

class SearchkeyBloc extends Cubit<String>{
  SearchkeyBloc() : super('');

  void updateSearchKey(String searchKey) => emit(searchKey);
}