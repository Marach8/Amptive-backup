import 'package:flutter_bloc/flutter_bloc.dart';

class SubPlanSetupBloc extends Cubit<List<int?>>{
  SubPlanSetupBloc(): super(<int?>[null, null]);

  void selectFee(int? fee) => emit(<int?>[fee, state.last]);

  void setSelectedFee(int? seletedFee) => emit(<int?>[state.first, seletedFee]);

  void resetPlan() => emit(<int?>[null, null]);
}



class CohostFeeSetupBloc extends Cubit<List<int?>>{
  CohostFeeSetupBloc(): super(<int?>[null, 0]);

  void selectFee(int? index) => emit(<int?>[index, state.last]);

  void setSelectedFee(){}

  void removeDesc() => emit(<int?>[state.first, null]);
}