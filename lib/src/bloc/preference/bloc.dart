import 'package:amptive/src/bloc/preference/states.dart';
import 'package:amptive/src/models/preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../../services/preference_service.dart';
import 'events.dart';

class AmptivePreferenceBloc
    extends Bloc<AmptivePreferenceEvent, AmptivePreferenceState> {
  AmptivePreferenceBloc() : super(InitialState(items: <Preferences>[])) {
    on<LoadPreferencesEvent>((LoadPreferencesEvent event,
        Emitter<AmptivePreferenceState> emit) async {
      await service.getAll();
      emit(SelectPreferenceState(
          items: service.items, selectedItems: <dynamic>[]));
    });

    on<SelectPreferenceCompletedEvent>((SelectPreferenceCompletedEvent event,
        Emitter<AmptivePreferenceState> emit) async {
      emit(SelectPreferenceCompletedState());
      // personalize preferences
      await service.personalize();

      emit(PreferencePersonalizedState());
    });

    on<SelectPreferenceEvent>(
        (SelectPreferenceEvent event, Emitter<AmptivePreferenceState> emit) {
      service.toggleSelectedByIndex(event.selectedIndex);

      emit(SelectPreferenceState(
          items: service.items, selectedItems: service.getSelected()));
    });
  }
  final PreferenceService service = GetIt.I<PreferenceService>();
}
