import 'package:amptive/src/bloc/preference/states.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../../services/preference_service.dart';
import 'events.dart';

class AmptivePreferenceBloc
    extends Bloc<AmptivePreferenceEvent, AmptivePreferenceState> {
  final service = GetIt.I<PreferenceService>();

  AmptivePreferenceBloc() : super(InitialState(items: [])) {
    on<LoadPreferencesEvent>((event, emit) async {
      await service.getAll();
      emit(SelectPreferenceState(items: service.items, selectedItems: []));
    });

    on<SelectPreferenceCompletedEvent>((event, emit) async {
      emit(SelectPreferenceCompletedState());
      // personalize preferences
      await service.personalize();

      emit(PreferencePersonalizedState());
    });

    on<SelectPreferenceEvent>((event, emit) {
      service.toggleSelectedByIndex(event.selectedIndex);

      emit(SelectPreferenceState(
          items: service.items, selectedItems: service.getSelected()));
    });
  }
}
