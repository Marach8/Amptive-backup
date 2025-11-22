import 'package:flutter_bloc/flutter_bloc.dart';

class ATSelectCountryBloc extends Cubit<String?>{
  ATSelectCountryBloc():super(null);

  void selectCountry(String country) => emit(country);
}