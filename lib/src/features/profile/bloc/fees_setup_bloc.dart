import 'package:flutter_bloc/flutter_bloc.dart';

class SubPlanSetupBloc extends Cubit<List<int?>>{
  SubPlanSetupBloc(): super([null, null]);

  void selectFee(int? fee) => emit([fee, state.last]);

  void setSelectedFee(int? seletedFee) => emit([state.first, seletedFee]);

  void resetPlan() => emit([null, null]);
}



class CohostFeeSetupBloc extends Cubit<List<int?>>{
  CohostFeeSetupBloc(): super([null, 0]);

  void selectFee(int? index) => emit([index, state.last]);

  void setSelectedFee(){}

  void removeDesc() => emit([state.first, null]);
}